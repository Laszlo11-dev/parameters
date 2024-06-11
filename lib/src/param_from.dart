// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:macros/macros.dart';

/// A macro that annotates a function, which becomes the build method for a
/// generated stateless widget.
///
/// The function must have at least one positional parameter, which is of type
/// BuildContext (and this must be the first parameter).
///
/// Any additional function parameters are turned into fields on the stateless
/// widget.
typedef ParameterList = List<FormalParameterDeclaration>;

macro class ParamFrom
    implements
    // MethodDefinitionMacro,
    //     ConstructorDefinitionMacro,
        ConstructorDeclarationsMacro {
  final String paramGroup;
  final String? library;
  final Library? library2;

  const ParamFrom(this.paramGroup, {this.library2, this.library});


  // @override
  // Future<FutureOr<void>> buildDefinitionForMethod(MethodDeclaration method,
  //     FunctionDefinitionBuilder builder) async {
  //   final clazz = (await builder.typeDeclarationOf(
  //       method.definingType)) as ClassDeclaration;
  //   // builder.
  //   print('functttttttt ${method.returnType.code.toString()}');
  // }
  //
  @override
  Future<FutureOr<void>> buildDeclarationsForConstructor(
      ConstructorDeclaration constructor,
      MemberDeclarationBuilder builder) async {
    var clazz;
    if (library != null) {
      clazz = await builder.resolveIdentifier(
          Uri.parse(library!), paramGroup);
    } else {
      clazz = (await builder.typeDeclarationOf(
          constructor.definingType)) as ClassDeclaration;
    }

    var groupMaker;
    var constructors = await builder.constructorsOf(clazz);
    groupMaker = constructors.firstWhereOrNull((c) {
      return '${clazz.identifier.name}.${c.identifier.name}' ==
          paramGroup;
    });
    /*
      var buildContext = await builder.resolveIdentifier(
  Uri.parse('package:flutter/floating_action_button.dart'), 'BuildContext');

     */

    if (groupMaker != null) {
      var params = <Object>[];
      var positionals = handleParams(
          groupMaker.positionalParameters.toList(),
          constructor.positionalParameters.toList());

      for (var param in positionals) {
        var requiredKeyword = !param.isRequired ? 'required' : '';
        params.addAll([
          '\n$requiredKeyword',
          param.type.code,
          ' ${param.identifier.name},',
        ]);
      }

      var nameds = handleParams(
          groupMaker.namedParameters.toList(),
          constructor.namedParameters.toList());
      for (var param in nameds) {
        // print('parammm ${param.code.parts} // ${param.code.parts}');
        var requiredKeyword = !param.isRequired ? '' : 'required ';
        // params.add(
        //   RawCode.fromParts([
        //     param.code,
        //   ]),
        // );
        //
        params.addAll([
          '\n$requiredKeyword',
          param.type.code,
          ' ${param.identifier.name},',
        ]);
      }

      bool hasParams = params.isNotEmpty;
      List<Object> parts = [
        // Don't use the identifier here because it should just be the raw name.
        'augment  ${clazz.identifier.name}.${constructor.identifier.name}',
        '(',
        if (hasParams) '{',
        ...params,
        if (hasParams) '}',
        ')',
      ];
      parts.add(';');
      // for (var o in parts) {
      //   print(o.toString());
      // }
      builder.declareInType(DeclarationCode.fromParts(parts));
    }
  }

  ParameterList handleParams(ParameterList aList, ParameterList bList) {
    ParameterList bTmp = [];
    bTmp.addAll(bList);

    ParameterList aTmp = [];
    aTmp.addAll(aList);

    for (var e in aList) {
      var tt = bList.firstWhereOrNull((h) =>
      e.identifier.name == h.identifier.name);
      if (tt != null) {
        aTmp[aTmp.indexOf(e)] = tt;
        bTmp.removeWhere((a) => a.identifier.name == tt.name);
      }
    }
    aTmp.addAll(bTmp);
    return aTmp;
  }

  // @override
  // FutureOr<void> buildDefinitionForConstructor(
  //     ConstructorDeclaration constructor,
  //     ConstructorDefinitionBuilder builder) {
  //   // builder.
  //   // // TODO: implement buildDefinitionForConstructor
  //   // throw UnimplementedError();
  // }
  //

}

extension _FirstWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) compare) {
    for (var item in this) {
      if (compare(item)) return item;
    }
    return null;
  }
}

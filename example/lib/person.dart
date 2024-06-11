import 'package:parameters/parameters.dart';

class Person {
  String? name;
  String? salutation;
  int? age;
  String? address;

  Person(
      {required this.name, required this.salutation, this.age, this.address});

  Person.friendOldStyle(
      {required this.name, this.salutation = 'Hi', this.age, this.address});

  @ParamFrom('Person.')
  Person.friendWithMacro({this.salutation = 'Hi'});
}

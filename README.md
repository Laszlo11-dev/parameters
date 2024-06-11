# **parameters macro**

Experimental implementation of the Dart Parameter Group proposal [Using constructor and function parameter lists as implicit parameter groups #2234 (https://github.com/dart-lang/language/issues/2234/)](https://github.com/dart-lang/language/issues/2234/)  via Dart static meta proqramming (macro).


Please note:

- **This is an experimental implementation of an experimental language feature using an experimental implementation of an experimental language feature. What could go wrong...**

- **This package is not working and only intended for the verification of the parameter group proposal.**

- **Due to its limited and temporary state, the license is also limited. Later this may change.**

## Goal
In Object Oriented languages, classes and functional parts have good tooling (extends, implements, override, super, mustCallSuper, to name a few).
But constructor and method **parameter lists** had nothing. The result was long, and copy-pasted code parts.

This macro changes the way we handle parameters: All constructor, method and function definitions are implicit parameter groups.
Any of them within the scope can be added to an other constructor, method and function definition via macro annotation.
The macro
* adds the source parameters to the destination parameter list.
* clears conflicting parameter items by repeatedly overriding items with the same name parameters to the right.
* handles this and super
* and default values


### Example 1: the Flutter FloatingActionButton
In the floating_action_button.dart file the actual class has total 558 lines, including 201 comment line, so 357 real lines.
The default constructor parameter list is 23 lines + it has 3 additional constructors:

- FloatingActionButton.small: 21 lines

- FloatingActionButton.large 21

- FloatingActionButton.extended 26

Hard to follow, easy to miss.

```dart

const FloatingActionButton({
    super.key,
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.heroTag = const _DefaultHeroTag(),
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    required this.onPressed,
    this.mouseCursor,
    this.mini = false,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.isExtended = false,
    this.enableFeedback,
}) : //asserts removed for clarity. 
    _floatingActionButtonType = mini ? _FloatingActionButtonType.small : _FloatingActionButtonType.regular,
    _extendedLabel = null,
    extendedIconLabelSpacing = null,
    extendedPadding = null,
    extendedTextStyle = null;

const FloatingActionButton.small({
        super.key,
        this.child,
        this.tooltip,
        this.foregroundColor,
        this.backgroundColor,
        this.focusColor,
        this.hoverColor,
        this.splashColor,
        this.heroTag = const _DefaultHeroTag(),
        this.elevation,
        this.focusElevation,
        this.hoverElevation,
        this.highlightElevation,
        this.disabledElevation,
        required this.onPressed,
        this.mouseCursor,
        this.shape,
        this.clipBehavior = Clip.none,
        this.focusNode,
        this.autofocus = false,
        this.materialTapTargetSize,
        this.enableFeedback,
}) : // asserts removed
    _floatingActionButtonType = _FloatingActionButtonType.small,
    mini = true,
    isExtended = false,
    _extendedLabel = null,
    extendedIconLabelSpacing = null,
    extendedPadding = null,
    extendedTextStyle = null;
 
// two more similar...
```

With this macro package we can rewrite the constructors: instead of repeating the whole parameter list, we ask the macro to add all parameters of the FloatingActionButton constructor.


```dart
  @ParamFrom('FloatingActionButton.')
  OptimizedFloatingActionButton.small({
        this.autofocus = false,
        this.clipBehavior = Clip.none,
  
  }) 
  ```

The @ParamFrom('FloatingActionButton.') copies all the parameters from the default constructor and overrides the two parameters with the default values*.

We haven't lost anything. The augmented code has all the parameters:

```dart
// Generated code
augment class OptimizedFloatingActionButton {
  augment  OptimizedFloatingActionButton.small({
    prefix0.Key? key,
    prefix1.Widget? child,
    prefix2.String? tooltip,
    prefix3.Color? foregroundColor,
    prefix3.Color? backgroundColor,
    prefix3.Color? focusColor,
    prefix3.Color? hoverColor,
    prefix3.Color? splashColor,
    prefix2.Object? heroTag,
    prefix2.double? elevation,
    prefix2.double? focusElevation,
    prefix2.double? hoverElevation,
    prefix2.double? highlightElevation,
    prefix2.double? disabledElevation,
    required void Function()? onPressed,
    prefix4.MouseCursor? mouseCursor,
    prefix2.bool mini,
    prefix5.ShapeBorder? shape,
    prefix3.Clip clipBehavior,
    prefix6.FocusNode? focusNode,
    prefix2.bool autofocus,
    prefix7.MaterialTapTargetSize? materialTapTargetSize,
    prefix2.bool isExtended,
    prefix2.bool? enableFeedback,});
}

```


With the parameters macro we can spare 3*21 = 63 lines => 17% of the code.
If go further, the default constructor of the FloatingActionButton has 17 command fields with the RawMaterialButton constructor.
That way 80 repeated lines can be avoided, that's 22% save.

The resulting code is not only smaller but easier to understand because it clearly indicates what is the same and where are the differences.
This a Dart feature but Flutter will benefit a lot from it.


### Example 2: Flutter TextField

It unites two words: FormField and TextField and you can see this on its constructor

```dart
 TextFormField({
    super.key,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    @Deprecated(
      'Use `contextMenuBuilder` instead. '
      'This feature was deprecated after v3.3.0-0.5.pre.',
    )
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    this.onChanged,
    GestureTapCallback? onTap,
    bool onTapAlwaysCalled = false,
    TapRegionCallback? onTapOutside,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    super.onSaved,
    super.validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    bool? ignorePointers,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Color? cursorErrorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool? enableInteractiveSelection,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    ScrollController? scrollController,
    super.restorationId,
    bool enableIMEPersonalizedLearning = true,
    MouseCursor? mouseCursor,
    EditableTextContextMenuBuilder? contextMenuBuilder = _defaultContextMenuBuilder,
    SpellCheckConfiguration? spellCheckConfiguration,
    TextMagnifierConfiguration? magnifierConfiguration,
    UndoHistoryController? undoController,
    AppPrivateCommandCallback? onAppPrivateCommand,
    bool? cursorOpacityAnimates,
    ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
    ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    MaterialStatesController? statesController,
    Clip clipBehavior = Clip.hardEdge,
    bool scribbleEnabled = true,
    bool canRequestFocus = true,
  }) 
```

This macro can simplify the code to something like this:

```dart
@ParamFrom('TextField.', library: ''text_field.dart'')
@ParamFrom('FormField.', library: 'package:flutter/widgets.dart')
 TextFormField()

```

The macro will put a doc comment link into the destination comments, pointing to the source parameter list doc comments, if any.

## Motivation

The motivation with this package is to
- explore the Macro solution for the Parameter Group proposal
- decide weather to deploy it as a standalone package or as a part of the core Dart tools.

## Issues
* Default values are not handled by the current version of Macros. So, I had to omit default values at the moment. There is an open issue on Default values, hope it will go through soon.
* 'this.' and 'super.' are not used, all parameters are defined with type. I think it can be done, just didn't have the time.
* The same applies to constructor and method bodies.
* Since resolveIdentifier is depreceated, the library look-up doesn't work.
* I couldn't find a way to use ParamD macros, because parameters do not expose  the definingType. Therefore, instead of the parameter list, I had to put the annotation before the method/contructor.

Due to these issues, the code is less attractive and not usable, but still very promising.

## How to proceed
If the Macros will be a part of Dart, and the missing features will be implemented, than this macro will really make an impact on how we work in Dart/Flutter.

A decision is needed whether this remain a third-party package or will be somehow integrated into the core set.


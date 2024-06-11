import 'person.dart';

/*
fvm dart run --enable-experiment=macros lib/main.dart
 */

main() {
  Person personOS = Person.friendOldStyle(name: "John");
  print(personOS);

  Person personMacro = Person.friendWithMacro(name: "John");
  print(personMacro);
}

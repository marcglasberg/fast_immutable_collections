import "package:meta/meta.dart";
import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("FromISetMixin.any()", () {

  });
}

@immutable
class Students with FromISetMixin<Student, Students> {
  final ISet<Student> _students;

  Students([Iterable<Student> students]) : _students = ISet(students);

  @override
  Students newInstance(ISet<Student> iList) => Students(iList);

  @override
  ISet<Student> get iter => _students;
}

@immutable
abstract class ProtoStudent {
  const ProtoStudent();
}

@immutable
class Student extends ProtoStudent {
  final String name;

  const Student(this.name);

  @override
  String toString() => "Student: $name";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
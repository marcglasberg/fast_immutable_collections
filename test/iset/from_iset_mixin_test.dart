import "package:meta/meta.dart";
import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("Repeating elements doesn't include the copies in the set", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.iter, {james, sara, lucy});
  });

  test("FromISetMixin.any()", () {
    final Students students = Students([Student("James")]);

    expect(students.cast<ProtoStudent>(), isA<ISet<ProtoStudent>>());
  });

  test("FromISetMixin.contains()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.contains(const Student("James")), isTrue);
    expect(students.contains(const Student("John")), isFalse);
  });

  test("FromISetMixin.elementAt()",
      () => expect(() => Students([]).elementAt(0), throwsUnsupportedError));

  test("FromISetMixin.every()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.every((Student student) => student.name.length > 1), isTrue);
    expect(students.every((Student student) => student.name.length > 4), isFalse);
  });

  test("FromISetMixin.expand()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.expand((Student student) => [student, student]),
        allOf(isA<ISet<Student>>(), <Student>{james, sara, lucy}.lock));
    expect(
        students.expand((Student student) => [student, Student(student.name + "2")]),
        allOf(
            isA<ISet<Student>>(),
            <Student>{
              james,
              sara,
              lucy,
              const Student("James2"),
              const Student("Sara2"),
              const Student("Lucy2")
            }.lock));
  });

  test("FromISetMixin.length", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.length, 3);
  });

  test("FromISetMixin.first", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.first, Student("James"));
  });

  test("FromISetMixin.last", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    // TODO: Marcelo, o último elemento não deveria ser Lucy? Não me parece claro o ordenamento.
    // Há algum `compareTo` implícito que eu não soube reconhecer?
    expect(students.last, Student("Lucy"));
  }, skip: true);

  test("FromISetMixin.single | State exception", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(() => students.single, throwsStateError);
  });

  test("FromISetMixin.single | Access",
      () => expect(Students([const Student("James")]).single, const Student("James")));

  test("FromISetMixin.firstWhere()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(
        students.firstWhere((Student student) => student.name.length == 5,
            orElse: () => const Student("John")),
        const Student("James"));
    expect(
        students.firstWhere((Student student) => student.name.length == 4,
            orElse: () => const Student("John")),
        const Student("Sara"));
    expect(
        students.firstWhere((Student student) => student == const Student("Bob"),
            orElse: () => const Student("John")),
        const Student("John"));
  });

  test("FromISetMixin.fold()", () {
    
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

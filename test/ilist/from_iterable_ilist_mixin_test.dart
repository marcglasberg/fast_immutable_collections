import "package:meta/meta.dart";
import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("FromIterableIListMixin.iterator", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Iterator<Student> iterator = students.iterator;

    expect(iterator.current, isNull);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, james);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, sara);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, lucy);
    expect(iterator.moveNext(), isFalse);
    expect(iterator.current, isNull);
  });

  test("FromIterableIListMixin.any()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.any((Student student) => student.name == "James"), isTrue);
    expect(students.any((Student student) => student.name == "John"), isFalse);
  });

  test("FromIterableIListMixin.cast()", () {
    final Students students = Students([Student("James")]);

    expect(() => students.cast<ProtoStudent>(), throwsUnsupportedError);
  });

  test("FromIterableIListMixin.contains()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.contains(const Student("James")), isTrue);
    expect(students.contains(const Student("John")), isFalse);
  });

  test("FromIterableIListMixin.[]", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students[0], const Student("James"));
    expect(students[1], const Student("Sara"));
    expect(students[2], const Student("Lucy"));
  });

  test("FromIterableIListMixin.elementAt()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.elementAt(0), const Student("James"));
    expect(students.elementAt(1), const Student("Sara"));
    expect(students.elementAt(2), const Student("Lucy"));
  });

  test("FromIterableIListMixin.every()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.every((Student student) => student.name.length > 1), isTrue);
    expect(students.every((Student student) => student.name.length > 10), isFalse);
  });

  test("FromIterableIListMixin.expand()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.expand((Student student) => [student, student]),
        allOf(isA<IList<Student>>(), <Student>[james, james, sara, sara, lucy, lucy].lock));
    expect(students.expand((Student student) => <Student>[]),
        allOf(<Student>[].lock, isA<IList<Student>>()));
  });

  test("FromIterableIListMixin.length", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.length, 3);
  });

  test("FromIterableIListMixin.first", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.first, const Student("James"));
  });

  test("FromIterableIListMixin.last", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.last, const Student("Lucy"));
  });

  test("FromIterableIListMixin.single | State Exception", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(() => students.single, throwsStateError);
  });

  test("FromIterableIListMixin.single | Access",
      () => expect(Students([const Student("James")]).single, const Student("James")));

  test("FromIterableIListMixin.firstWhere()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

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

  test("FromIterableIListMixin.fold()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.fold(
            Student("Class"),
            (Student previousStudent, Student currentStudent) =>
                Student(previousStudent.name + " : " + currentStudent.name)),
        const Student("Class : James : Sara : Lucy"));
  });

  test("FromIterableIListMixin.followedBy()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.followedBy([const Student("Bob")]), [james, sara, lucy, const Student("Bob")]);
  });

  test("FromIterableIListMixin.forEach()", () {
    String concatenated = "";

    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    students.forEach((Student student) => concatenated += student.name + ", ");

    expect(concatenated, "James, Sara, Lucy, ");
  });

  test("FromIterableIListMixin.join()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.join(", "), "Student: James, Student: Sara, Student: Lucy");
    expect(Students([]).join(", "), "");
  });

  test("FromIterableIListMixin.lastWhere()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.lastWhere((Student student) => student.name.length == 5,
            orElse: () => const Student("John")),
        const Student("James"));
    expect(
        students.lastWhere((Student student) => student.name.length == 4,
            orElse: () => const Student("John")),
        const Student("Lucy"));
    expect(
        students.lastWhere((Student student) => student == const Student("Bob"),
            orElse: () => const Student("John")),
        const Student("John"));
  });

  test("FromIterableIListMixin.map()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    final Students students = Students([james, sara]);

    expect(students.map((Student student) => Student(student.name + student.name)),
        [const Student("JamesJames"), const Student("SaraSara")]);
  });

  test("FromIterableIListMixin.reduce()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.reduce((Student currentStudent, Student nextStudent) =>
            Student(currentStudent.name + " " + nextStudent.name)),
        Student("James Sara Lucy"));
  });

  test("FromIterableIListMixin.singleWhere()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.singleWhere((Student student) => student.name == "Sara",
            orElse: () => Student("Bob")),
        const Student("Sara"));
    expect(
        students.singleWhere((Student student) => student.name == "Goat",
            orElse: () => Student("Bob")),
        const Student("Bob"));
  });

  test("FromIterableIListMixin.skip()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.skip(2), [const Student("Lucy")]);
    expect(students.skip(10), <Student>[]);
  });

  test("FromIterableIListMixin.skipWhile()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.skipWhile((Student student) => student.name.length > 4),
        [const Student("Sara"), const Student("Lucy")]);
  });

  test("FromIterableIListMixin.take()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.take(0), <Student>[]);
    expect(students.take(1), <Student>[const Student("James")]);
    expect(students.take(2), <Student>[const Student("James"), const Student("Sara")]);
    expect(students.take(3),
        <Student>[const Student("James"), const Student("Sara"), const Student("Lucy")]);
    expect(students.take(10),
        <Student>[const Student("James"), const Student("Sara"), const Student("Lucy")]);
  });

  test("FromIterableIListMixin.takeWhile()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.takeWhile((Student student) => student.name.length >= 5),
        [const Student("James")]);
  });

  test("FromIterableIListMixin.where()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.where((Student student) => student.name.length == 5), [const Student("James")]);
    expect(students.where((Student student) => student.name.length == 100), <Student>[]);
  });

  test("FromIterableIListMixin.whereType()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.whereType<Student>(),
        [const Student("James"), const Student("Sara"), const Student("Lucy")]);
    expect(students.whereType<String>(), []);
  });

  test("FromIterableIListMixin.isEmpty", () {
    expect(Students([]).isEmpty, isTrue);
    expect(Students([Student("James")]).isEmpty, isFalse);
  });

  test("FromIterableIListMixin.isNotEmpty", () {
    expect(Students([]).isNotEmpty, isFalse);
    expect(Students([Student("James")]).isNotEmpty, isTrue);
  });

  test("FromIterableIListMixin.toList()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.toList(), [const Student("James"), const Student("Sara"), const Student("Lucy")]);
  });

  test("FromIterableIListMixin.toSet()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, sara, lucy]);

    expect(
        students.toSet(), [const Student("James"), const Student("Sara"), const Student("Lucy")]);
  });
}

@immutable
class Students with FromIterableIListMixin<Student> {
  final IList<Student> _students;

  Students([Iterable<Student> students]) : _students = IList(students);

  @override
  IList<Student> get iter => _students;
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

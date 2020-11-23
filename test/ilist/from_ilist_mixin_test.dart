import "package:meta/meta.dart";
import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("FromIListMixin.unlock", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.unlock, allOf(isA<List<Student>>(), [james, sara, lucy]));
  });

  test("FromIListMixin.iterator", () {
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

  test("FromIListMixin.any()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.any((Student student) => student.name == "James"), isTrue);
    expect(students.any((Student student) => student.name == "John"), isFalse);
  });

  test("FromIListMixin.cast()", () {
    final Students students = Students([Student("James")]);

    expect(students.cast<ProtoStudent>(), isA<IList<ProtoStudent>>());
  });

  test("FromIListMixin.contains()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.contains(const Student("James")), isTrue);
    expect(students.contains(const Student("John")), isFalse);
  });

  test("FromIListMixin.[] operator", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students[0], const Student("James"));
    expect(students[1], const Student("Sara"));
    expect(students[2], const Student("Lucy"));
  });

  test("FromIListMixin.elementAt()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.elementAt(0), const Student("James"));
    expect(students.elementAt(1), const Student("Sara"));
    expect(students.elementAt(2), const Student("Lucy"));
  });

  test("FromIListMixin.every()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.every((Student student) => student.name.length > 1), isTrue);
    expect(students.every((Student student) => student.name.length > 10), isFalse);
  });

  test("FromIListMixin.expand()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.expand((Student student) => [student, student]),
        allOf(isA<IList<Student>>(), <Student>[james, james, sara, sara, lucy, lucy].lock));
    expect(students.expand((Student student) => <Student>[]),
        allOf(<Student>[].lock, isA<IList<Student>>()));
  });

  test("FromIListMixin.length", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.length, 3);
  });

  test("FromIListMixin.first", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.first, const Student("James"));
  });

  test("FromIListMixin.last", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.last, const Student("Lucy"));
  });

  test("FromIListMixin.single | State exception", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(() => students.single, throwsStateError);
  });

  test("FromIListMixin.single | Access",
      () => expect(Students([const Student("James")]).single, const Student("James")));

  test("FromIListMixin.firstWhere()", () {
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

  test("FromIListMixin.fold()", () {
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

  test("FromIListMixin.followedBy()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.followedBy([const Student("Bob")]).unlock,
        [james, sara, lucy, const Student("Bob")]);
  });

  test("FromIListMixin.forEach()", () {
    String concatenated = "";

    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    students.forEach((Student student) => concatenated += student.name + ", ");

    expect(concatenated, "James, Sara, Lucy, ");
  });

  test("FromIListMixin.join()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.join(", "), "Student: James, Student: Sara, Student: Lucy");
    expect(Students([]).join(", "), "");
  });

  test("FromIListMixin.lastWhere()", () {
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

  test("FromIListMixin.map()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    final Students students = Students([james, sara]);

    expect(students.map((Student student) => Student(student.name + student.name)),
        [const Student("JamesJames"), const Student("SaraSara")]);
  });

  test("FromIListMixin.reduce()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.reduce((Student currentStudent, Student nextStudent) =>
            Student(currentStudent.name + " " + nextStudent.name)),
        Student("James Sara Lucy"));
  });

  test("FromIListMixin.singleWhere()", () {
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

  test("FromIListMixin.skip()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.skip(2), [const Student("Lucy")]);
    expect(students.skip(10), <Student>[]);
  });

  test("FromIListMixin.skipWhile()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.skipWhile((Student student) => student.name.length > 4),
        [const Student("Sara"), const Student("Lucy")]);
  });

  test("FromIListMixin.take()", () {
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

  test("FromIListMixin.takeWhile()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.takeWhile((Student student) => student.name.length >= 5),
        [const Student("James")]);
  });

  test("FromIListMixin.where()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.where((Student student) => student.name.length == 5), [const Student("James")]);
    expect(students.where((Student student) => student.name.length == 100), <Student>[]);
  });

  test("FromIListMixin.whereType()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.whereType<Student>(),
        [const Student("James"), const Student("Sara"), const Student("Lucy")]);
    expect(students.whereType<String>(), []);
  });

  test("FromIListMixin.isEmpty", () {
    expect(Students([]).isEmpty, isTrue);
    expect(Students([Student("James")]).isEmpty, isFalse);
  });

  test("FromIListMixin.isNotEmpty", () {
    expect(Students([]).isNotEmpty, isFalse);
    expect(Students([Student("James")]).isNotEmpty, isTrue);
  });

  test("FromIListMixin.toList()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.toList(), [const Student("James"), const Student("Sara"), const Student("Lucy")]);
  });

  test("FromIListMixin.toSet()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, sara, lucy]);

    expect(
        students.toSet(), [const Student("James"), const Student("Sara"), const Student("Lucy")]);
  });

  test("FromIListMixin.+()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Students studentsResult = students + [james];

    expect(studentsResult.unlock, [
      const Student("James"),
      const Student("Sara"),
      const Student("Lucy"),
      const Student("James")
    ]);
  });

  test("FromIListMixin.add()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Students studentsResult = students.add(const Student("Bob"));

    expect(studentsResult.unlock, [james, sara, lucy, const Student("Bob")]);
  });

  test("FromIListMixin.addAll()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Students studentsResult = students.addAll([const Student("Bob"), const Student("John")]);

    expect(studentsResult.unlock, [james, sara, lucy, const Student("Bob"), const Student("John")]);
  });

  test("FromIListMixin.asMap()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.asMap().unlock, {
      0: const Student("James"),
      1: const Student("Sara"),
      2: const Student("Lucy"),
    });
  });

  test("FromIListMixin.clear()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    students.clear();

    // TODO: Marcelo, o método `clear()` está retornando `void`. Ele não deveria
    // retornar a nova instância?
    expect(students.iter.unlock, <Student>[]);

    // final Students studentsResult = students.clear();

    // expect(studentsResult.iter.unlock, <Student>[]);
  });

  test("FromIListMixin.equalItems()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.equalItems([james, sara, lucy]), isTrue);
    expect(students.equalItems([sara, lucy, james]), isFalse);
    expect(students.equalItems([james]), isFalse);
  });

  test("FromIListMixin.fillRange()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.fillRange(1, 3, Student("Placeholder")).iter,
        [james, const Student("Placeholder"), const Student("Placeholder")]);
  });

  test("FromIListMixin.firstOr()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.firstOr(const Student("Bob")), const Student("James"));
    expect(Students([]).firstOr(const Student("Bob")), const Student("Bob"));
  });

  test("FromIListMixin.firstOrNull", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.firstOrNull, const Student("James"));
    expect(Students([]).firstOrNull, isNull);
  });

  test("FromIListMixin.getRange()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.getRange(1, 3), [const Student("Sara"), const Student("Lucy")]);
  });

  test("FromIListMixin.indexOf()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);
    
    expect(students.indexOf(const Student("James")), 0);
    expect(students.indexOf(const Student("Sara")), 1);
    expect(students.indexOf(const Student("Lucy")), 2);
    expect(students.indexOf(const Student("Bob")), -1);
  });
}

@immutable
class Students with FromIListMixin<Student, Students> {
  final IList<Student> _students;

  Students([Iterable<Student> students]) : _students = IList(students);

  @override
  Students newInstance(IList<Student> iList) => Students(iList);

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

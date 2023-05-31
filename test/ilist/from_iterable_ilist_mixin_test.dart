// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";
import "package:test/test.dart";

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
  });

  test("iterator", () {
    Student james = Student("James");
    Student sara = Student("Sara");
    Student lucy = Student("Lucy");
    Students students = Students([james, sara, lucy]);

    Iterator<Student?> iterator = students.iterator;

    // Throws StateError before first moveNext().
    expect(() => iterator.current, throwsStateError);

    iterator = students.iterator;
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, james);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, sara);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, lucy);
    expect(iterator.moveNext(), isFalse);

    // Throws StateError after last moveNext().
    expect(() => iterator.current, throwsStateError);
  });

  test("any", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.any((Student? student) => student!.name == "James"), isTrue);
    expect(students.any((Student? student) => student!.name == "John"), isFalse);
  });

  test("cast", () {
    final Students students = Students([Student("James")]);

    expect(() => students.cast<ProtoStudent>(), throwsUnsupportedError);
  });

  test("contains", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.contains(const Student("James")), isTrue);
    expect(students.contains(const Student("John")), isFalse);
    expect(students.contains(null), isFalse);
  });

  test("[]", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students[0], const Student("James"));
    expect(students[1], const Student("Sara"));
    expect(students[2], const Student("Lucy"));
  });

  test("elementAt", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.elementAt(0), const Student("James"));
    expect(students.elementAt(1), const Student("Sara"));
    expect(students.elementAt(2), const Student("Lucy"));
  });

  test("every", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.every((Student? student) => student!.name.length > 1), isTrue);
    expect(students.every((Student? student) => student!.name.length > 10), isFalse);
  });

  test("expand", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.expand((Student student) => [student, student]),
        allOf(isA<Iterable<Student>>(), <Student>[james, james, sara, sara, lucy, lucy].lock));

    expect(students.expand((Student student) => <Student>[]),
        allOf(<Student>[].lock, isA<Iterable<Student>>()));
  });

  test("length", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.length, 3);
  });

  test("first", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.first, const Student("James"));
  });

  test("last", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.last, const Student("Lucy"));
  });

  test("single", () {
    // 1) State Exception
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(() => students.single, throwsStateError);

    // 2) Access
    expect(Students([const Student("James")]).single, const Student("James"));
  });

  test("firstOrNull | lastOrNull | singleOrNull", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    // 1) firstOrNull
    expect(Students([]).firstOrNull, isNull);
    expect(students.firstOrNull, Student("James"));

    // 2) lastOrNull
    expect(Students([]).lastOrNull, isNull);
    expect(students.lastOrNull, Student("Lucy"));

    // 3) singleOrNull
    expect(Students([]).singleOrNull, isNull);
    expect(students.singleOrNull, isNull);
    expect(Students([Student("James")]).singleOrNull, Student("James"));
  });

  test("firstWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.firstWhere((Student? student) => student!.name.length == 5,
            orElse: () => const Student("John")),
        const Student("James"));
    expect(
        students.firstWhere((Student? student) => student!.name.length == 4,
            orElse: () => const Student("John")),
        const Student("Sara"));
    expect(
        students.firstWhere((Student? student) => student == const Student("Bob"),
            orElse: () => const Student("John")),
        const Student("John"));
  });

  test("firstWhereOrNull", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.firstWhereOrNull((Student student) => student == Student("Lucy")),
        Student("Lucy"));
    expect(students.firstWhereOrNull((Student student) => student == Student("Marcus")), null);
  });

  test("fold", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.fold(
            Student("Class"),
            (Student previousStudent, Student? currentStudent) =>
                Student(previousStudent.name + " : " + currentStudent!.name)),
        const Student("Class : James : Sara : Lucy"));
  });

  test("followedBy", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    const Student bob = Student("Bob");
    const Student charles = Student("Charles");

    final Students students = Students([james, sara, lucy]);

    expect(students.followedBy([bob]), [james, sara, lucy, bob]);
    expect(students.followedBy([bob, charles].lock), [james, sara, lucy, bob, charles]);
  });

  test("forEach", () {
    String concatenated = "";

    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    students.forEach((Student? student) => concatenated += student!.name + ", ");

    expect(concatenated, "James, Sara, Lucy, ");
  });

  test("join", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.join(", "), "Student: James, Student: Sara, Student: Lucy");
    expect(Students([]).join(", "), "");
  });

  test("lastWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.lastWhere((Student? student) => student!.name.length == 5,
            orElse: () => const Student("John")),
        const Student("James"));
    expect(
        students.lastWhere((Student? student) => student!.name.length == 4,
            orElse: () => const Student("John")),
        const Student("Lucy"));
    expect(
        students.lastWhere((Student? student) => student == const Student("Bob"),
            orElse: () => const Student("John")),
        const Student("John"));
  });

  test("map", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    final Students students = Students([james, sara]);

    expect(students.map((Student? student) => Student(student!.name + student.name)),
        [const Student("JamesJames"), const Student("SaraSara")]);
  });

  test("reduce", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.reduce((Student? currentStudent, Student? nextStudent) =>
            Student(currentStudent!.name + " " + nextStudent!.name)),
        Student("James Sara Lucy"));
  });

  test("singleWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.singleWhere((Student? student) => student!.name == "Sara",
            orElse: () => Student("Bob")),
        const Student("Sara"));
    expect(
        students.singleWhere((Student? student) => student!.name == "Goat",
            orElse: () => Student("Bob")),
        const Student("Bob"));
  });

  test("skip", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.skip(2), [const Student("Lucy")]);
    expect(students.skip(10), <Student>[]);
  });

  test("skipWhile", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.skipWhile((Student? student) => student!.name.length > 4),
        [const Student("Sara"), const Student("Lucy")]);
  });

  test("take", () {
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

  test("takeWhile", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.takeWhile((Student? student) => student!.name.length >= 5),
        [const Student("James")]);
  });

  test("where", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.where((Student? student) => student!.name.length == 5), [const Student("James")]);
    expect(students.where((Student? student) => student!.name.length == 100), <Student>[]);
  });

  test("whereType", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.whereType<Student>(),
        [const Student("James"), const Student("Sara"), const Student("Lucy")]);
    expect(students.whereType<String>(), []);
  });

  test("isEmpty", () {
    // isEmpty
    expect(Students([]).isEmpty, isTrue);
    expect(Students([Student("James")]).isEmpty, isFalse);

    // isNotEmpty
    expect(Students([]).isNotEmpty, isFalse);
    expect(Students([Student("James")]).isNotEmpty, isTrue);
  });

  test("toList", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.toList(), [const Student("James"), const Student("Sara"), const Student("Lucy")]);
  });

  test("toSet", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, sara, lucy]);

    expect(
        students.toSet(), [const Student("James"), const Student("Sara"), const Student("Lucy")]);
  });

  test("toString", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    // 1) Global configuration prettyPrint == false
    ImmutableCollection.prettyPrint = false;
    expect(students.toString(), "Students[Student: James, Student: Sara, Student: Lucy]");

    // 2) Global configuration prettyPrint == true
    ImmutableCollection.prettyPrint = true;
    expect(
        students.toString(),
        "Students[\n"
        "   Student: James,\n"
        "   Student: Sara,\n"
        "   Student: Lucy\n"
        "]");
  });
}

@immutable
class Students with FromIterableIListMixin<Student> {
  final IList<Student> _students;

  Students([Iterable<Student>? students]) : _students = IList(students);

  @override
  IList<Student> get iter => _students;
}

@immutable
abstract class ProtoStudent {
  const ProtoStudent();
}

@immutable
class Student extends ProtoStudent implements Comparable<Student> {
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

  @override
  int compareTo(Student other) => name.compareTo(other.name);
}

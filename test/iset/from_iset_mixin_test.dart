import "dart:collection";

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
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.any((Student student) => student.name == "James"), isTrue);
    expect(students.any((Student student) => student.name == "John"), isFalse);
  });

  test("FromISetMixin.cast()", () {
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

  test("FromISetMixin.containsAll()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.containsAll([james]), isTrue);
    expect(students.containsAll([james, sara]), isTrue);
    expect(students.containsAll([james, sara, lucy]), isTrue);
    expect(students.containsAll([james, sara, lucy, const Student("Bob")]), isFalse);
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

  test("FromISetMixin.length, first, last and single", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    print('XXstudents = ${students}');

    // TODO: Marcelo, o último elemento não deveria ser Lucy? Não me parece claro o ordenamento.
    // Há algum `compareTo` implícito que eu não soube reconhecer?
    expect(students.length, 3);
    expect(students.first, Student("James"));
    expect(students.last, Student("Lucy"));
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
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(
        students.fold(
            Student("Class"),
            (Student previousStudent, Student currentStudent) =>
                Student(previousStudent.name + " : " + currentStudent.name)),
        const Student("Class : James : Sara : Lucy"));
  });

  test("FromISetMixin.followedBy()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.followedBy([const Student("Bob")]).unlock,
        {james, sara, lucy, const Student("Bob")});
  });

  test("FromISetMixin.forEach()", () {
    String concatenated = "";

    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    students.forEach((Student student) => concatenated += student.name + ", ");

    expect(concatenated, "James, Sara, Lucy, ");
  });

  test("FromISetMixin.join()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.join(", "), "Student: James, Student: Sara, Student: Lucy");
    expect(Students([]).join(", "), "");
  });

  test("FromISetMixin.lastWhere()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

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

  test("FromISetMixin.map()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    final Students students = Students([james, sara]);

    expect(students.map((Student student) => Student(student.name + student.name)),
        {const Student("JamesJames"), const Student("SaraSara")});
  });

  test("FromISetMixin.reduce()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(
        students.reduce((Student currentStudent, Student nextStudent) =>
            Student(currentStudent.name + " " + nextStudent.name)),
        Student("James Sara Lucy"));
  });

  test("FromISetMixin.singleWhere()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(
        students.singleWhere((Student student) => student.name == "Sara",
            orElse: () => Student("Bob")),
        const Student("Sara"));
    expect(
        students.singleWhere((Student student) => student.name == "Goat",
            orElse: () => Student("Bob")),
        const Student("Bob"));
  });

  test("FromISetMixin.skip()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.skip(2), {const Student("Lucy")});
    expect(students.skip(10), <Student>{});
  });

  test("FromISetMixin.skipWhile()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.skipWhile((Student student) => student.name.length > 4),
        {const Student("Sara"), const Student("Lucy")});
  });

  test("FromISetMixin.take()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.take(0), <Student>{});
    expect(students.take(1), <Student>{const Student("James")});
    expect(students.take(2), <Student>{const Student("James"), const Student("Sara")});
    expect(students.take(3),
        <Student>{const Student("James"), const Student("Sara"), const Student("Lucy")});
    expect(students.take(10),
        <Student>{const Student("James"), const Student("Sara"), const Student("Lucy")});
  });

  test("FromISetMixin.takeWhile()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.takeWhile((Student student) => student.name.length >= 5),
        {const Student("James")});
  });

  test("FromISetMixin.where()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.where((Student student) => student.name.length == 5), {const Student("James")});
    expect(students.where((Student student) => student.name.length == 100), <Student>{});
  });

  test("FromISetMixin.whereType()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.whereType<Student>(),
        {const Student("James"), const Student("Sara"), const Student("Lucy")});
    expect(students.whereType<String>(), <Student>{});
  });

  test("FromISetMixin.isEmpty", () {
    expect(Students([]).isEmpty, isTrue);
    expect(Students([Student("James")]).isEmpty, isFalse);
  });

  test("FromISetMixin.isNotEmpty", () {
    expect(Students([]).isNotEmpty, isFalse);
    expect(Students([Student("James")]).isNotEmpty, isTrue);
  });

  test("FromISetMixin.iterator", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

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

  test("FromISetMixin.toList()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(
        students.toList(), [const Student("James"), const Student("Sara"), const Student("Lucy")]);
  });

  test("FromISetMixin.toSet()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(
        students.toSet(), {const Student("James"), const Student("Sara"), const Student("Lucy")});
  });

  test("FromISetMixin.+()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    final Students studentsResult = students + [james, const Student("Bob")];

    expect(studentsResult.unlock, {
      const Student("James"),
      const Student("Sara"),
      const Student("Lucy"),
      const Student("Bob"),
    });
  });

  test("FromISetMixin.add()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    final Students studentsResult = students.add(const Student("Bob"));

    expect(studentsResult.unlock, {james, sara, lucy, const Student("Bob")});
  });

  test("FromISetMixin.addAll()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    final Students studentsResult =
        students.addAll({const Student("James"), const Student("Bob"), const Student("John")});

    expect(studentsResult.unlock, {james, sara, lucy, const Student("Bob"), const Student("John")});
  });

  test("FromISetMixin.clear()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    final Students studentsResult = students.clear();

    expect(studentsResult.iter.unlock, <Student>{});
  });

  test("FromISetMixin.equalItems()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.equalItems({james, sara, lucy}), isTrue);
    expect(students.equalItems({sara, lucy, james}), isTrue);
    expect(students.equalItems({james}), isFalse);
  });

  test("FromISetMixin.same()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.same(students), isTrue);
    expect(students.same(Students([james, sara, lucy])), isFalse);
  });

  test("FromISetMixin.remove()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.remove(const Student("James")).iter, {sara, lucy});
  });

  test("FromISetMixin.removeWhere()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.removeWhere((Student student) => student.name.length == 4).iter, [james]);
  });

  test("FromISetMixin.retainWhere()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.retainWhere((Student student) => student.name.length == 4).iter, {sara, lucy});
  });

  test("FromISetMixin.toggle()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.toggle(const Student("Sara")).iter, {james, lucy});
    expect(students.toggle(const Student("Bob")).iter, {james, sara, lucy, const Student("Bob")});
  });

  test("FromISetMixin.unlock", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.unlock, allOf(isA<Set<Student>>(), {james, sara, lucy}));
  });

  test("FromISetMixin.unlockSorted", () {
    final Ints students = Ints([3, 2, 1, 3]);

    expect(students.unlockSorted, allOf(isA<LinkedHashSet>(), {1, 2, 3}));
    expect(students.unlockSorted.toList(), [1, 2, 3]);
  });

  test("FromISetMixin.unlockView", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.unlockView, allOf(isA<Set<Student>>(), isA<UnmodifiableSetView<Student>>()));
  });

  test("FromISetMixin.difference()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.difference({james, sara, lucy}), <Student>{});
    expect(students.difference({james}), <Student>{sara, lucy});
    expect(students.difference({const Student("Bob")}), <Student>{james, sara, lucy});
  });

  test("FromISetMixin.intersection()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.intersection({const Student("Bob")}), <Student>{});
    expect(students.intersection({james}), <Student>{james});
    expect(students.intersection({james, const Student("Bob")}), <Student>{james});
    expect(students.intersection({james, sara, lucy}), <Student>{james, sara, lucy});
  });

  test("FromISetMixin.lookup()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.lookup(james), james);
    expect(students.lookup(sara), sara);
    expect(students.lookup(lucy), lucy);
    expect(students.lookup(const Student("Bob")), isNull);
  });

  test("FromISetMixin.removeAll()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.removeAll([sara, lucy]), <Student>{james});
  });

  test("FromISetMixin.retainAll()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.retainAll([sara, lucy]), <Student>{sara, lucy});
  });

  test("FromISetMixin.union()", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.union({james, const Student("Bob")}),
        <Student>{james, sara, lucy, const Student("Bob")});
  });
}

@immutable
class Ints with FromISetMixin<int, Ints> {
  final ISet<int> _ints;

  Ints([Iterable<int> ints]) : _ints = ISet(ints);

  @override
  Ints newInstance(ISet<int> iset) => Ints(iset);

  @override
  ISet<int> get iter => _ints;
}

@immutable
class Students with FromISetMixin<Student, Students> {
  final ISet<Student> _students;

  Students([Iterable<Student> students]) : _students = ISet(students);

  @override
  Students newInstance(ISet<Student> iset) => Students(iset);

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

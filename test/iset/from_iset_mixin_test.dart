// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each, unreachable_from_main
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";
import "package:test/test.dart";

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
  });

  test("Repeating elements doesn't include the copies in the set", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.iter, {james, sara, lucy});
  });

  test("any", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.any((Student student) => student.name == "James"), isTrue);
    expect(students.any((Student student) => student.name == "John"), isFalse);
  });

  test("cast", () {
    final Students students = Students([Student("James")]);

    expect(students.cast<ProtoStudent>(), isA<Iterable<ProtoStudent>>());
  });

  test("contains", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.contains(const Student("James")), isTrue);
    expect(students.contains(const Student("John")), isFalse);
    expect(students.contains(null), isFalse);
  });

  test("containsAll", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.containsAll([james]), isTrue);
    expect(students.containsAll([james, sara]), isTrue);
    expect(students.containsAll([james, sara, lucy]), isTrue);
    expect(students.containsAll([james, sara, lucy, const Student("Bob")]), isFalse);
  });

  test("elementAt", () {
    expect(() => Students([]).elementAt(0), throwsUnsupportedError);
  });

  test("every", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.every((Student student) => student.name.length > 1), isTrue);
    expect(students.every((Student student) => student.name.length > 4), isFalse);
  });

  test("expand", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(
        students.expand((Student student) => [student, student]),
        allOf(
          isA<Iterable<Student>>(),
          <Student>[james, james, sara, sara, lucy, lucy],
        ));

    expect(
        students.expand((Student student) => [student, student]).toISet(),
        allOf(
          isA<Iterable<Student>>(),
          <Student>{james, sara, lucy}.lock,
        ));

    expect(
        students.expand((Student student) => [student, Student(student.name + "2")]),
        allOf(isA<Iterable<Student>>(), <Student>[
          james,
          const Student("James2"),
          sara,
          const Student("Sara2"),
          lucy,
          const Student("Lucy2")
        ]));
  });

  test("length, first, last and single", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    // Getters .first and .last will respect the sort order
    // (when ConfigSet.sort is `true`)
    expect(students.length, 3);
    expect(students.first, Student("James"));
    expect(students.last, Student("Lucy"));
    expect(() => students.single, throwsStateError);

    // single
    expect(Students([const Student("James")]).single, const Student("James"));
  });

  test("firstWhere", () {
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

  test("fold", () {
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

  test("followedBy", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    const Student bob = Student("Bob");

    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.followedBy([bob]), {james, sara, lucy, bob});
  });

  test("forEach", () {
    String concatenated = "";

    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    students.forEach((Student student) => concatenated += student.name + ", ");

    expect(concatenated, "James, Sara, Lucy, ");
  });

  test("join", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    // Join will respect the sort order (when ConfigSet.sort is `true`)
    expect(students.join(", "), "Student: James, Student: Sara, Student: Lucy");
    expect(Students([]).join(", "), "");
  });

  test("lastWhere", () {
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

  test("map", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    final Students students = Students([james, sara]);

    expect(students.map((Student student) => Student(student.name + student.name)),
        {const Student("JamesJames"), const Student("SaraSara")});
  });

  test("reduce", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(
        students.reduce((Student currentStudent, Student nextStudent) =>
            Student(currentStudent.name + " " + nextStudent.name)),
        Student("James Sara Lucy"));
  });

  test("singleWhere", () {
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

  test("skip", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.skip(2), {const Student("Lucy")});
    expect(students.skip(10), <Student>{});
  });

  test("skipWhile", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.skipWhile((Student student) => student.name.length > 4),
        {const Student("Sara"), const Student("Lucy")});
  });

  test("take", () {
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

  test("takeWhile", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.takeWhile((Student student) => student.name.length >= 5),
        {const Student("James")});
  });

  test("where", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.where((Student student) => student.name.length == 5), {const Student("James")});
    expect(students.where((Student student) => student.name.length == 100), <Student>{});
  });

  test("whereType", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.whereType<Student>(),
        {const Student("James"), const Student("Sara"), const Student("Lucy")});
    expect(students.whereType<String>(), <Student>{});
  });

  test("isEmpty | isNotEmpty", () {
    // isEmpty
    expect(Students([]).isEmpty, isTrue);
    expect(Students([Student("James")]).isEmpty, isFalse);

    // isNotEmpty
    expect(Students([]).isNotEmpty, isFalse);
    expect(Students([Student("James")]).isNotEmpty, isTrue);
  });

  test("iterator", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    final Iterator<Student> iter = students.iterator;

    // Iterator will respect the sort order (when ConfigSet.sort is `true`)

    // Throws StateError before first moveNext().
    expect(() => iter.current, throwsStateError);

    expect(iter.moveNext(), isTrue);
    expect(iter.current, james);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, sara);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, lucy);
    expect(iter.moveNext(), isFalse);

    // Throws StateError after last moveNext().
    expect(() => iter.current, throwsStateError);
  });

  test("toList", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    // Method toList will respect the sort order
    // (when ConfigSet.sort is `true`)
    expect(students.toList(), [
      const Student("James"),
      const Student("Sara"),
      const Student("Lucy"),
    ]);
  });

  test("toSet", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.toSet(), {
      const Student("James"),
      const Student("Sara"),
      const Student("Lucy"),
    });
  });

  test("+", () {
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

  test("add", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    final Students studentsResult = students.add(const Student("Bob"));

    expect(studentsResult.unlock, {james, sara, lucy, const Student("Bob")});
  });

  test("addAll", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    final Students studentsResult =
        students.addAll({const Student("James"), const Student("Bob"), const Student("John")});

    expect(studentsResult.unlock, {james, sara, lucy, const Student("Bob"), const Student("John")});
  });

  test("clear", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    final Students studentsResult = students.clear();

    expect(studentsResult.iter.unlock, <Student>{});
  });

  test("equalItems", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.equalItems({james, sara, lucy}), isTrue);
    expect(students.equalItems({sara, lucy, james}), isTrue);
    expect(students.equalItems({james}), isFalse);
  });

  test("same", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.same(students), isTrue);
    expect(students.same(Students([james, sara, lucy])), isFalse);
  });

  test("remove", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.remove(const Student("James")).iter, {sara, lucy});
  });

  test("removeWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.removeWhere((Student student) => student.name.length == 4).iter, [james]);
  });

  test("retainWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.retainWhere((Student student) => student.name.length == 4).iter, {sara, lucy});
  });

  test("toggle", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.toggle(const Student("Sara")).iter, {james, lucy});
    expect(students.toggle(const Student("Bob")).iter, {james, sara, lucy, const Student("Bob")});
  });

  test("unlock", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.unlock, allOf(isA<Set<Student>>(), {james, sara, lucy}));
  });

  test("unlockView", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(
        students.unlockView, allOf(isA<Set<Student>>(), isA<UnmodifiableSetFromISet<Student>>()));
  });

  test("difference", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.difference({james, sara, lucy}), <Student>{});
    expect(students.difference({james}), <Student>{sara, lucy});
    expect(students.difference({const Student("Bob")}), <Student>{james, sara, lucy});
  });

  test("intersection", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.intersection({const Student("Bob")}), <Student>{});
    expect(students.intersection({james}), <Student>{james});
    expect(students.intersection({james, const Student("Bob")}), <Student>{james});
    expect(students.intersection({james, sara, lucy}), <Student>{james, sara, lucy});
  });

  test("lookup", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.lookup(james), james);
    expect(students.lookup(sara), sara);
    expect(students.lookup(lucy), lucy);
    expect(students.lookup(const Student("Bob")), isNull);
  });

  test("removeAll", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.removeAll([sara, lucy]), <Student>{james});
  });

  test("retainAll", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.retainAll([sara, lucy]), <Student>{sara, lucy});
  });

  test("union", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    expect(students.union({james, const Student("Bob")}),
        <Student>{james, sara, lucy, const Student("Bob")});
  });

  test("toString", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, Student("James")]);

    // 1) Global configuration prettyPrint == false
    ImmutableCollection.prettyPrint = false;
    expect(students.toString(), "Students{Student: James, Student: Sara, Student: Lucy}");

    // 2) Global configuration prettyPrint == true
    ImmutableCollection.prettyPrint = true;
    expect(
        students.toString(),
        "Students{\n"
        "   Student: James,\n"
        "   Student: Sara,\n"
        "   Student: Lucy\n"
        "}");
  });
}

@immutable
class Ints with FromISetMixin<int, Ints> {
  final ISet<int> _ints;

  Ints([Iterable<int>? ints]) : _ints = ISet(ints);

  @override
  Ints newInstance(ISet<int> iset) => Ints(iset);

  @override
  ISet<int> get iter => _ints;
}

@immutable
class Students with FromISetMixin<Student, Students> {
  final ISet<Student> _students;

  Students([Iterable<Student>? students]) : _students = ISet(students);

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

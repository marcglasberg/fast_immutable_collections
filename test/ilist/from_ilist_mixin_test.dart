// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";
import "package:test/test.dart";

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
  });

  test("iterator", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Iterator<Student?> iterator = students.iterator;

    // Throws StateError before first moveNext().
    expect(() => iterator.current, throwsStateError);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, james);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, sara);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, lucy);
    expect(iterator.moveNext(), isFalse);

    // Throws StateError before first moveNext().
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

    expect(students.cast<ProtoStudent>(), isA<Iterable<ProtoStudent>>());
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
    expect(students.every((Student? student) => student!.name.length > 4), isFalse);
  });

  test("expand", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.expand((Student student) => [student, student]),
        allOf(isA<Iterable<Student>>(), <Student>[james, james, sara, sara, lucy, lucy].lock));
    expect(students.expand((Student? student) => <Student>[]),
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
    // 1) State exception
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(() => students.single, throwsStateError);

    // 2) Access
    expect(Students([const Student("James")]).single, const Student("James"));
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
    expect(students.whereType<String>(), <Student>[]);
  });

  test("isEmpty", () {
    expect(Students([]).isEmpty, isTrue);
    expect(Students([Student("James")]).isEmpty, isFalse);
  });

  test("isNotEmpty", () {
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
        students.toSet(), {const Student("James"), const Student("Sara"), const Student("Lucy")});
  });

  test("+", () {
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

  test("add", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Students studentsResult = students.add(const Student("Bob"));

    expect(studentsResult.unlock, [james, sara, lucy, const Student("Bob")]);
  });

  test("addAll", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Students studentsResult = students.addAll([const Student("Bob"), const Student("John")]);

    expect(studentsResult.unlock, [james, sara, lucy, const Student("Bob"), const Student("John")]);
  });

  test("asMap", () {
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

  test("clear", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Students studentsResult = students.clear();

    expect(studentsResult.iter.unlock, <Student>[]);
  });

  test("equalItems", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.equalItems([james, sara, lucy]), isTrue);
    expect(students.equalItems([sara, lucy, james]), isFalse);
    expect(students.equalItems([james]), isFalse);
  });

  test("unorderedEqualItems", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.unorderedEqualItems([james, sara, lucy]), isTrue);
    expect(students.unorderedEqualItems([sara, lucy, james]), isTrue);
    expect(students.unorderedEqualItems([james]), isFalse);
  });

  test("same", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.same(students), isTrue);
    expect(students.same(Students([james, sara, lucy])), isFalse);
  });

  test("fillRange", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.fillRange(1, 3, Student("Placeholder")).iter,
        [james, const Student("Placeholder"), const Student("Placeholder")]);
  });

  test("firstOr", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.firstOr(const Student("Bob")), const Student("James"));
    expect(Students([]).firstOr(const Student("Bob")), const Student("Bob"));
  });

  test("firstOrNull", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.firstOrNull, const Student("James"));
    expect(Students([]).firstOrNull, isNull);
  });

  test("getRange", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.getRange(1, 3), [const Student("Sara"), const Student("Lucy")]);
  });

  test("indexOf", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.indexOf(const Student("James")), 0);
    expect(students.indexOf(const Student("Sara")), 1);
    expect(students.indexOf(const Student("Lucy")), 2);
    expect(students.indexOf(const Student("Bob")), -1);
  });

  test("indexWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.indexWhere((Student? student) => student!.name.length == 5), 0);
    expect(students.indexWhere((Student? student) => student!.name.length == 100), -1);
  });

  test("insert", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Students studentsResult = students.insert(1, const Student("Bob"));

    expect(studentsResult.iter, [james, const Student("Bob"), sara, lucy]);
  });

  test("insertAll", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Students studentsResult =
        students.insertAll(1, [const Student("Bob"), const Student("John")]);

    expect(studentsResult.iter, [james, const Student("Bob"), const Student("John"), sara, lucy]);
  });

  test("lastIndexOf", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, sara]);

    expect(students.lastIndexOf(const Student("Sara")), 3);
  });

  test("lastIndexWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, sara]);

    expect(students.lastIndexWhere((Student? student) => student!.name == "Sara"), 3);
  });

  test("lastOr", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.lastOr(const Student("Bob")), const Student("Lucy"));
    expect(Students([]).lastOr(const Student("Bob")), const Student("Bob"));
  });

  test("lastOrNull", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.lastOrNull, const Student("Lucy"));
    expect(Students([]).lastOrNull, isNull);
  });

  test("maxLength", () {
    // 1) Regular usage
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.maxLength(2).iter, [james, sara]);
    expect(students.maxLength(0).iter, []);

    // 2) Priority
    expect(
        students
            .maxLength(2,
                priority: (Student? a, Student? b) => a!.name.length.compareTo(b!.name.length))
            .iter,
        [sara, lucy]);
  });

  test("process", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students
            .process(
                test: (_, __, Student? student) => student!.name.length == 5,
                apply: (_, __, Student? student) => [Student(student!.name * 2)])
            .iter,
        [const Student("JamesJames"), sara, lucy]);
  });

  test("put", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.put(2, const Student("Bob")).iter, [james, sara, const Student("Bob")]);
  });

  test("remove", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.remove(const Student("James")).iter, [sara, lucy]);
  });

  test("removeAt", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);
    final Output<Student> output = Output();

    final Students removed = students.removeAt(1, output);

    expect(removed.iter, [james, lucy]);
    expect(output.value, const Student("Sara"));
  });

  test("removeLast", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);
    final Output<Student> output = Output();

    final Students removed = students.removeLast(output);

    expect(removed.iter, [james, sara]);
    expect(output.value, const Student("Lucy"));
  });

  test("removeRange", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.removeRange(1, 3).iter, [james]);
  });

  test("removeWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.removeWhere((Student? student) => student!.name.length == 4).iter, [james]);
  });

  test("replaceAll", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, james]);

    expect(students.replaceAll(from: const Student("James"), to: const Student("Bob")).iter,
        [const Student("Bob"), sara, lucy, const Student("Bob")]);
  });

  test("replaceAllWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, james]);

    expect(
        students
            .replaceAllWhere((Student? student) => student!.name.length == 5, const Student("Bob"))
            .iter,
        [const Student("Bob"), sara, lucy, const Student("Bob")]);
  });

  test("replaceFirst", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, james]);

    expect(students.replaceFirst(from: const Student("James"), to: const Student("Bob")).iter,
        [const Student("Bob"), sara, lucy, james]);
  });

  test("replaceFirstWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, james]);

    expect(
        students
            .replaceFirstWhere(
                (Student? student) => student!.name.length == 5, (_) => const Student("Bob"))
            .iter,
        [const Student("Bob"), sara, lucy, james]);
  });

  test("replaceRange", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy, james]);

    expect(students.replaceRange(1, 3, [const Student("Bob"), const Student("John")]).iter,
        [james, const Student("Bob"), const Student("John"), james]);
  });

  test("retainWhere", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(
        students.retainWhere((Student? student) => student!.name.length == 4).iter, [sara, lucy]);
  });

  test("reversed", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.reversed.iter, [lucy, sara, james]);
  });

  test("setAll", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.setAll(1, [const Student("Bob")]).iter, [james, const Student("Bob"), lucy]);
  });

  test("setRange", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.setRange(1, 3, [const Student("Bob"), const Student("John")]).iter,
        [james, const Student("Bob"), const Student("John")]);
  });

  test("shuffle", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    final Random random = Random(0);

    expect(students.shuffle(random).iter, [lucy, sara, james]);
  });

  test("singleOr", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.singleOr(Student("Bob")), Student("Bob"));
    expect(Students([james]).singleOr(Student("Bob")), Student("James"));
  });

  test("singleOrNull", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.singleOrNull, isNull);
    expect(Students([const Student("Bob")]).singleOrNull, const Student("Bob"));
  });

  test("sort", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.sort((Student? a, Student? b) => a!.name.compareTo(b!.name)).iter,
        [james, lucy, sara]);
  });

  test("sublist", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.sublist(1).iter, [sara, lucy]);
  });

  test("toggle", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.toggle(const Student("Sara")).iter, [james, lucy]);
    expect(students.toggle(const Student("Bob")).iter, [james, sara, lucy, const Student("Bob")]);
  });

  test("unlock", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.unlock, allOf(isA<List<Student>>(), [james, sara, lucy]));
  });

  test("unlockView", () {
    const Student james = Student("James");
    const Student sara = Student("Sara");
    const Student lucy = Student("Lucy");
    final Students students = Students([james, sara, lucy]);

    expect(students.unlockView,
        allOf(isA<List<Student>>(), isA<UnmodifiableListFromIList<Student>>()));
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
class Students with FromIListMixin<Student, Students> {
  final IList<Student> _students;

  Students([Iterable<Student>? students]) : _students = IList(students);

  @override
  Students newInstance(IList<Student>? ilist) => Students(ilist);

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

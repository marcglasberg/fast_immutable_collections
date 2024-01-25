// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each, unreachable_from_main
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

int testCount = 0;

void testAndPrint(dynamic description, dynamic Function() body) {
  test(
    description,
    () {
      testCount++;
      print("\n\n$testCount. $description -----------\n\n");
      body();
    },
  );
}

void main() {
  print("THESE ARE THE EXAMPLES IN README.md");

  testAndPrint("Creating IList", () {
    IList<int> ilist1 = IList([1, 2]);
    IList<int> ilist2 = [1, 2].lock;
    IList<int>? ilist3 = {1, 2}.toIList();

    var list1 = List.of(ilist1);
    var list2 = ilist1.unlock;

    // All print [1, 2].
    print(ilist1);
    print(list1);
    print(ilist2);
    print(list2);
    print(ilist3);
  });

  testAndPrint("Basic IList usage", () {
    var ilist1 = [1, 2].lock;
    var ilist2 = ilist1.add(3);
    var ilist3 = ilist2.remove(2);

    print(ilist1); // Prints 1, 2
    print(ilist2); // Prints 1, 2, 3
    print(ilist3); // Prints 1, 3
  });

  testAndPrint("Chain methods", () {
    var ilist = [1, 2].lock.add(3).remove(4);
    print(ilist); // Prints 1, 2
  });

  testAndPrint("Iterating", () {
    var ilist = [1, 2, 3, 4].lock;
    for (int? value in ilist) print(value); // Prints 1, 2, 3, 4.
  });

  testAndPrint("Some IList methods (like map and take) return Iterable", () {
    IList<int> ilist = ["Bob", "Alice", "Dominic", "Carl"]
        .lock
        .sort() // Alice, Bob, Carl, Dominic
        .map(((name) => name.length)) // 5, 3, 4, 7
        .take(3) // 5, 3, 4
        .toIList()
        .sort() // 3, 4, 5
        .toggle(4) // 3, 5,
        .toggle(2); // 3, 5, 2;

    print(ilist.runtimeType); // Prints: IList<int>
    print(ilist); // Prints [3, 5, 2]
  });

  testAndPrint("ILists can be used as map keys", () {
    Map<IList, int> sumResult = {};

    String getSum(int a, int b) {
      var keys = [a, b].lock;
      var sum = sumResult[keys];
      if (sum != null) {
        return "Got from cache: $a + $b = $sum";
      } else {
        sum = a + b;
        sumResult[keys] = sum;
        return "Newly calculated: $a + $b = $sum";
      }
    }

    print(getSum(5, 3));
    print(getSum(8, 9));
    print(getSum(5, 3));
  });

  testAndPrint("Getters `withIdentityEquals` and `withDeepEquals`", () {
    var ilist = [1, 2].lock;

    // ILists by default use deep equals.
    var ilist1 = [1, 2].lock;

    // But you can change it to identity equals.
    var ilist2 = ilist.withIdentityEquals;

    // And also change back to deep equals.
    var ilist3 = ilist2.withDeepEquals;

    print(ilist == ilist1); // True!
    print(ilist == ilist2); // False!
    print(ilist == ilist3); // True!
  });

  testAndPrint("Method `withConfig`", () {
    var list = [1, 2];
    var ilist1 = list.lock.withConfig(ConfigList(isDeepEquals: true));
    var ilist2 = list.lock.withConfig(ConfigList(isDeepEquals: false));

    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
  });

  testAndPrint("Constructor `withConfig`", () {
    var list = [1, 2];
    var ilist1 = IList.withConfig(list, ConfigList(isDeepEquals: true));
    var ilist2 = IList.withConfig(list, ConfigList(isDeepEquals: false));

    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
  });

  testAndPrint("Global IList configuration", () {
    var list = [1, 2];

    // The default.
    var ilistA1 = IList(list);
    var ilistA2 = IList(list);
    print(ilistA1 == ilistA2); // True!
    expect(ilistA1 == ilistA2, isTrue);

    // Change the default to identity equals, for lists created from now on.
    IList.defaultConfig = ConfigList(isDeepEquals: false);
    var ilistB1 = IList(list);
    var ilistB2 = IList(list);
    print(ilistB1 == ilistB2); // False!
    expect(ilistB1 == ilistB2, isFalse);

    // Already created lists are not changed.
    print(ilistA1 == ilistA2); // True!
    expect(ilistA1 == ilistA2, isTrue);

    // Change the default back to deep equals.
    IList.defaultConfig = ConfigList(isDeepEquals: true);
    var ilistC1 = IList(list);
    var ilistC2 = IList(list);
    print(ilistC1 == ilistC2); // True!
    expect(ilistC1 == ilistC2, isTrue);
  });

  testAndPrint("Usage in tests", () {
    // ignore: unrelated_type_equality_checks
    expect([1, 2] == [1, 2].lock, isFalse);

    expect([1, 2], [1, 2]); // List with List, same order.
    expect([1, 2].lock, [1, 2]); // IList with List, same order.
    expect([1, 2], [1, 2].lock); // List with IList, same order.
    expect([1, 2].lock, [1, 2].lock); // IList with IList, same order.

    expect([2, 1], isNot([1, 2])); // List with List, wrong order.
    expect([2, 1].lock, isNot([1, 2])); // IList with List, wrong order.
    expect([2, 1], isNot([1, 2].lock)); // List with IList, wrong order.
    expect([2, 1].lock, isNot([1, 2].lock)); // IList with IList, wrong order.

    expect([1, 2], {1, 2}); // List with ordered Set in the correct order.
    expect([1, 2].lock, {1, 2}); // IList with ordered Set in the correct order.
    expect({1, 2}, [1, 2]); // Ordered Set in the correct order with List.
    expect({1, 2}, [1, 2].lock); // Ordered Set in the correct order with IList.

    expect([1, 2], {2, 1}); // List with ordered Set in the WRONG order.
    expect({2, 1}, isNot([1, 2])); // Ordered Set in the WRONG order with List.

    expect([1, 2].lock, {2, 1}); // IList with ordered Set in the WRONG order.
    expect({2, 1}, isNot([1, 2].lock)); // Ordered Set in the WRONG order with IList.

    expect({1, 2}, isNot([2, 1])); // Ordered Set in the WRONG order with List.
    expect([2, 1], {1, 2}); // List with ordered Set in the WRONG order.

    expect({1, 2}, isNot([2, 1].lock)); // Ordered Set in the WRONG order with IList.
    expect([2, 1].lock, {1, 2}); // IList with ordered Set in the WRONG order.
  });

  testAndPrint("Reuse by composition", () {
    var james = Student("James");
    var sara = Student("Sara");
    var lucy = Student("Lucy");

    Students students = Students().add(james).addAll([sara, lucy]);

    expect(students.iter, [james, sara, lucy]);
    expect(students.greetings(), "Hello James, Sara, Lucy.");
  });

  testAndPrint("ISet sort", () {
    var originalSet = {2, 4, 1, 9, 3};

    /// Sorts: "1,2,3,4,9"
    var iset = originalSet.lock.withConfig(ConfigSet(sort: true));
    var result1 = iset.join(",");
    var result2 = iset.iterator.toIterable().join(",");
    var result3 = iset.toList().join(",");
    var result4 = iset.toIList().join(",");
    var result5 = iset.toSet().join(",");
    print(iset.config.sort);
    print(result1);
    print(result2);
    print(result3);
    print(result4);
    print(result5);
    expect(result1, "1,2,3,4,9");
    expect(result2, "1,2,3,4,9");
    expect(result3, "1,2,3,4,9");
    expect(result4, "1,2,3,4,9");
    expect(result5, "1,2,3,4,9");

    /// Does not sort, but keeps original order: "2,4,1,9,3"
    iset = originalSet.lock.withConfig(ConfigSet(sort: false));
    result1 = iset.join(",");
    result2 = iset.iterator.toIterable().join(",");
    result3 = iset.toList().join(",");
    result4 = iset.toIList().join(",");
    result5 = iset.toSet().join(",");
    print(result1);
    print(result2);
    print(result3);
    print(result4);
    print(result5);
    expect(result1, "2,4,1,9,3");
    expect(result2, "2,4,1,9,3");
    expect(result3, "2,4,1,9,3");
    expect(result4, "2,4,1,9,3");

    // This is unordered (HashSet).
    expect(iset.toSet(), originalSet);
  });

  testAndPrint("IMapOfSets", () {
    var james = Student("James");
    var sara = Student("Sara");
    var lucy = Student("Lucy");
    var bill = Student("Bill");
    var megan = Student("Megan");

    var math = Course("Math");
    var geo = Course("Geography");
    var arts = Course("Arts");
    var english = Course("English");

    var studentsPerCourse = StudentsPerCourse()
        //
        .addStudentToCourse(sara, math)
        //
        .addStudentsToCourse([james, lucy], math)
        //
        .addStudentsToCourse([lucy], arts)
        //
        .addStudentToCourse(bill, arts)
        //
        .addStudentsToCourses({
          math: {bill},
          geo: {lucy, sara}
        })
        //
        .addStudentToCourses(megan, [english, arts]);

    expect(
      studentsPerCourse.toMap(),
      {
        math: {james, sara, lucy, bill},
        geo: {lucy, sara},
        arts: {lucy, bill, megan},
        english: {megan},
      },
    );

    expect(studentsPerCourse.courses(), {math, geo, arts, english});

    expect(studentsPerCourse.removeCourse(arts).courses(), {math, geo, english});

    expect(studentsPerCourse.students(), {james, sara, lucy, bill, megan});

    expect(studentsPerCourse.studentsInAlphabeticOrder(), [bill, james, lucy, megan, sara]);

    expect(studentsPerCourse.studentNamesInAlphabeticOrder(),
        ["Bill", "James", "Lucy", "Megan", "Sara"]);
  });

  testAndPrint("compare", () {
    List<int> list = [1, 15, 3, 21, 360, 9, 17, 300, 25, 5, 22, 10, 12, 27, 14, 5];

    /// Comparator Rules:
    /// 1) If present, number 14 is always the first, followed by number 15.
    /// 2) Otherwise, odd numbers come before even ones.
    /// 3) Otherwise, come numbers which are multiples of 3,
    /// 4) Otherwise, come numbers which are multiples of 5,
    /// 5) Otherwise, numbers come in their natural order.
    int Function(int, int) compare = sortBy((x) => x == 14,
        then: sortBy((x) => x == 15,
            then: sortBy((x) => x % 2 == 1,
                then: sortBy((x) => x % 3 == 0,
                    then: sortBy(
                      (x) => x % 5 == 0,
                      then: (int a, int b) => a.compareTo(b),
                    )))));

    print(list);
    list.sort(compare);
    print(list);

    expect(list, [
      14, // 14 must be the first.
      15, // 15 must be the second.
      3, 9, 21, 27, // Odd numbers, multiple of 3, in natural order.
      5, 5, 25, // Odd numbers, multiple of 5, in natural order.
      1, 17, // Odd numbers, not multiple of 3 or 5, in natural order.
      300, 360, // Even numbers, multiples of both 3 and 5, in order.
      12, // Even numbers, multiples of 3, not 5.
      10, // Even numbers, multiples of 5, not 3.
      22, // Even numbers, not multiples of 3 nor 5.
    ]);
  });
}

class Student implements Comparable<Student> {
  final String name;

  Student(this.name);

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  int compareTo(Student other) => name.compareTo(other.name);
}

class Students with FromIListMixin<Student, Students> {
  final IList<Student> _students;

  Students([Iterable<Student>? students]) : _students = IList(students);

  @override
  Students newInstance(IList<Student> ilist) => Students(ilist);

  @override
  IList<Student> get iter => _students;

  String greetings() => "Hello ${_students.join(", ")}.";
}

class Course {
  final String name;

  Course(this.name);

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class StudentsPerCourse {
  final IMapOfSets<Course, Student> imap;

  StudentsPerCourse([Map<Course, Set<Student>>? studentsPerCourse])
      : imap = (studentsPerCourse ?? {}).lock;

  StudentsPerCourse._(this.imap);

  ISet<Course> courses() => imap.keysAsSet;

  ISet<Student?> students() => imap.valuesAsSet;

  IMapOfSets<Student?, Course> getCoursesPerStudent() => imap.invertKeysAndValues();

  IList<Student?> studentsInAlphabeticOrder() =>
      imap.valuesAsSet.toIList(compare: (s1, s2) => s1.name.compareTo(s2.name));

  IList<String>? studentNamesInAlphabeticOrder() => imap.valuesAsSet.map((s) => s.name).toIList();

  StudentsPerCourse addStudentToCourse(Student student, Course course) =>
      StudentsPerCourse._(imap.add(course, student));

  StudentsPerCourse addStudentToCourses(Student student, Iterable<Course> courses) =>
      StudentsPerCourse._(imap.addValuesToKeys(courses, [student]));

  StudentsPerCourse addStudentsToCourse(Iterable<Student> students, Course course) =>
      StudentsPerCourse._(imap.addValues(course, students));

  StudentsPerCourse addStudentsToCourses(Map<Course, Set<Student>> studentsPerCourse) =>
      StudentsPerCourse._(imap.addMap(studentsPerCourse));

  StudentsPerCourse removeStudentFromCourse(Student student, Course course) =>
      StudentsPerCourse._(imap.remove(course, student));

  StudentsPerCourse removeStudentFromAllCourses(Student student) =>
      StudentsPerCourse._(imap.removeValues([student]));

  StudentsPerCourse removeCourse(Course course) => StudentsPerCourse._(imap.removeSet(course));

  Map<Course, Set<Student?>> toMap() => imap.unlock;

  int get numberOfCourses => imap.lengthOfKeys;

  int get numberOfStudents => imap.lengthOfNonRepeatingValues;
}

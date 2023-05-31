// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("compareObject", () {
    //
    // 1) Natural order between "a" and "b".
    expect(
        ["a", "b"]
          ..shuffle()
          ..sort(compareObject),
        ["a", "b"]);

    // 2) Natural order between 1 and 2. Nulls come after.
    expect(
        [1, 2, null]
          ..shuffle()
          ..sort(compareObject),
        [1, 2, null]);

    // 3) Natural order between 1 and 2. Nulls come before.
    expect(
        [1, 2, null]
          ..shuffle()
          ..sort((a, b) => compareObject(a, b, nullsBefore: true)),
        [null, 1, 2]);

    // 4) True comes after false.
    expect(
        [true, false]
          ..shuffle()
          ..sort(compareObject),
        [false, true]);

    // 5) Natural order of keys.
    var entryA20 = MapEntry("a", 20);
    var entryB10 = MapEntry("b", 10);
    expect(
        [entryB10, entryA20]
          ..shuffle()
          ..sort(compareObject),
        [entryA20, entryB10]);

    // 6) Natural order of values (since keys are the same).
    var entryA10 = MapEntry("a", 10);
    expect(
        [entryA20, entryA10]
          ..shuffle()
          ..sort(compareObject),
        [entryA10, entryA20]);

    // 7) Enums are sorted
    expect([TestEnum.foo, TestEnum.bar]..sort(compareObject),
        [TestEnum.bar, TestEnum.foo]..sort(compareObject));
  });

  test("if0 extension", () {
    var list = ["aaa", "ccc", "b", "c", "bbb", "a", "aa", "bb", "cc"];

    /// Comparator Rules:
    /// 1) String come in their natural order.
    var compareTo = (String a, String b) => a.compareTo(b);
    list.shuffle();
    list.sort(compareTo);
    expect(list, ["a", "aa", "aaa", "b", "bb", "bbb", "c", "cc", "ccc"]);

    /// Comparator Rules:
    /// 1) Strings are ordered according to their length.
    /// 2) Otherwise, they come in their natural order.
    compareTo = (String a, String b) => a.length.compareTo(b.length).if0(a.compareTo(b));
    list.shuffle();
    list.sort(compareTo);
    expect(list, ["a", "b", "c", "aa", "bb", "cc", "aaa", "bbb", "ccc"]);

    /// Comparator Rules:
    /// 1) Strings are ordered according to their length.
    /// 2) Otherwise, they come in their natural order, inverted.
    compareTo = (String a, String b) => a.length.compareTo(b.length).if0(-a.compareTo(b));
    list.shuffle();
    list.sort(compareTo);
    expect(list, ["c", "b", "a", "cc", "bb", "aa", "ccc", "bbb", "aaa"]);
  });

  test("sortBy", () {
    List<int> list = [1, 15, 3, 21, 360, 9, 17, 300, 25, 5, 22, 10, 12, 27, 14, 5];

    /// Comparator Rules:
    /// 1) If present, number 14 is always the first, followed by number 15.
    /// 2) Otherwise, odd numbers come before even ones.
    /// 3) Otherwise, come numbers which are multiples of 3,
    /// 4) Otherwise, come numbers which are multiples of 5,
    /// 5) Otherwise, numbers come in their natural order.
    int Function(int, int) compareTo = sortBy((x) => x == 14,
        then: sortBy((x) => x == 15,
            then: sortBy((x) => x % 2 == 1,
                then: sortBy((x) => x % 3 == 0,
                    then: sortBy(
                      (x) => x % 5 == 0,
                      then: (int a, int b) => a.compareTo(b),
                    )))));

    for (int i = 1; i < 1000; i++) {
      list.shuffle();
      list.sort(compareTo);

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
    }
  });

  test("sortLike", () {
    IList<int?> list = [1, 9, 2, 27, 12, 3, 12, 14, 11, 7, 0, 4].lock;

    /// Comparator Rules:
    /// 1) Order should be [7, 3, 4, 21, 2] when these values appear.
    /// 2) Otherwise, odd numbers come before even ones.
    /// 3) Otherwise, numbers come in their natural order.
    int Function(int?, int?) compareTo = sortLike(const [7, 3, 4, 21, 2],
        then: sortBy(
          (x) => x! % 2 == 1,
          then: (int? a, int? b) => a!.compareTo(b!),
        ));

    for (int i = 1; i < 1000; i++) {
      list = list.shuffle().sort(compareTo);
      expect(list, [1, 7, 3, 9, 11, 27, 0, 4, 2, 12, 12, 14]);
    }
  });

  test("sortLike with mapper", () {
    IList<String?> list = [
      "1",
      "123456789",
      "12",
      "123456789012345678901234567",
      "123456789012",
      "123",
      "123456789012",
      "12345678901234",
      "12345678901",
      "1234567",
      "",
      "1234"
    ].lock;

    /// Comparator Rules:
    ///
    /// 1) Order should be length [7, 3, 4, 21, 2] when these values appear.
    /// 2) Otherwise, strings with odd length come before even ones.
    /// 3) Otherwise, string come ordered according to their length.

    // `order is List`
    int Function(String?, String?) compareToList = sortLike(const [7, 3, 4, 21, 2],
        mapper: (String? text) => text!.length,
        then: sortBy(
          (String? x) => x!.length % 2 == 1,
          then: (String? a, String? b) => a!.length.compareTo(b!.length),
        ));

    for (int i = 1; i < 1000; i++) {
      list = list.shuffle().sort(compareToList);
      expect(list.map((text) => text!.length), [1, 7, 3, 9, 11, 27, 0, 4, 2, 12, 12, 14]);
    }

    // `order is IList`
    int Function(String?, String?) compareToIList = sortLike([7, 3, 4, 21, 2].lock,
        mapper: (String? text) => text!.length,
        then: sortBy(
          (String? x) => x!.length % 2 == 1,
          then: (String? a, String? b) => a!.length.compareTo(b!.length),
        ));

    for (int i = 1; i < 1000; i++) {
      list = list.shuffle().sort(compareToIList);
      expect(list.map((text) => text!.length), [1, 7, 3, 9, 11, 27, 0, 4, 2, 12, 12, 14]);
    }

    // else: any other subtype of `Iterable`
    int Function(String?, String?) compareToIterable = sortLike({7, 3, 4, 21, 2},
        mapper: (String? text) => text!.length,
        then: sortBy(
          (String? x) => x!.length % 2 == 1,
          then: (String? a, String? b) => a!.length.compareTo(b!.length),
        ));

    for (int i = 1; i < 1000; i++) {
      list = list.shuffle().sort(compareToIterable);
      expect(list.map((text) => text!.length), [1, 7, 3, 9, 11, 27, 0, 4, 2, 12, 12, 14]);
    }
  });

  test("Sort with inconsistencies.", () {
    IList<int?> list = [3, 4, 9].lock;

    /// Comparator Rules are inconsistent:
    /// 1) Order should be [4, 3] when these values appear.
    /// 2) Otherwise, odd numbers come before even ones.
    /// 3) Otherwise, numbers come in their natural order.
    ///
    /// Example of inconsistency: Number 9 is not in the list. It is odd, so it
    /// should come before 4 which is even. However 9 should come after 3 because
    /// of its natural order. This may result in 3 being put before 4, thus
    /// breaking the given list order.
    ///
    int Function(int?, int?) compareTo = sortLike(const [4, 3],
        then: sortBy(
          (x) => x! % 2 == 1,
          then: (int? a, int? b) => a!.compareTo(b!),
        ));

    bool isInconsistent = false;

    list = list.sort(compareTo);

    for (int i = 1; i < 1000; i++) {
      var prevList = list;
      list = list.shuffle().sort(compareTo);
      if (prevList != list) isInconsistent = true;
    }

    expect(isInconsistent, isTrue);
  });

  test("compareObjectTo", () {
    //
    int? nullValue;

    expect(1.compareObjectTo(2), -1);
    expect(2.compareObjectTo(1), 1);
    expect(nullValue.compareObjectTo(1), 1);
    expect(1.compareObjectTo(null), -1);
    expect(nullValue.compareObjectTo(null), 0);

    expect(1.compareObjectTo(2, nullsBefore: true), -1);
    expect(2.compareObjectTo(1, nullsBefore: true), 1);
    expect(nullValue.compareObjectTo(1, nullsBefore: true), -1);
    expect(1.compareObjectTo(null, nullsBefore: true), 1);
    expect(nullValue.compareObjectTo(null, nullsBefore: true), 0);

    // Nulls go to the end.
    expect([2, null, 1]..sort((a, b) => a.compareObjectTo(b)), [1, 2, null]);

    // Nulls go to the start.
    expect([2, null, 1]..sort((a, b) => a.compareObjectTo(b, nullsBefore: true)), [null, 1, 2]);
  });
}

enum TestEnum { foo, bar }

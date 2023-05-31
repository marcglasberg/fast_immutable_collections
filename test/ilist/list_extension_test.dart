// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("distinct", () {
    expect(([].distinct()), []);
    expect(([5, 5, 5].distinct()), [5]);
    expect(([1, 2, 3, 4].distinct()), [1, 2, 3, 4]);
    expect(([1, 2, 3, 4, 3, 5, 3].distinct()), [1, 2, 3, 4, 5]);
    expect(([1, 2, 3, 4, 3, 5, 1].distinct()), [1, 2, 3, 4, 5]);
    expect((["abc", "abc", "def"].distinct()), ["abc", "def"]);
    expect((["abc", "abc", "def"].distinct()).take(1), ["abc"]);

    expect(
        (["a", "b", "abc", "ab", "def"].distinct(by: (item) => item.length)), ["a", "abc", "ab"]);

    // Make sure it creates a new list, not mutate the original one.
    List<int> list1 = [1, 2, 2, 4];
    List<int> list2 = list1.distinct();
    expect(list1, [1, 2, 2, 4]);
    expect(list2, [1, 2, 4]);
    expect(identical(list1, list2), isFalse);
  });

  test("removeDuplicates", () {
    expect(([]..removeDuplicates()), []);
    expect(([5, 5, 5]..removeDuplicates()), [5]);
    expect(([1, 2, 3, 4]..removeDuplicates()), [1, 2, 3, 4]);
    expect(([1, 2, 3, 4, 3, 5, 3]..removeDuplicates()), [1, 2, 3, 4, 5]);
    expect(([1, 2, 3, 4, 3, 5, 1]..removeDuplicates()), [1, 2, 3, 4, 5]);
    expect((["abc", "abc", "def"]..removeDuplicates()), ["abc", "def"]);
    expect((["abc", "abc", "def"]..removeDuplicates()).take(1), ["abc"]);

    expect((["a", "b", "abc", "ab", "def"]..removeDuplicates(by: (item) => item.length)),
        ["a", "abc", "ab"]);

    // Make sure it mutates the original list.
    List<int> list1 = [1, 2, 2, 4];
    list1.removeDuplicates();
    expect(list1, [1, 2, 4]);

    // ---

    // Not removing nulls.
    expect(([1, 2, null, 3, null, 4]..removeDuplicates()), [1, 2, null, 3, 4]);
    expect(([1, 2, null, 3, 2, 4]..removeDuplicates()), [1, 2, null, 3, 4]);
    expect(([null]..removeDuplicates()), [null]);
    expect(([null, null]..removeDuplicates()), [null]);
    expect(([null, 1, null, 1]..removeDuplicates()), [null, 1]);

    // Removing nulls.
    expect(([1, 2, null, 3, null, 4]..removeDuplicates(removeNulls: true)), [1, 2, 3, 4]);
    expect(([1, 2, null, 3, 2, 4]..removeDuplicates(removeNulls: true)), [1, 2, 3, 4]);
    expect(([null]..removeDuplicates(removeNulls: true)), []);
    expect(([null, null]..removeDuplicates(removeNulls: true)), []);
    expect(([null, 1, null, 1]..removeDuplicates(removeNulls: true)), [1]);
  });

  test("removeNulls", () {
    expect(([1, 2, null, 3, null, 4]..removeNulls()), [1, 2, 3, 4]);
    expect(([1, 2, null, 3, 2, 4]..removeNulls()), [1, 2, 3, 2, 4]);
    expect(([null]..removeNulls()), []);
    expect(([null, null]..removeNulls()), []);
    expect(([null, 1, null, 1]..removeNulls()), [1, 1]);
  });

  test("withNullsRemoved", () {
    List<String?> list = ["a", "b", null];
    expect(list.runtimeType.toString(), "List<String?>");
    expect(list.withNullsRemoved(), ["a", "b"]);
    expect(list.withNullsRemoved().runtimeType.toString(), "List<String>");

    list = [null, null];
    expect(list.withNullsRemoved(), []);
    expect(list.withNullsRemoved().runtimeType.toString(), "List<String>");

    List<String> other = ["a", "b"];
    expect(other.withNullsRemoved(), ["a", "b"]);
    expect(other.withNullsRemoved().runtimeType.toString(), "List<String>");
  });

  test("sortOrdered", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];
    list.sortOrdered((int a, int b) => a.compareTo(b));
    expect(list, [1, 2, 3, 4, 5, 10]);
  });

  test("sortLike", () {
    List<int> list = [1, 2, 4, 10, 3, 5];
    list.sortLike([1, 2, 3]);
    expect(list, [1, 2, 3, 4, 10, 5]);

    list = [1, 2, 4, 10, 3, 5];
    list.sortLike([]);
    expect(list, [1, 2, 4, 10, 3, 5]);
  });

  test("sortReversed", () {
    List<int> list = [1, 2, 4, 10, 3, 5];
    list = (list..sort()).reversed.toList();
    expect(list, [10, 5, 4, 3, 2, 1]);

    List<int> listInt = [1, 2, 4, 10, 3, 5];
    listInt.sortReversed();
    expect(listInt, [10, 5, 4, 3, 2, 1]);
    listInt.sort();
    expect(listInt, [1, 2, 3, 4, 5, 10]);
    listInt.sortReversed();
    expect(listInt, [10, 5, 4, 3, 2, 1]);

    List<String> listStr = ["a", "cc", "aaaaa", "bbb"];
    listStr.sortReversed((String a, String b) => a.length.compareTo(b.length));
    expect(listStr, ["aaaaa", "bbb", "cc", "a"]);
    listStr.sort((String a, String b) => a.length.compareTo(b.length));
    expect(listStr, ["a", "cc", "bbb", "aaaaa"]);
    listStr.sortReversed((String a, String b) => a.length.compareTo(b.length));
    expect(listStr, ["aaaaa", "bbb", "cc", "a"]);
  });

  test("moveToTheEnd", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];
    list.moveToTheEnd(4);
    expect(list, [1, 2, 10, 3, 5, 4]);
  });

  test("moveToTheFront", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];
    list.moveToTheFront(4);
    expect(list, [4, 1, 2, 10, 3, 5]);
  });

  test("whereMoveToTheEnd", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];
    list.whereMoveToTheEnd((int item) => item > 4);
    expect(list, [1, 2, 4, 3, 10, 5]);
  });

  test("whereMoveToTheFront", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];
    list.whereMoveToTheFront((int item) => item > 4);
    expect(list, [10, 5, 1, 2, 4, 3]);
  });

  test("toggle", () {
    List<int?> list = [1, 2, 3, 4, 5];

    // 1) Toggle existing item
    expect(list.contains(4), isTrue);
    expect(list.toggle(4), isFalse);
    expect(list.contains(4), isFalse);
    expect(list.toggle(4), isTrue);
    expect(list.contains(4), isTrue);

    // 2) Toggle NON-existing item
    expect(list.contains(6), isFalse);
    expect(list.toggle(6), isTrue);
    expect(list.contains(6), isTrue);
    expect(list.toggle(6), isFalse);
    expect(list.contains(6), isFalse);

    // 3) Nulls and other checks
    list = <int>[];
    expect(list.toggle(1), isTrue);
    expect(list.contains(1), isTrue);

    list = <int?>[];
    expect(list.toggle(null), isTrue);
    expect(list.contains(null), isTrue);
    expect(list.toggle(null), isFalse);
    expect(list.contains(null), isFalse);

    list = <int?>[null];
    expect(list.toggle(1), isTrue);
    expect(list.contains(1), isTrue);

    list = <int?>[null];
    expect(list.toggle(null), isFalse);
    expect(list.contains(null), isFalse);

    list = <int>[1];
    expect(list.toggle(1), isFalse);
    expect(list.contains(1), isFalse);

    list = <int?>[1];
    expect(list.toggle(null), isTrue);
    expect(list.contains(null), isTrue);

    list = <int?>[null, null, null];
    expect(list.toggle(1), isTrue);
    expect(list.contains(1), isTrue);
    expect(list.contains(null), isTrue);

    list = <int?>[null, null, null];
    expect(list.toggle(null), isFalse);
    expect(list, <int?>[null, null]);

    list = <int?>[null, 1, null, 1];
    expect(list.toggle(1), isFalse);
    expect(list, <int?>[null, null, 1]);

    list = <int?>[null, 1, null, 1];
    expect(list.toggle(null), isFalse);
    expect(list, <int?>[1, null, 1]);
  });

  test("compareAsSets", () {
    // 1) Identical
    const List<int> list1 = [1, 2, 3];
    const List<int> list2 = [1, 2, 3];
    const List<int> list3 = [1, 2, 4];
    const List<int> list4 = [1, 2, 2, 3, 3, 3];
    const List<int> list5 = [1, 2, 2, 3, 3, 3, 4];
    expect(list1.compareAsSets(list1), isTrue);
    expect(list1.compareAsSets(list2), isTrue);
    expect(list1.compareAsSets(list3), isFalse);
    expect(list1.compareAsSets(list4), isTrue);
    expect(list1.compareAsSets(list5), isFalse);

    // 2) Empty
    List<int> list = [];
    expect(list.compareAsSets([]), isTrue);
    expect([].compareAsSets(list), isTrue);
  });

  test("splitList", () {
    expect([].splitList((dynamic v) => v == 3), []);

    expect([1, 2, 3, 4, 5].splitList(((v) => v == 2 || v == 4)), [
      [1],
      [3],
      [5]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].splitList(((v) => v == 3)), [
      [1, 2],
      [4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].splitList(((v) => v == 1)), [
      [2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].splitList(((v) => v == 7)), [
      [1, 2, 3, 4, 5, 6]
    ]);
  });

  test("divideList", () {
    //
    expect([].divideList((dynamic v) => v == 3), []);

    expect([1, 2, 3, 4, 5].divideList(((v) => v == 2 || v == 4)), [
      [1, 2, 3],
      [4, 5]
    ]);

    expect([0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1].divideList(((v) => v == 1)), [
      [0, 1, 0],
      [1, 0],
      [1],
      [1, 0, 0],
      [1],
      [1],
      [1],
      [1],
      [1, 0],
      [1]
    ]);

    expect([1].divideList(((v) => v == 1)), [
      [1]
    ]);

    expect([1, 2].divideList(((v) => v == 1)), [
      [1, 2]
    ]);

    expect([1, 2].divideList(((v) => v == 2)), [
      [1, 2],
    ]);

    expect([1, 2, 3].divideList(((v) => v == 2)), [
      [1, 2, 3]
    ]);

    expect([1, 2, 3].divideList(((v) => v == 2 || v == 3)), [
      [1, 2],
      [3]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList(((v) => v == 3)), [
      [1, 2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList(((v) => v == 1)), [
      [1, 2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList(((v) => v == 7)), [
      [1, 2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList(((v) => v == 8)), [
      [1, 2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList(((v) => v == 3 || v == 4)), [
      [1, 2, 3],
      [4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList(((v) => v == 3 || v == 5)), [
      [1, 2, 3, 4],
      [5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList(((v) => v == 3 || v == 6)), [
      [1, 2, 3, 4, 5],
      [6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList(((v) => v % 2 == 0)), [
      [1, 2, 3],
      [4, 5],
      [6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList(((v) => v % 2 == 1)), [
      [1, 2],
      [3, 4],
      [5, 6],
      [7]
    ]);

    expect([1, 2, 3, 8, 12, 1, 4, 6].divideList(((v) => v % 2 == 1)), [
      [1, 2],
      [3, 8, 12],
      [1, 4, 6],
    ]);
  });

  test("divideListAsMap", () {
    //
    expect(
      [1, 2, 3, 4, 5, 6, 7, 8, 9].divideListAsMap((v) => v == 3 || v == 6),
      {
        3: [3, 4, 5],
        6: [6, 7, 8, 9],
      },
    );

    expect(
      [1, 2, 3, 4, 5, 6, 7, 8, 9].divideListAsMap((v) => v == 3 || v == 6, includeFirstItems: true),
      {
        3: [1, 2, 3, 4, 5],
        6: [6, 7, 8, 9],
      },
    );

    expect(
      [1, 2, 3, 4, 5, 6, 7, 8, 9].divideListAsMap((v) => v == 52),
      {},
    );
  });

  test("divideListAsMap", () {
    //
    expect(
        [].divideListAsMap((dynamic v) => v == 3, key: (dynamic v) => -v, includeFirstItems: true),
        {});

    expect([1].divideListAsMap(((v) => v == 1)), {
      1: [1],
    });

    expect([1].divideListAsMap(((v) => v == 1), key: ((v) => -v), includeFirstItems: true), {
      -1: [1],
    });

    expect([1, 2].divideListAsMap(((v) => v == 1), key: ((v) => -v), includeFirstItems: true), {
      -1: [1, 2]
    });

    expect([1, 2].divideListAsMap(((v) => v == 2), key: ((v) => -v), includeFirstItems: true), {
      -2: [1, 2],
    });

    expect([1, 2, 3].divideListAsMap(((v) => v == 2), key: ((v) => -v), includeFirstItems: true), {
      -2: [1, 2, 3]
    });

    expect(
        [1, 2, 3]
            .divideListAsMap(((v) => v == 2 || v == 3), key: ((v) => -v), includeFirstItems: true),
        {
          -2: [1, 2],
          -3: [3]
        });

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v == 3), key: ((v) => -v), includeFirstItems: true),
        {
          -3: [1, 2, 3, 4, 5, 6, 7]
        });

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v == 3), key: ((v) => -v), includeFirstItems: false),
        {
          -3: [3, 4, 5, 6, 7]
        });

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v == 1), key: ((v) => -v), includeFirstItems: true),
        {
          -1: [1, 2, 3, 4, 5, 6, 7]
        });

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v == 7), key: ((v) => -v), includeFirstItems: true),
        {
          -7: [1, 2, 3, 4, 5, 6, 7]
        });

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v == 8), key: ((v) => -v), includeFirstItems: true),
        {});

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v == 3 || v == 4), key: ((v) => -v), includeFirstItems: true),
        {
          -3: [1, 2, 3],
          -4: [4, 5, 6, 7]
        });

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v == 3 || v == 5), key: ((v) => -v), includeFirstItems: true),
        {
          -3: [1, 2, 3, 4],
          -5: [5, 6, 7]
        });

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v == 3 || v == 6), key: ((v) => -v), includeFirstItems: true),
        {
          -3: [1, 2, 3, 4, 5],
          -6: [6, 7]
        });

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v % 2 == 0), key: ((v) => -v), includeFirstItems: true),
        {
          -2: [1, 2, 3],
          -4: [4, 5],
          -6: [6, 7]
        });

    expect(
        [1, 2, 3, 4, 5, 6, 7]
            .divideListAsMap(((v) => v % 2 == 1), key: ((v) => -v), includeFirstItems: true),
        {
          -1: [1, 2],
          -3: [3, 4],
          -5: [5, 6],
          -7: [7]
        });

    /// Repeating keys will be joined together.
    expect(
        [1, 2, 3, 8, 12, 1, 4, 6].divideListAsMap(((v) => v % 2 == 1), includeFirstItems: true), {
      1: [1, 2, 1, 4, 6],
      3: [3, 8, 12],
    });
  });

  test("addBetween", () {
    expect([].addBetween("|"), []);
    expect(["A"].addBetween("|"), ["A"]);
    expect(["A", "B"].addBetween("|"), ["A", "|", "B"]);
    expect(["A", "B", "C"].addBetween("|"), ["A", "|", "B", "|", "C"]);
  });

  test("concat | Efficiently concatenates lists. The resulting list has fixed size.", () {
    //
    // Concat lists can be sorted.
    List x = [1, 5].where((_) => true).toList(growable: false);
    List y = [2, 4].where((_) => true).toList(growable: false);
    List z = x.concat(y);
    expect(z, [1, 5, 2, 4]);
    z.sort();
    expect(z, [1, 2, 4, 5]);

    // Empty concat lists can be sorted.
    x = [].where((_) => true).toList(growable: false);
    y = [].where((_) => true).toList(growable: false);
    z = x.concat(y);
    expect(z, []);
    z.sort();
    expect(z, []);

    expect([].concat([], []), []);
    expect([5].concat([1]), [5, 1]);
    expect([5].concat([], []), [5]);
    expect([5].concat([], [1]), [5, 1]);
    expect([5].concat([], [], []), [5]);
    expect([5].concat([], [], [1]), [5, 1]);
    expect([5].concat([], [], [], []), [5]);
    expect([5].concat([], [], [], [1]), [5, 1]);
    expect([].concat([6], []), [6]);
    expect([].concat([], [7]), [7]);
    expect([1, 2].concat([3, 4, 5, 6], [7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    expect([1, 2].concat([7, 8, 9]), [1, 2, 7, 8, 9]);
    expect([1, 2].concat([], [7, 8, 9]), [1, 2, 7, 8, 9]);
    expect([1, 2].concat([2, 3], [3, 4]), [1, 2, 2, 3, 3, 4]);
    expect([1, 2].concat([2, 3], null, [3, 4]), [1, 2, 2, 3, 3, 4]);
    expect([10, 2].concat([20, 3], [30]), [10, 2, 20, 3, 30]);
    expect(["10", 2].concat([20, "3"], [30]), ["10", 2, 20, "3", 30]);
    expect(["10", 2].concat([20, "3"], [30], ["a", "b"]), ["10", 2, 20, "3", 30, "a", "b"]);
    expect([1].concat([2], [3], [4], [5]), [1, 2, 3, 4, 5]);

    // The resulting list is not unmodifiable/immutable.
    var list = [1, 2].concat([3, 4]);
    list[2] = 100;
    expect(list, [1, 2, 100, 4]);

    // The resulting list has fixed size.
    expect(() => [1, 2].concat([3, 4])..add(5), throwsA(isA<Error>()));
  });

  test("splitByLength", () {
    //
    expect([1, 2, 3, 4, 5, 6, 7, 8].splitByLength(2), [
      [1, 2],
      [3, 4],
      [5, 6],
      [7, 8],
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(2), [
      [1, 2],
      [3, 4],
      [5, 6],
      [7, 8],
      [9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(1), [
      [1],
      [2],
      [3],
      [4],
      [5],
      [6],
      [7],
      [8],
      [9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(3), [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(8), [
      [1, 2, 3, 4, 5, 6, 7, 8],
      [9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(9), [
      [1, 2, 3, 4, 5, 6, 7, 8, 9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(50), [
      [1, 2, 3, 4, 5, 6, 7, 8, 9]
    ]);
  });

  test("get, getOrNull, getAndMap", () {
    var list = ["a", "b", "c", "d", "e", "f"];

    // getOrNull
    expect(list.getOrNull(0), "a");
    expect(list.getOrNull(5), "f");
    expect(list.getOrNull(6), null);
    expect(list.getOrNull(-1), null);

    // get
    expect(list.get(0), "a");
    expect(list.get(5), "f");
    expect(() => list.get(6), throwsRangeError);
    expect(() => list.get(-1), throwsRangeError);

    // get with orElse
    expect(list.get(0, orElse: (index) => index.toString()), "a");
    expect(list.get(5, orElse: (index) => index.toString()), "f");
    expect(list.get(6, orElse: (index) => index.toString()), "6");
    expect(list.get(-1, orElse: (index) => index.toString()), "-1");

    // getAndMap
    expect(list.getAndMap(0, (idx, inRange, value) => "$idx|$inRange|$value"), "0|true|a");
    expect(list.getAndMap(5, (idx, inRange, value) => "$idx|$inRange|$value"), "5|true|f");
    expect(list.getAndMap(6, (idx, inRange, value) => "$idx|$inRange|$value"), "6|false|null");
    expect(list.getAndMap(-1, (idx, inRange, value) => "$idx|$inRange|$value"), "-1|false|null");
  });
}

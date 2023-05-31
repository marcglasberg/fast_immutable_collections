// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("empty", () {
    var set = ListSet.empty();
    expect(set.isEmpty, isTrue);
    expect(set.isNotEmpty, isFalse);
    expect(set.length, 0);
  });

  test("of", () {
    // 1) Regular usage
    var set = ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]);
    expect(set, [1, 10, 50, -2, 8, 20]);
    expect(set.length, 6);

    set = ListSet.of([1, 10, 50, -2, 8, 10, -2, 20], sort: true);
    expect(set, [-2, 1, 8, 10, 20, 50]);
    expect(set.length, 6);

    set = ListSet.of([1, 10, 50, -2, 8, 10, -2, 20],
        sort: true, compare: (int a, int b) => -a.compareTo(b));
    expect(set, [50, 20, 10, 8, 1, -2]);
    expect(set.length, 6);

    // 2) Other edge cases

    set = ListSet.of([]);
    expect(set, []);
    expect(set.length, 0);

    set = ListSet.of([2, 1, 3], compare: null);
    expect(set, [2, 1, 3]);
    expect(set.length, 3);
  });

  test("add", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).add(100), throwsUnsupportedError);
  });

  test("add", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).addAll([100, 1000]),
        throwsUnsupportedError);
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).addAll({100, 1000}),
        throwsUnsupportedError);
  });

  test("clear", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).clear(), throwsUnsupportedError);
  });

  test("containsAll", () {
    final ListSet<int> listSet = ListSet.of([4, 2, 3, 1]);
    expect(listSet.containsAll([2, 2, 3]), isTrue);
    expect(listSet.containsAll({1, 2, 3, 4}), isTrue);
    expect(listSet.containsAll({1, 2, 3, 4}.lock), isTrue);
    expect(listSet.containsAll({10, 20, 30, 40}), isFalse);
  });

  test("difference", () {
    final ListSet<int> listSet = ListSet.of([4, 2, 3, 1]);
    expect(listSet.difference({1, 2, 5}), {3, 4});
    expect(listSet.difference({1, 2, 3, 4}), <int>{});
  });

  test("elementAt", () {
    final ListSet<int> listSet = ListSet.of([4, 2, 3, 1]);
    expect(listSet.elementAt(0), 4);
    expect(listSet.elementAt(1), 2);
    expect(listSet.elementAt(2), 3);
    expect(listSet.elementAt(3), 1);
  });

  test("intersection", () {
    final ListSet<int> iset = ListSet.of({1, 2, 3, 4});
    expect(iset.intersection({1, 2, 5}), {1, 2});
    expect(iset.intersection({10, 20, 50}), <int>{});
  });

  test("difference", () {
    final ListSet<int> listSet = ListSet.of([1, 2, 3, 4]);
    expect(listSet.difference({1, 2, 5}), {3, 4});
    expect(listSet.difference({1, 2, 3, 4}), <int>{});
  });

  test("lookup", () {
    final ListSet<int> listSet = ListSet.of([1, 2, 3, 4]);
    expect(listSet.lookup(1), 1);
    expect(listSet.lookup(10), isNull);
  });

  test("toList", () {
    final ListSet<int> listSet = ListSet.of([1, 10, 11]);
    expect(listSet.toList(), [1, 10, 11]);
    expect(listSet, [1, 10, 11]);
  });

  test("union", () {
    final ListSet<int> listSet = ListSet.of({1, 2, 3, 4});
    expect(listSet.union({1}), {1, 2, 3, 4});
    expect(listSet.union({1, 2, 5}), {1, 2, 3, 4, 5});
  });

  test("+", () {
    // 1) Simple example
    expect(ListSet.of({1, 2, 3}) + [1, 2, 4], {1, 2, 3, 4});

    // 2) Regular Usage
    expect(ListSet.of(<int>{}) + [1, 2], {1, 2});
    expect(ListSet.of(<int?>{null}) + ListSet.of({1, 2}), {null, 1, 2});
    expect(ListSet.of(<int>{1}) + ListSet.of({2, 3}), {1, 2, 3});
    expect(ListSet.of(<int?>{null, 1, 3}) + ListSet.of({10, 11}), {null, 1, 3, 10, 11});
    expect(ListSet.of({1, 2, 3, 4}) + ListSet.of({5, 6}), {1, 2, 3, 4, 5, 6});

    // 3) Adding nulls
    expect(ListSet.of(<int?>{null}) + ListSet.of({null}), {null});
    expect(ListSet.of(<int?>{null, 1, 3}) + ListSet.of({null}), {null, 1, 3});

    // 4) Adding null and an item
    expect(ListSet.of(<int?>{null}) + ListSet.of({null, 1}), {null, 1});
    expect(ListSet.of(<int?>{null, 1, 3}) + ListSet.of({null, 1}), {null, 1, 3});
  });

  test("asMap", () {
    expect(ListSet.of(["hel", "lo", "there"]).asMap(), isA<Map<int, String>>());
    expect(ListSet.of(["hel", "lo", "there"]).asMap(), {0: "hel", 1: "lo", 2: "there"});
  });

  test("getRange", () {
    final ListSet<String> colors = ListSet.of(["red", "green", "blue", "orange", "pink"]);
    final Iterable<String> range = colors.getRange(1, 4);
    expect(range, ["green", "blue", "orange"]);
    expect(colors, ["red", "green", "blue", "orange", "pink"]);
  });

  test("indexOf", () {
    var listSet = ListSet.of(["do", "re", "mi", "re"]);

    // 1) Regular usage
    expect(listSet.indexOf("re"), 1);
    expect(listSet.indexOf("re", 2), -1);
    expect(listSet.indexOf("fa"), -1);

    // 2) Start is out of range
    expect(listSet.indexOf("re", -1), 1);
    expect(listSet.indexOf("re", 4), -1);
  });

  test("indexWhere", () {
    final ListSet<String> listSet = ListSet.of(["do", "re", "mi", "re"]);

    // 1) Start negative or bigger than the length
    expect(listSet.indexWhere((String element) => true, -1), 0);
    expect(listSet.indexWhere((String element) => true, listSet.length + 1), -1);

    // 2) Regular usage
    expect(listSet.indexWhere((String element) => element == "re"), 1);
    expect(listSet.indexWhere((String element) => element == "re", 2), -1);
    expect(listSet.indexWhere((String element) => element == "fa"), -1);

    // 3) Empty list or list with a single item
    var emptyIlist = IList<String>();
    expect(emptyIlist.indexWhere((String? element) => element == "x"), -1);

    emptyIlist = ["do"].lock;
    expect(emptyIlist.indexWhere((String? element) => element == "x"), -1);
    expect(emptyIlist.indexWhere((String? element) => element == "do"), 0);
  });

  test("lastIndexOf", () {
    // 1) Regular Usage
    final ListSet<String> listSet = ListSet.of(["do", "re", "mi", "re"]);
    expect(listSet.lastIndexOf("re", 2), 1);
    expect(listSet.lastIndexOf("re"), 1);
    expect(listSet.lastIndexOf("fa"), -1);

    // 2) Start is out of range
    expect(listSet.lastIndexOf("do", -1), -1);
    expect(listSet.lastIndexOf("do", 4), 0);
  });

  test("lastIndexWhere", () {
    // 1) Regular usage
    final ListSet<String> listSet = ListSet.of(["do", "re", "mi", "re"]);
    expect(listSet.lastIndexWhere((String note) => note.startsWith("r")), 1);
    expect(listSet.lastIndexWhere((String note) => note.startsWith("r"), 2), 1);
    expect(listSet.lastIndexWhere((String note) => note.startsWith("k")), -1);

    // 2) Start is out of range
    expect(listSet.lastIndexWhere((String note) => false, -1), -1);
    expect(listSet.lastIndexWhere((String note) => false, 4), -1);
    expect(listSet.lastIndexWhere((String note) => note.startsWith("d"), -1), -1);
    expect(listSet.lastIndexWhere((String note) => note.startsWith("d"), 4), 0);
  });

  test("reversed", () {
    expect(ListSet.of(["do", "re", "mi", "re"]).reversed, ["mi", "re", "do"]);
  });

  test("reversedView", () {
    expect(ListSet.of(["do", "re", "mi", "re"]).reversedView, ["mi", "re", "do"]);
  });

  test("remove", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).remove(10), throwsUnsupportedError);
  });

  test("removeAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeAll([10, 50, 100]),
        throwsUnsupportedError);
  });

  test("removeAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeAll([10, 50, 100]),
        throwsUnsupportedError);
  });

  test("removeWhere", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeWhere((int value) => value > 10),
        throwsUnsupportedError);
  });

  test("retainsAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).retainAll([10, 50, 100]),
        throwsUnsupportedError);
  });

  test("retainWhere", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).retainWhere((int value) => value > 10),
        throwsUnsupportedError);
  });

  test("[]=", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20])[3] = 1000, throwsUnsupportedError);
  });

  test("fillRange", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).fillRange(1, 3, 1000),
        throwsUnsupportedError);
  });

  test("first setter", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).first = 1000, throwsUnsupportedError);
  });

  test("insert", () {
    expect(
        () => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).insert(3, 1000), throwsUnsupportedError);
  });

  test("insertAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).insertAll(3, [1000, 100]),
        throwsUnsupportedError);
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).insertAll(3, {1000, 100}),
        throwsUnsupportedError);
  });

  test("last setter", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).last = 1000, throwsUnsupportedError);
  });

  test("length setter", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).length = 1000, throwsUnsupportedError);
  });

  test("removeAt", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeAt(10), throwsUnsupportedError);
  });

  test("removeLast", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeLast(), throwsUnsupportedError);
  });

  test("removeRange", () {
    expect(
        () => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeRange(1, 5), throwsUnsupportedError);
  });

  test("replaceRange", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).replaceRange(1, 5, [100, 1000]),
        throwsUnsupportedError);
  });

  test("setAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).setAll(5, [100, 1000]),
        throwsUnsupportedError);
  });

  test("setRange", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).setRange(1, 5, [100, 1000]),
        throwsUnsupportedError);
  });

  test("shuffle", () {
    final ListSet<int> listSet = ListSet.of([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    expect(listSet, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    listSet.shuffle(Random(0));
    expect(listSet, [1, 5, 3, 9, 6, 8, 7, 2, 4]);
  });

  test("sort", () {
    ListSet<int> listSet = ListSet.of([10, 2, 4, 6, 5]);
    listSet.sort();
    expect(listSet, [2, 4, 5, 6, 10]);

    listSet = ListSet.of([10, 2, 4, 6, 5]);
    listSet.sort((int a, int b) => -a.compareTo(b));
    expect(listSet, [10, 6, 5, 4, 2]);
  });

  test("sublist", () {
    final ListSet<String> colors = ListSet.of(["red", "green", "blue", "orange", "pink"]);
    expect(colors.sublist(1, 3), ["green", "blue"]);
    expect(colors.sublist(1), ["green", "blue", "orange", "pink"]);
    expect(colors, ["red", "green", "blue", "orange", "pink"]);
  });

  test("Example used in the readme", () {
    ListSet<int> listSet = ListSet.of([1, 2, 3]);
    expect(listSet[2], 3);
    expect(listSet.contains(2), isTrue);

    List<int> list = listSet;
    Set<int> set = listSet;

    expect(list[2], 3);
    expect(set.contains(2), isTrue);
  });
}

// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each, collection_methods_unrelated_type
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("ListMap.unsafeFrom | Map and list with different lengths throw an AssertionError", () {
    // List is shorter than the map.
    expect(
        () => ListMap<String, int>.unsafeFrom(map: {"a": 1, "b": 2}, list: ["a"]),
        throwsA(isA<AssertionError>()
            .having((e) => e.message, "message", "Map has 2 but list has 1 items.")));

    // List is longer than the map.
    expect(
        () => ListMap<String, int>.unsafeFrom(map: {"a": 1}, list: ["a", "b", "c"]),
        throwsA(isA<AssertionError>()
            .having((e) => e.message, "message", "Map has 1 but list has 3 items.")));

    // Empty map, non-empty list.
    expect(() => ListMap<String, int>.unsafeFrom(map: {}, list: ["a"]),
        throwsA(isA<AssertionError>()));
  });

  test("ListMap.unsafeFrom | Same lengths, including empty", () {
    final ListMap<String, int> empty = ListMap.unsafeFrom(map: {}, list: []);
    expect(empty.isEmpty, isTrue);
    expect(empty.length, 0);

    final ListMap<String, int> listMap = ListMap.unsafeFrom(map: {"a": 1, "b": 2}, list: ["b", "a"]);
    expect(listMap.keys, ["b", "a"]);
    expect(listMap.values, [2, 1]);
  });

  test("ListMap.insert | Throws UnsupportedError", () {
    final ListMap<String, int> listMap = ListMap.of({"a": 1, "b": 2});
    expect(() => listMap.insert(0, "c", 3), throwsUnsupportedError);
    expect(() => listMap.insert(1, "a", 10), throwsUnsupportedError);
    expect(() => ListMap<String, int>.empty().insert(0, "a", 1), throwsUnsupportedError);

    // Nothing changed.
    expect(listMap.keys, ["a", "b"]);
    expect(listMap.values, [1, 2]);
  });

  test("ListMapView.insert | Throws UnsupportedError", () {
    final ListMapView<String, int> view = ListMapView({"a": 1, "b": 2});
    expect(() => view.insert(0, "c", 3), throwsUnsupportedError);
    expect(() => view.insert(0, "a", 3), throwsUnsupportedError);
    expect(view.length, 2);
    expect(view["a"], 1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ListMap.cast | Keeps the entries and their order", () {
    final ListMap<String, int> listMap = ListMap.of({"c": 3, "a": 1, "b": 2}, sort: true);
    final ListMap<String, num> casted = listMap.cast<String, num>();

    expect(casted, isA<ListMap<String, num>>());
    expect(casted.keys, ["a", "b", "c"]);
    expect(casted.values, [1, 2, 3]);
    expect(casted.length, 3);
    expect(casted["a"], 1);
    expect(casted.entryAt(2).key, "c");
    expect(casted.entryAt(2).value, 3);

    final ListMap<Object, Object> casted2 = ListMap<String, int>.empty().cast<Object, Object>();
    expect(casted2.isEmpty, isTrue);
  });

  test("ListMap.cast | Invalid cast throws when the values are read", () {
    final ListMap<String, Object> listMap = ListMap.of(<String, Object>{"a": 1, "b": "x"});
    final ListMap<String, int> casted = listMap.cast<String, int>();
    expect(casted["a"], 1);
    expect(() => casted["b"], throwsA(isA<TypeError>()));
  });

  test("ListMap.containsKey / containsValue", () {
    final ListMap<String, int?> listMap = ListMap.of({"a": 1, "b": null});

    expect(listMap.containsKey("a"), isTrue);
    expect(listMap.containsKey("b"), isTrue);
    expect(listMap.containsKey("c"), isFalse);
    expect(listMap.containsKey(null), isFalse);
    expect(listMap.containsKey(1), isFalse);

    expect(listMap.containsValue(1), isTrue);
    expect(listMap.containsValue(null), isTrue);
    expect(listMap.containsValue(2), isFalse);
    expect(listMap.containsValue("a"), isFalse);

    expect(ListMap<String, int>.empty().containsKey("a"), isFalse);
    expect(ListMap<String, int>.empty().containsValue(1), isFalse);
  });

  test("ListMap.keys / values / entries | Follow the list order, and keys are unmodifiable", () {
    final ListMap<String, int> listMap = ListMap.of({"b": 2, "c": 3, "a": 1});
    expect(listMap.keys, ["b", "c", "a"]);
    expect(listMap.values, [2, 3, 1]);
    expect(listMap.entries.map((e) => "${e.key}${e.value}"), ["b2", "c3", "a1"]);

    // Keys is an unmodifiable list view.
    expect(listMap.keys, isA<List<String>>());
    expect(() => (listMap.keys as List<String>).add("d"), throwsUnsupportedError);
    expect(() => (listMap.keys as List<String>)[0] = "z", throwsUnsupportedError);

    // After sorting, the order changes.
    listMap.sort();
    expect(listMap.keys, ["a", "b", "c"]);
    expect(listMap.values, [1, 2, 3]);
    expect(listMap.entries.map((e) => "${e.key}${e.value}"), ["a1", "b2", "c3"]);
  });

  test("ListMap.sort | Without a compare function uses the natural order", () {
    final ListMap<int, String> listMap = ListMap.of({3: "c", 1: "a", 2: "b"});
    listMap.sort();
    expect(listMap.keys, [1, 2, 3]);
    expect(listMap.values, ["a", "b", "c"]);

    final ListMap<int, String> empty = ListMap.empty();
    empty.sort();
    expect(empty.isEmpty, isTrue);
  });

  test("ListMap.of / fromEntries | Sort with a compare function", () {
    final ListMap<String, int> listMap1 = ListMap.of({"a": 1, "ccc": 3, "bb": 2},
        sort: true, compare: (a, b) => b.length.compareTo(a.length));
    expect(listMap1.keys, ["ccc", "bb", "a"]);

    final ListMap<String, int> listMap2 = ListMap.fromEntries(
      [MapEntry("a", 1), MapEntry("ccc", 3), MapEntry("bb", 2), MapEntry("a", 10)],
      sort: true,
      compare: (a, b) => b.length.compareTo(a.length),
    );
    expect(listMap2.keys, ["ccc", "bb", "a"]);
    expect(listMap2["a"], 10); // Last occurrence wins.
  });

  test("ListMap.fromEntries | Repeated keys keep the first position, but the last value", () {
    final ListMap<String, int> listMap = ListMap.fromEntries([
      MapEntry("b", 1),
      MapEntry("a", 2),
      MapEntry("b", 3),
    ]);
    expect(listMap.keys, ["b", "a"]);
    expect(listMap.values, [3, 2]);
  });

  test("ListMap.indexOfKey", () {
    final ListMap<String, int> listMap = ListMap.of({"b": 2, "c": 3, "a": 1});
    expect(listMap.indexOfKey("b"), 0);
    expect(listMap.indexOfKey("c"), 1);
    expect(listMap.indexOfKey("a"), 2);
    expect(listMap.indexOfKey("x"), -1);

    // With start.
    expect(listMap.indexOfKey("b", 1), -1);
    expect(listMap.indexOfKey("a", 1), 2);
    expect(listMap.indexOfKey("a", 2), 2);
    expect(listMap.indexOfKey("a", 3), -1);

    expect(ListMap<String, int>.empty().indexOfKey("a"), -1);
  });

  test("ListMap.isEmpty / isNotEmpty / length", () {
    final ListMap<String, int> empty = ListMap.empty();
    expect(empty.isEmpty, isTrue);
    expect(empty.isNotEmpty, isFalse);
    expect(empty.length, 0);
    expect(() => empty.entryAt(0), throwsRangeError);
    expect(() => empty.keyAt(0), throwsRangeError);
    expect(() => empty.valueAt(0), throwsRangeError);

    final ListMap<String, int> single = ListMap.of({"a": 1});
    expect(single.isEmpty, isFalse);
    expect(single.isNotEmpty, isTrue);
    expect(single.length, 1);
  });

  test("ListMap.shuffle | Keeps the same entries", () {
    final ListMap<int, int> listMap = ListMap.of({for (int i = 0; i < 20; i++) i: i * 10});
    listMap.shuffle(Random(42));
    expect(listMap.length, 20);
    expect(listMap.keys.toSet(), {for (int i = 0; i < 20; i++) i});
    for (int i = 0; i < 20; i++) expect(listMap.valueAt(i), listMap.keyAt(i) * 10);
    expect(listMap.keys, isNot([for (int i = 0; i < 20; i++) i]));
  });

  test("ListMap.unsafeView | Returns the same instance if already a ListMap", () {
    final ListMap<String, int> listMap = ListMap.of({"a": 1});
    expect(identical(ListMap.unsafeView(listMap), listMap), isTrue);

    final ListMapView<String, int> view = ListMapView({"a": 1});
    expect(identical(ListMap.unsafeView(view), view), isTrue);
  });

  test("ListMap.unsafeView | Creates a ListMapView for a regular map, without copying it", () {
    final Map<String, int> map = {"a": 1, "b": 2};
    final ListMap<String, int> view = ListMap.unsafeView(map);
    expect(view, isA<ListMapView<String, int>>());
    expect(view.keys, ["a", "b"]);
    expect(view["b"], 2);

    // Not a copy: changes to the original map are visible.
    map["c"] = 3;
    expect(view.length, 3);
    expect(view["c"], 3);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ListMapView.[]", () {
    final ListMapView<String, int?> view = ListMapView({"a": 1, "b": null});
    expect(view["a"], 1);
    expect(view["b"], isNull);
    expect(view["c"], isNull);
  });

  test("ListMapView.entries / keys / values", () {
    final ListMapView<String, int> view = ListMapView({"b": 2, "a": 1});
    expect(view.entries.map((e) => "${e.key}${e.value}"), ["b2", "a1"]);
    expect(view.keys, ["b", "a"]);
    expect(view.values, [2, 1]);
    expect(view.length, 2);

    final ListMapView<String, int> empty = ListMapView({});
    expect(empty.entries, isEmpty);
    expect(empty.keys, isEmpty);
    expect(empty.values, isEmpty);
    expect(empty.length, 0);
  });

  test("ListMapView.indexOfKey | When the viewed map is itself a ListMap", () {
    final ListMap<String, int> listMap = ListMap.of({"c": 3, "a": 1, "b": 2}, sort: true);
    final ListMapView<String, int> view = ListMapView(listMap);
    expect(view.indexOfKey("a"), 0);
    expect(view.indexOfKey("c"), 2);
    expect(view.indexOfKey("a", 1), -1);
    expect(view.indexOfKey("x"), -1);
  });

  test("ListMapView.containsKey / containsValue", () {
    final ListMapView<String, int> view = ListMapView({"a": 1});
    expect(view.containsKey("a"), isTrue);
    expect(view.containsKey("b"), isFalse);
    expect(view.containsValue(1), isTrue);
    expect(view.containsValue(2), isFalse);
  });

  test("map | keeps the order of the ListMap", () {
    final ListMap<String, int> sorted = ListMap.of({"b": 1, "a": 2, "c": 3}, sort: true);
    final Map<String, int> mapped = sorted.map((k, v) => MapEntry(k, v * 10));
    expect(mapped.keys, ["a", "b", "c"]);
    expect(mapped.values, [20, 10, 30]);

    final ListMap<String, int> notSorted = ListMap.of({"c": 1, "a": 2, "b": 3});
    expect(notSorted.map((k, v) => MapEntry(v, k)).keys, [1, 2, 3]);
    expect(notSorted.map((k, v) => MapEntry(v, k)).values, ["c", "a", "b"]);

    // Keys mapped to the same new key: the last one wins, like Map.map.
    expect(notSorted.map((k, v) => MapEntry("x", v)), {"x": 3});
  });
}

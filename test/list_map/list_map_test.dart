import "dart:math";

import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("empty", () {
    final ListMap<String, int> map = ListMap.empty();
    expect(map.isEmpty, isTrue);
    expect(map.isNotEmpty, isFalse);
    expect(map.length, 0);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("of", () {
    // 1) Simple
    ListMap<String, int> listMap = ListMap.of({"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6});

    expect(listMap.entryAt(0).key, "a");
    expect(listMap.entryAt(0).value, 1);
    expect(listMap.entryAt(1).key, "c");
    expect(listMap.entryAt(1).value, 3);
    expect(listMap.entryAt(2).key, "b");
    expect(listMap.entryAt(2).value, 2);
    expect(listMap.entryAt(3).key, "d");
    expect(listMap.entryAt(3).value, 4);
    expect(listMap.entryAt(4).key, "e");
    expect(listMap.entryAt(4).value, 5);
    expect(listMap.entryAt(5).key, "f");
    expect(listMap.entryAt(5).value, 6);

    // 2) With sort
    listMap = ListMap.of({"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6}, sort: true);

    expect(listMap.entryAt(0).key, "a");
    expect(listMap.entryAt(0).value, 1);
    expect(listMap.entryAt(1).key, "b");
    expect(listMap.entryAt(1).value, 2);
    expect(listMap.entryAt(2).key, "c");
    expect(listMap.entryAt(2).value, 3);
    expect(listMap.entryAt(3).key, "d");
    expect(listMap.entryAt(3).value, 4);
    expect(listMap.entryAt(4).key, "e");
    expect(listMap.entryAt(4).value, 5);
    expect(listMap.entryAt(5).key, "f");
    expect(listMap.entryAt(5).value, 6);

    // 3) With sort and compare
    listMap = ListMap.of({"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6},
        sort: true, compare: (String keyA, String keyB) => -keyA.compareTo(keyB));

    expect(listMap.entryAt(0).key, "f");
    expect(listMap.entryAt(0).value, 6);
    expect(listMap.entryAt(1).key, "e");
    expect(listMap.entryAt(1).value, 5);
    expect(listMap.entryAt(2).key, "d");
    expect(listMap.entryAt(2).value, 4);
    expect(listMap.entryAt(3).key, "c");
    expect(listMap.entryAt(3).value, 3);
    expect(listMap.entryAt(4).key, "b");
    expect(listMap.entryAt(4).value, 2);
    expect(listMap.entryAt(5).key, "a");
    expect(listMap.entryAt(5).value, 1);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("fromEntries", () {
    // TODO: Marcelo, se vc substituir `HashMap` por `LinkedHashMap`
    // na implementação, funcionaria...

    // 1) Simple
    ListMap<String, int> listMap = ListMap.fromEntries([
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("c", 3),
      MapEntry<String, int>("b", 2),
      MapEntry<String, int>("d", 4),
      MapEntry<String, int>("e", 5),
      MapEntry<String, int>("f", 6),
    ]);

    expect(listMap.entryAt(0).key, "a");
    expect(listMap.entryAt(0).value, 1);
    expect(listMap.entryAt(1).key, "c");
    expect(listMap.entryAt(1).value, 3);
    expect(listMap.entryAt(2).key, "b");
    expect(listMap.entryAt(2).value, 2);
    expect(listMap.entryAt(3).key, "d");
    expect(listMap.entryAt(3).value, 4);
    expect(listMap.entryAt(4).key, "e");
    expect(listMap.entryAt(4).value, 5);
    expect(listMap.entryAt(5).key, "f");
    expect(listMap.entryAt(5).value, 6);

    // 2) With sort
    listMap = ListMap.fromEntries([
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("c", 3),
      MapEntry<String, int>("b", 2),
      MapEntry<String, int>("d", 4),
      MapEntry<String, int>("e", 5),
      MapEntry<String, int>("f", 6),
    ], sort: true);

    expect(listMap.entryAt(0).key, "a");
    expect(listMap.entryAt(0).value, 1);
    expect(listMap.entryAt(1).key, "b");
    expect(listMap.entryAt(1).value, 2);
    expect(listMap.entryAt(2).key, "c");
    expect(listMap.entryAt(2).value, 3);
    expect(listMap.entryAt(3).key, "d");
    expect(listMap.entryAt(3).value, 4);
    expect(listMap.entryAt(4).key, "e");
    expect(listMap.entryAt(4).value, 5);
    expect(listMap.entryAt(5).key, "f");
    expect(listMap.entryAt(5).value, 6);

    // 3) With sort and compare
    listMap = ListMap.fromEntries([
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("c", 3),
      MapEntry<String, int>("b", 2),
      MapEntry<String, int>("d", 4),
      MapEntry<String, int>("e", 5),
      MapEntry<String, int>("f", 6),
    ], sort: true, compare: (String keyA, String keyB) => -keyA.compareTo(keyB));

    expect(listMap.entryAt(0).key, "f");
    expect(listMap.entryAt(0).value, 6);
    expect(listMap.entryAt(1).key, "e");
    expect(listMap.entryAt(1).value, 5);
    expect(listMap.entryAt(2).key, "d");
    expect(listMap.entryAt(2).value, 4);
    expect(listMap.entryAt(3).key, "c");
    expect(listMap.entryAt(3).value, 3);
    expect(listMap.entryAt(4).key, "b");
    expect(listMap.entryAt(4).value, 2);
    expect(listMap.entryAt(5).key, "a");
    expect(listMap.entryAt(5).value, 1);
  }, skip: true);

  /////////////////////////////////////////////////////////////////////////////

  test("unsafe", () {
    // 1) Simple
    Map<String, int> initialMap = {"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6};
    ListMap<String, int> listMap = ListMap.of(initialMap);

    expect(listMap.entryAt(0).key, "a");
    expect(listMap.entryAt(0).value, 1);
    expect(listMap.entryAt(1).key, "c");
    expect(listMap.entryAt(1).value, 3);
    expect(listMap.entryAt(2).key, "b");
    expect(listMap.entryAt(2).value, 2);
    expect(listMap.entryAt(3).key, "d");
    expect(listMap.entryAt(3).value, 4);
    expect(listMap.entryAt(4).key, "e");
    expect(listMap.entryAt(4).value, 5);
    expect(listMap.entryAt(5).key, "f");
    expect(listMap.entryAt(5).value, 6);

    expect(() => listMap.entryAt(6).key, throwsRangeError);

    initialMap.addAll({"z": 100});

    expect(listMap.entryAt(6).key, "z");
    expect(listMap.entryAt(6).value, 100);

    // 2) With sort
    initialMap = {"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6};
    listMap = ListMap.of(initialMap, sort: true);

    expect(listMap.entryAt(0).key, "a");
    expect(listMap.entryAt(0).value, 1);
    expect(listMap.entryAt(1).key, "b");
    expect(listMap.entryAt(1).value, 2);
    expect(listMap.entryAt(2).key, "c");
    expect(listMap.entryAt(2).value, 3);
    expect(listMap.entryAt(3).key, "d");
    expect(listMap.entryAt(3).value, 4);
    expect(listMap.entryAt(4).key, "e");
    expect(listMap.entryAt(4).value, 5);
    expect(listMap.entryAt(5).key, "f");
    expect(listMap.entryAt(5).value, 6);

    expect(() => listMap.entryAt(6).key, throwsRangeError);

    initialMap.addAll({"z": 100});

    expect(listMap.entryAt(6).key, "z");
    expect(listMap.entryAt(6).value, 100);

    // 3) With sort and compare
    initialMap = {"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6};
    listMap = ListMap.of(initialMap,
        sort: true, compare: (String keyA, String keyB) => -keyA.compareTo(keyB));

    expect(listMap.entryAt(0).key, "f");
    expect(listMap.entryAt(0).value, 6);
    expect(listMap.entryAt(1).key, "e");
    expect(listMap.entryAt(1).value, 5);
    expect(listMap.entryAt(2).key, "d");
    expect(listMap.entryAt(2).value, 4);
    expect(listMap.entryAt(3).key, "c");
    expect(listMap.entryAt(3).value, 3);
    expect(listMap.entryAt(4).key, "b");
    expect(listMap.entryAt(4).value, 2);
    expect(listMap.entryAt(5).key, "a");
    expect(listMap.entryAt(5).value, 1);

    expect(() => listMap.entryAt(6).key, throwsRangeError);

    initialMap.addAll({"z": 100});

    expect(listMap.entryAt(6).key, "z");
    expect(listMap.entryAt(6).value, 100);
  }, skip: true);

  /////////////////////////////////////////////////////////////////////////////

  test("[]=", () {
    // TODO: Complete specification
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10})["a"] = 100, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("addAll", () {
    // TODO: Complete specification
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).addAll({"a": 3, "d": 10}),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("addAll", () {
    // TODO: Complete specification
    expect(
        () =>
            ListMap.of({"b": 1, "a": 2, "c": 10}).addEntries([MapEntry("a", 3), MapEntry("d", 10)]),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("clear", () {
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).clear(), throwsUnsupportedError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("map", () {
    final ListMap<String, int> listMap =
        ListMap.of({"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6});
    final Map<String, int> mapped =
        listMap.map<String, int>((String k, int v) => MapEntry(k, v + 1));
    expect(mapped, {"a": 2, "b": 3, "c": 4, "d": 5, "e": 6, "f": 7});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("forEach", () {
    final ListMap<String, int> listMap =
        ListMap.of({"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6});
    int result = 100;
    listMap.forEach((String k, int v) => result *= 1 + v);
    expect(result, 504000);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("putIfAbsent", () {
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).putIfAbsent("d", () => 10),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("remove", () {
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).remove("d"), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeWhere", () {
    expect(
        () => ListMap.of({"b": 1, "a": 2, "c": 10})
            .removeWhere((String key, int value) => key == "a"),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("update", () {
    // TODO: Complete specification
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).update("d", (int value) => 2 * value),
        throwsUnsupportedError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("shuffle", () {
    final ListMap<String, int> listMap =
        ListMap.of({"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6});
    listMap.shuffle(Random(0));

    expect(listMap.entryAt(0).key, "b");
    expect(listMap.entryAt(0).value, 2);
    expect(listMap.entryAt(1).key, "f");
    expect(listMap.entryAt(1).value, 6);
    expect(listMap.entryAt(2).key, "c");
    expect(listMap.entryAt(2).value, 3);
    expect(listMap.entryAt(3).key, "a");
    expect(listMap.entryAt(3).value, 1);
    expect(listMap.entryAt(4).key, "e");
    expect(listMap.entryAt(4).value, 5);
    expect(listMap.entryAt(5).key, "d");
    expect(listMap.entryAt(5).value, 4);

    expect(() => listMap.entryAt(6), throwsRangeError);
    expect(() => listMap.entryAt(-1), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("sort", () {
    final ListMap<String, int> listMap =
        ListMap.of({"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6});
    listMap.sort((String keyA, String keyB) => -keyA.compareTo(keyB));

    expect(listMap.entryAt(0).key, "f");
    expect(listMap.entryAt(0).value, 6);
    expect(listMap.entryAt(1).key, "e");
    expect(listMap.entryAt(1).value, 5);
    expect(listMap.entryAt(2).key, "d");
    expect(listMap.entryAt(2).value, 4);
    expect(listMap.entryAt(3).key, "c");
    expect(listMap.entryAt(3).value, 3);
    expect(listMap.entryAt(4).key, "b");
    expect(listMap.entryAt(4).value, 2);
    expect(listMap.entryAt(5).key, "a");
    expect(listMap.entryAt(5).value, 1);

    expect(() => listMap.entryAt(6), throwsRangeError);
    expect(() => listMap.entryAt(-1), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("entryAt", () {
    final ListMap<String, int> listMap =
        ListMap.of({"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6});

    expect(listMap.entryAt(0).key, "a");
    expect(listMap.entryAt(0).value, 1);
    expect(listMap.entryAt(2).key, "b");
    expect(listMap.entryAt(2).value, 2);
    expect(listMap.entryAt(1).key, "c");
    expect(listMap.entryAt(1).value, 3);
    expect(listMap.entryAt(3).key, "d");
    expect(listMap.entryAt(3).value, 4);
    expect(listMap.entryAt(4).key, "e");
    expect(listMap.entryAt(4).value, 5);
    expect(listMap.entryAt(5).key, "f");
    expect(listMap.entryAt(5).value, 6);

    expect(() => listMap.entryAt(6), throwsRangeError);
    expect(() => listMap.entryAt(-1), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("keyAt", () {
    final ListMap<String, int> listMap =
        ListMap.of({"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6});

    expect(listMap.keyAt(0), "a");
    expect(listMap.keyAt(2), "b");
    expect(listMap.keyAt(1), "c");
    expect(listMap.keyAt(3), "d");
    expect(listMap.keyAt(4), "e");
    expect(listMap.keyAt(5), "f");

    expect(() => listMap.keyAt(6), throwsRangeError);
    expect(() => listMap.keyAt(-1), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("valueAt", () {
    final ListMap<String, int> listMap =
        ListMap.of({"a": 1, "c": 3, "b": 2, "d": 4, "e": 5, "f": 6});

    expect(listMap.valueAt(0), 1);
    expect(listMap.valueAt(2), 2);
    expect(listMap.valueAt(1), 3);
    expect(listMap.valueAt(3), 4);
    expect(listMap.valueAt(4), 5);
    expect(listMap.valueAt(5), 6);

    expect(() => listMap.valueAt(6), throwsRangeError);
    expect(() => listMap.valueAt(-1), throwsRangeError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("updateAll", () {
    // TODO: Complete specification
    expect(
        () => ListMap.of({"b": 1, "a": 2, "c": 10}).updateAll((String key, int value) => 2 * value),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////
}

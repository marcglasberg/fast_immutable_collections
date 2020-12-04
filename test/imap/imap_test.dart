import "dart:collection";

import "package:flutter_test/flutter_test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  setUp(() {
    ImmutableCollection.autoFlush = false;
  });

//////////////////////////////////////////////////////////////////////////////

  test("Runtime Type", () {
    expect(IMap(), isA<IMap>());
    expect(IMap({}), isA<IMap>());
    expect(IMap<String, int>({}), isA<IMap<String, int>>());
    expect(IMap({"a": 1}), isA<IMap<String, int>>());
    expect(IMap.empty<String, int>(), isA<IMap<String, int>>());
  });

  test("isEmpty | isNotEmpty", () {
    expect(IMap().isEmpty, isTrue);
    expect(IMap({}).isEmpty, isTrue);
    expect(IMap<String, int>({}).isEmpty, isTrue);
    expect(IMap({"a": 1}).isEmpty, isFalse);
    expect(IMap.empty<String, int>().isEmpty, isTrue);

    expect(IMap().isNotEmpty, isFalse);
    expect(IMap({}).isNotEmpty, isFalse);
    expect(IMap<String, int>({}).isNotEmpty, isFalse);
    expect(IMap({"a": 1}).isNotEmpty, isTrue);
    expect(IMap.empty<String, int>().isNotEmpty, isFalse);
  });

  test("IMap.unlock", () {
    final Map<String, int> map = {"a": 1, "b": 2};
    final IMap<String, int> imap = IMap(map);
    expect(imap.unlock, map);
    expect(identical(imap.unlock, map), isFalse);
  });

  test("IMap.unlockSorted", () {
    final IMap<String, int> imap =
        {"c": 3, "a": 1, "b": 2}.lock.withConfig(ConfigMap(sortKeys: false));

    expect(imap.unlockSorted, allOf(isA<LinkedHashMap<String, int>>(), {"a": 1, "b": 2, "c": 3}));
  });

  test("IMap.fromEntries() factory constructor", () {
    const List<MapEntry<String, int>> entries = [
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("b", 2),
    ];
    final IMap<String, int> fromEntries = IMap.fromEntries(entries);

    expect(fromEntries["a"], 1);
    expect(fromEntries["b"], 2);
  });

  test("IMap.fromKeys() factory constructor", () {
    const List<String> keys = ["a", "b"];
    final IMap<String, int> fromKeys =
        IMap.fromKeys(keys: keys, valueMapper: (String key) => key.hashCode);

    expect(fromKeys["a"], "a".hashCode);
    expect(fromKeys["b"], "b".hashCode);
  });

  test("IMap.fromKeys() | Neither keys nor valueMapper can be null", () {
    const List<String> keys = ["a", "b"];
    expect(() => IMap.fromKeys(keys: null, valueMapper: (String key) => key.hashCode),
        throwsAssertionError);
    expect(() => IMap.fromKeys(keys: keys, valueMapper: null), throwsAssertionError);
  });

  test("IMap.fromValues() factory constructor", () {
    const List<int> values = [1, 2];
    final IMap<String, int> fromKeys =
        IMap.fromValues(values: values, keyMapper: (int value) => value.toString());

    expect(fromKeys["1"], 1);
    expect(fromKeys["2"], 2);
  });

  test("IMap.fromIterable()", () {
    const Iterable<int> iterable = [1, 2];
    final IMap fromIterable = IMap.fromIterable(iterable,
        keyMapper: (key) => (key + 1).toString(), valueMapper: (value) => value + 2);

    expect(fromIterable["2"], 3);
    expect(fromIterable["3"], 4);
  });

  test("IMap.fromIterable() | if no mappers are passed, the identity function is used", () {
    final IMap fromIterable = IMap.fromIterable([1, 2]);

    expect(fromIterable[1], 1);
    expect(fromIterable[2], 2);
  });

  test("IMap.fromIterables() factory constructor", () {
    const Iterable<String> keys = ["a", "b"];
    const Iterable<int> values = [1, 2];
    final IMap<String, int> fromIterables = IMap.fromIterables(keys, values);

    expect(fromIterables["a"], 1);
    expect(fromIterables["b"], 2);
  });

  test("IMap.unsafe constructor | Normal usage", () {
    final Map<String, int> map = {"a": 1, "b": 2};
    final IMap<String, int> imap = IMap.unsafe(map, config: ConfigMap());

    expect(map, {"a": 1, "b": 2});
    expect(imap.unlock, {"a": 1, "b": 2});

    map.addAll({"c": 3});

    expect(map, {"a": 1, "b": 2, "c": 3});
    expect(imap.unlock, {"a": 1, "b": 2, "c": 3});
  });

  test("IMap.unsafe constructor | Disallowing it", () {
    ImmutableCollection.disallowUnsafeConstructors = true;
    final Map<String, int> map = {"a": 1, "b": 2};

    expect(() => IMap.unsafe(map, config: ConfigMap()), throwsUnsupportedError);
  });

  test("IMap.unsafe() constructor | config cannot be null",
      () => expect(() => IMap.unsafe({}, config: null), throwsAssertionError));

  //////////////////////////////////////////////////////////////////////////////
  test(
      "Equals Operator | "
      "IMap with identity-equals compares the map instance, not the items.", () {
    var myMap = IMap({"a": 1, "b": 2}).withIdentityEquals;
    expect(myMap == myMap, isTrue);
    expect(myMap == IMap({"a": 1, "b": 2}).withIdentityEquals, isFalse);
    expect(myMap == {"a": 1, "b": 2}.lock.withIdentityEquals, isFalse);
    expect(myMap == IMap({"a": 1, "b": 2, "c": 3}).withIdentityEquals, isFalse);
  });

  test(
      "Equals Operator | "
      "IMap with deep-equals compares the items, not the map instance.", () {
    var myMap = IMap({"a": 1, "b": 2}).withDeepEquals;
    expect(myMap == myMap, isTrue);
    expect(myMap == IMap({"b": 2}).add("a", 1).withDeepEquals, isTrue);
    expect(myMap == IMap({"a": 1, "b": 2}).withDeepEquals, isTrue);
    expect(myMap == {"a": 1, "b": 2}.lock.withDeepEquals, isTrue);
    expect(myMap == IMap({"a": 1, "b": 2, "c": 3}).withDeepEquals, isFalse);

    myMap = IMap({"a": 1, "b": 2});
    expect(myMap == myMap, isTrue);
    expect(myMap == IMap({"a": 1, "b": 2}), isTrue);
    expect(myMap == IMap({"a": 1, "b": 2, "c": 3}), isFalse);
  });

  test(
      "Equals Operator | "
      "IMap with deep-equals is always different "
      "from imap with identity-equals", () {
    expect(IMap({"a": 1, "b": 2}).withDeepEquals == IMap({"a": 1, "b": 2}).withIdentityEquals,
        isFalse);
    expect(IMap({"a": 1, "b": 2}).withIdentityEquals == IMap({"a": 1, "b": 2}).withDeepEquals,
        isFalse);
    expect(IMap({"a": 1, "b": 2}).withIdentityEquals == IMap({"a": 1, "b": 2}), isFalse);
    expect(IMap({"a": 1, "b": 2}) == IMap({"a": 1, "b": 2}).withIdentityEquals, isFalse);
  });

  test("IMap.isIdentityEquals and IMap.isDeepEquals properties", () {
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2}),
        iMap2 = IMap({"a": 1, "b": 2}).withIdentityEquals;

    expect(iMap1.isIdentityEquals, isFalse);
    expect(iMap1.isDeepEquals, isTrue);
    expect(iMap2.isIdentityEquals, isTrue);
    expect(iMap2.isDeepEquals, isFalse);
  });

  test("IMap.same method", () {
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2});
    expect(iMap1.same(iMap1), isTrue);
    expect(iMap1.same(IMap({"a": 1, "b": 2})), isFalse);
    expect(iMap1.same(IMap({"a": 1})), isFalse);
    expect(iMap1.same(IMap({"b": 2}).add("a", 1)), isFalse);
    expect(iMap1.same(IMap({"a": 1, "b": 2}).withIdentityEquals), isFalse);
    expect(iMap1.same(iMap1.remove("c")), isTrue);
  });

  test("IMap.equalItemsAndConfig method", () {
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2});
    expect(iMap1.equalItemsAndConfig(iMap1), isTrue);
    expect(iMap1.equalItemsAndConfig(IMap({"a": 1, "b": 2})), isTrue);
    expect(iMap1.equalItemsAndConfig(IMap({"a": 1})), isFalse);
    expect(iMap1.equalItemsAndConfig(IMap({"b": 2}).add("a", 1)), isTrue);
    expect(iMap1.equalItemsAndConfig(IMap({"a": 1, "b": 2}).withIdentityEquals), isFalse);
    expect(iMap1.equalItemsAndConfig(iMap1.remove("c")), isTrue);
  });

  test("IMap.equalItems method | Null", () {
    expect(IMap({"a": 1, "b": 2}).equalItems(null), isFalse);
  });

  test("IMap.equalItems method | Identity", () {
    final Iterable<MapEntry<String, int>> iterable1 = [
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("b", 2),
    ];
    expect(IMap({"a": 1, "b": 2}).equalItems(iterable1), isTrue);
  });

  test("IMap.equalItems method | The order doesn't matter", () {
    final Iterable<MapEntry<String, int>> iterable4 = [
      MapEntry<String, int>("b", 2),
      MapEntry<String, int>("a", 1),
    ];
    expect(IMap({"a": 1, "b": 2}).equalItems(iterable4), isTrue);
  });

  test("IMap.equalItems method | Different items yield false", () {
    final Iterable<MapEntry<String, int>> iterable3 = [
      MapEntry<String, int>("a", 1),
    ];
    expect(IMap({"a": 1, "b": 2}).equalItems(iterable3), isFalse);
  });

  test("Equal Items To... | IMap.equalItemsToMap", () {
    final IMap<String, int> imap = IMap({"a": 1, "b": 2});
    expect(imap.equalItemsToMap({"a": 1, "b": 2}), isTrue);
    expect(imap.equalItemsToMap({"a": 1, "b": 3}), isFalse);
    expect(imap.equalItemsToMap({"a": 1, "c": 2}), isFalse);
    expect(imap.equalItemsToMap({"a": 1, "b": 2, "c": 3}), isFalse);
  });

  test("Equal Items To... | IMap.equalItemsToIMap", () {
    final IMap<String, int> imap = IMap({"a": 1, "b": 2});
    expect(imap.equalItemsToIMap({"a": 1, "b": 2}.lock), isTrue);
    expect(imap.equalItemsToIMap({"a": 1, "b": 3}.lock), isFalse);
    expect(imap.equalItemsToIMap({"a": 1, "c": 2}.lock), isFalse);
    expect(imap.equalItemsToIMap({"a": 1, "b": 2, "c": 3}.lock), isFalse);
  });
  test("IMap.hashCode() | deepEquals vs deepEquals", () {
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2});
    expect(iMap1 == IMap({"a": 1, "b": 2}), isTrue);
    expect(iMap1 == IMap({"a": 1, "b": 2, "c": 3}), isFalse);
    expect(iMap1 == IMap({"b": 2}).add("a", 1), isTrue);
    expect(iMap1.hashCode, IMap({"a": 1, "b": 2}).hashCode);
    expect(iMap1.hashCode, isNot(IMap({"a": 1, "b": 2, "c": 3}).hashCode));
    expect(iMap1.hashCode, IMap({"b": 2}).add("a", 1).hashCode);
  });
  test("IMap.hashCode() | identityEquals vs identityEquals", () {
    final IMap<String, int> iMap1WithIdentity = IMap({"a": 1, "b": 2}).withIdentityEquals;
    expect(iMap1WithIdentity == IMap({"a": 1, "b": 2}).withIdentityEquals, isFalse);
    expect(iMap1WithIdentity == IMap({"a": 1, "b": 2, "c": 3}).withIdentityEquals, isFalse);
    expect(iMap1WithIdentity == IMap({"b": 2}).add("a", 1).withIdentityEquals, isFalse);
    expect(iMap1WithIdentity.hashCode, isNot(IMap({"a": 1, "b": 2}).withIdentityEquals.hashCode));
    expect(iMap1WithIdentity.hashCode,
        isNot(IMap({"a": 1, "b": 2, "c": 3}).withIdentityEquals.hashCode));
    expect(
        iMap1WithIdentity.hashCode, isNot(IMap({"b": 2}).add("a", 1).withIdentityEquals.hashCode));
  });

  test("IMap.hashCode() | deepEquals vs identityEquals", () {
    expect(IMap({"a": 1, "b": 2}) == IMap({"a": 1, "b": 2}).withIdentityEquals, isFalse);
    expect(IMap({"a": 1, "b": 2, "c": 3}) == IMap({"a": 1, "b": 2, "c": 3}).withIdentityEquals,
        isFalse);
    expect(IMap({"b": 2}).add("a", 1) == IMap({"b": 2}).add("a", 1).withIdentityEquals, isFalse);
    expect(
        IMap({"a": 1, "b": 2}).hashCode, isNot(IMap({"a": 1, "b": 2}).withIdentityEquals.hashCode));
    expect(IMap({"a": 1, "b": 2, "c": 3}).hashCode,
        isNot(IMap({"a": 1, "b": 2, "c": 3}).withIdentityEquals.hashCode));
    expect(IMap({"b": 2}).add("a", 1).hashCode,
        isNot(IMap({"b": 2}).add("a", 1).withIdentityEquals.hashCode));
  });

  test("IList.hashCode cache | when cache is on", () {
    ImmutableCollection.disallowUnsafeConstructors = false;

    final Map<String, int> map = {"a": 1, "b": 2};

    final IMap<String, int> iMapWithCache =
        IMap.unsafe(map, config: ConfigMap(cacheHashCode: true));

    final int hashBefore = iMapWithCache.hashCode;

    map.addAll({"c": 3});

    final int hashAfter = iMapWithCache.hashCode;

    expect(hashAfter, hashBefore);
  });

  test("IMap.hashCode cache | when cache is off", () {
    ImmutableCollection.disallowUnsafeConstructors = false;

    final Map<String, int> map = {"a": 1, "b": 2};

    final IMap<String, int> iMapWithCache =
        IMap.unsafe(map, config: ConfigMap(cacheHashCode: false));

    final int hashBefore = iMapWithCache.hashCode;

    map.addAll({"c": 3});

    final int hashAfter = iMapWithCache.hashCode;

    expect(hashAfter, isNot(hashBefore));
  });

  test("IMap.withConfig()", () {
    final IMap<String, int> imap = IMap({"a": 1, "b": 2});

    expect(imap.isDeepEquals, isTrue);
    expect(imap.config.sortKeys, isTrue);
    expect(imap.config.sortValues, isTrue);

    final IMap<String, int> iMapWithCompare = imap.withConfig(imap.config.copyWith(
      sortKeys: false,
      sortValues: false,
    ));

    expect(iMapWithCompare.isDeepEquals, isTrue);
    expect(iMapWithCompare.config.sortKeys, isFalse);
    expect(iMapWithCompare.config.sortValues, isFalse);
  });

  test("IMap.withConfig() | config cannot be null",
      () => expect(() => IMap({"a": 1, "b": 2}).withConfig(null), throwsAssertionError));

  test("IMap.withConfigFrom()", () {
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2});
    final IMap<String, int> iMap2 =
        IMap.withConfig({"a": 1, "b": 2}, ConfigMap(isDeepEquals: false));

    expect(iMap1.isDeepEquals, isTrue);
    expect(iMap1.config.sortKeys, isTrue);
    expect(iMap1.config.sortValues, isTrue);

    expect(iMap2.isDeepEquals, isFalse);
    expect(iMap2.config.sortKeys, isTrue);
    expect(iMap2.config.sortValues, isTrue);

    final IMap<String, int> iMap3 = iMap1.withConfigFrom(iMap2);

    expect(iMap3.isDeepEquals, isFalse);
    expect(iMap3.config.sortKeys, isTrue);
    expect(iMap3.config.sortValues, isTrue);

    expect(iMap1.unlock, {"a": 1, "b": 2});
    expect(iMap2.unlock, {"a": 1, "b": 2});
    expect(iMap3.unlock, {"a": 1, "b": 2});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Creating immutable maps with extensions | From an empty map", () {
    final IMap imap = {}.lock;
    expect(imap, isA<IMap>());
    expect(imap.isEmpty, isTrue);
    expect(imap.isNotEmpty, isFalse);
  });

  test("Creating immutable maps with extensions | From a map with one item", () {
    final IMap imap = {"a": 1}.lock;
    expect(imap, isA<IMap<String, int>>());
    expect(imap.isEmpty, isFalse);
    expect(imap.isNotEmpty, isTrue);
  });

  test("Creating immutable maps with extensions | From a map with null key, or value, or both", () {
    IMap<String, int> imap = {null: 1}.lock;
    expect(imap, isA<IMap<String, int>>());
    expect(imap.isEmpty, isFalse);
    expect(imap.isNotEmpty, isTrue);

    imap = {"a": null}.lock;
    expect(imap, isA<IMap<String, int>>());
    expect(imap.isEmpty, isFalse);
    expect(imap.isNotEmpty, isTrue);

    imap = {null: null}.lock;
    expect(imap, isA<IMap<String, int>>());
    expect(imap.isEmpty, isFalse);
    expect(imap.isNotEmpty, isTrue);
  });

  test("Creating immutable maps with extensions | From an empty map typed with String", () {
    final imap = <String, int>{}.lock;
    expect(imap, isA<IMap<String, int>>());
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Creating native mutable maps from immutable maps | From the default factory constructor",
      () {
    final Map<String, int> map = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> imap = IMap(map);

    expect(imap.unlock, map);
    expect(identical(imap.unlock, map), isFalse);
  });

  test("Creating native mutable maps from immutable maps | From lock", () {
    final Map<String, int> map = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> imap = map.lock;

    expect(imap.unlock, map);
    expect(identical(imap.unlock, map), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IMap.flush method", () {
    final IMap<String, int> imap = {"a": 1, "b": 2, "c": 3}
        .lock
        .add("d", 4)
        .addMap({"e": 5, "f": 6})
        .add("g", 7)
        .addMap({})
        .addAll(IMap({"h": 8, "i": 9}));

    expect(imap.isFlushed, isFalse);

    imap.flush;

    expect(imap.isFlushed, isTrue);
    expect(imap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8, "i": 9});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IMap.add()", () {
    final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.add("c", 3);

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3});
  });

  test("IMap.addEntry()", () {
    final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.addEntry(MapEntry<String, int>("c", 3));

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3});
  });

  test("IMap.addAll()", () {
    final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.addAll({"c": 3, "d": 4}.lock);

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});
  });

  test("IMap.addMap()", () {
    final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.addMap({"c": 3, "d": 4});

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});
  });

  test("IMap.addEntries()", () {
    final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap =
        imap.addEntries([MapEntry<String, int>("c", 3), MapEntry<String, int>("d", 4)]);

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});
  });

  test("IMap.remove()", () {
    final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.remove("b");

    expect(newIMap.unlock, {"a": 1});
  });

  test("IMap.removeWhere()", () {
    final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.removeWhere((String key, int value) => key == "b");

    expect(newIMap.unlock, {"a": 1});
  });

  test("Chaining IMap.add() and IMap.addAll()", () {
    final IMap<String, int> imap1 = {"a": 1, "b": 2, "c": 3}.lock;
    final IMap<String, int> imap2 = imap1.add("d", 4);
    final IMap<String, int> imap3 = imap2.addMap({"e": 5, "f": 6});
    final IMap<String, int> imap4 = imap3.addAll(IMap({"g": 7, "h": 8}));

    expect(imap1.unlock, {"a": 1, "b": 2, "c": 3});
    expect(imap2.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});
    expect(imap3.unlock, {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6});
    expect(imap4.unlock, {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8});

    // Methods are chainable.
    expect(imap1.add("d", 4).addMap({"e": 5, "f": 6}).addAll(IMap({"g": 7, "h": 8})).unlock,
        {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8});
  });

  test("Multiple IMap.removes", () {
    final IMap<String, int> imap1 = {"a": 1, "b": 2, "c": 3}.lock;
    final IMap<String, int> imap2 = imap1.remove("b");
    final IMap<String, int> imap3 = imap2.remove("x");
    final IMap<String, int> imap4 = imap3.remove("a");
    final IMap<String, int> imap5 = imap4.remove("c");
    final IMap<String, int> imap6 = imap5.remove("y");

    expect(imap1.unlock, {"a": 1, "b": 2, "c": 3});
    expect(imap2.unlock, {"a": 1, "c": 3});
    expect(imap3.unlock, {"a": 1, "c": 3});
    expect(imap4.unlock, {"c": 3});
    expect(imap5.unlock, {});
    expect(imap6.unlock, {});

    expect(imap1.same(imap2), isFalse);
    expect(imap2.same(imap3), isTrue);
    expect(imap3.same(imap4), isFalse);
    expect(imap4.same(imap5), isFalse);
    expect(imap5.same(imap6), isTrue);
  });

  test(
      "Making sure adding repeated elements doesn't repeat keys | "
      "Empty equals", () {
    final IMap<String, int> imap = IMap.empty<String, int>().withDeepEquals;
    expect(imap, IMap.empty<String, int>().withDeepEquals);
  });

  test(
      "Making sure adding repeated elements doesn't repeat keys | "
      "IMap.add the same key overwrites it", () {
    final IMap<String, int> imap = IMap.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.add("a", 1);
    newMap = newMap.add("b", 2);
    newMap = newMap.add("a", 3);
    newMap = newMap.add("a", 4);
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});
  });

  test(
      "Making sure adding repeated elements doesn't repeat keys | "
      "IMap.addEntry the same entry overwrites it", () {
    final IMap<String, int> imap = IMap.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.addEntry(MapEntry<String, int>("a", 1));
    newMap = newMap.addEntry(MapEntry<String, int>("b", 2));
    newMap = newMap.addEntry(MapEntry<String, int>("a", 3));
    newMap = newMap.addEntry(MapEntry<String, int>("a", 4));
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});
  });

  test(
      "Making sure adding repeated elements doesn't repeat keys | "
      "IMap.add the same key overwrites it", () {
    final IMap<String, int> imap = IMap.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.addAll({"a": 1}.lock);
    newMap = newMap.addAll({"b": 2}.lock);
    newMap = newMap.addAll({"a": 3}.lock);
    newMap = newMap.addAll({"a": 4}.lock);
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});
  });

  test(
      "Making sure adding repeated elements doesn't repeat keys | "
      "IMap.add the same key overwrites it", () {
    final IMap<String, int> imap = IMap.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.addMap({"a": 1});
    newMap = newMap.addMap({"b": 2});
    newMap = newMap.addMap({"a": 3});
    newMap = newMap.addMap({"a": 4});
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});
  });

  test(
      "Making sure adding repeated elements doesn't repeat keys | "
      "IMap.add the same key overwrites it", () {
    final IMap<String, int> imap = IMap.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.addEntries([MapEntry<String, int>("a", 1)]);
    newMap = newMap.addEntries([MapEntry<String, int>("b", 2)]);
    newMap = newMap.addEntries([MapEntry<String, int>("a", 3)]);
    newMap = newMap.addEntries([MapEntry<String, int>("a", 4)]);
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Ensuring Immutability | IMap.add() | "
      "Changing the passed mutable map doesn't change the IMap", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final IMap<String, int> imap = original.lock;

    expect(imap.unlock, original);

    original.addEntries([MapEntry<String, int>("c", 3)]);
    original.addEntries([MapEntry<String, int>("d", 4)]);

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
  });

  test(
      "Ensuring Immutability | IMap.add() | "
      "Changing the IMap also doesn't change the original map", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final IMap<String, int> imap = original.lock;

    expect(imap.unlock, original);

    final IMap<String, int> iMapNew = imap.add("c", 3);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMapNew.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
  });

  test(
      "Ensuring Immutability | IMap.add() | "
      "If the item being passed is a variable, a pointer to it shouldn't exist inside the IMap",
      () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final IMap<String, int> imap = original.lock;

    expect(imap.unlock, original);

    int willChange = 4;
    final IMap<String, int> iMapNew = imap.add("c", willChange);

    willChange = 5;

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
    expect(willChange, 5);
    expect(iMapNew.unlock, <String, int>{"a": 1, "b": 2, "c": 4});
  });

  test(
      "Ensuring Immutability | IMap.addAll() | "
      "Changing the passed mutable map doesn't change the IMap", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final IMap<String, int> imap = original.lock;

    expect(imap.unlock, original);

    original.addAll(<String, int>{"c": 3, "d": 4});

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
  });

  test(
      "Ensuring Immutability | IMap.addAll() | "
      "Changing the passed immutable map doesn't change the IMap", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final IMap<String, int> imap = original.lock;

    expect(imap.unlock, original);

    final IMap<String, int> iMapNew = imap.addAll(IMap({"c": 3, "d": 4}));

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMapNew.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
  });

  test(
      "Ensuring Immutability | IMap.addAll() | "
      "If the items being passed are from a variable, "
      "it shouldn't have a pointer to the variable", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final IMap<String, int> iMap1 = original.lock;
    final IMap<String, int> iMap2 = original.lock;

    expect(iMap1.unlock, original);
    expect(iMap2.unlock, original);

    final IMap<String, int> iMapNew = iMap1.addAll(iMap2);
    original.addAll(<String, int>{"c": 3, "d": 4});

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
    expect(iMap1.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMap2.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMapNew.unlock, <String, int>{"a": 1, "b": 2});
  });

  test(
      "Ensuring Immutability | IMap.remove() | "
      "Changing the passed mutable map doesn't change the IMap", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final IMap<String, int> imap = original.lock;

    expect(imap.unlock, original);

    original.remove("a");

    expect(original, <String, int>{"b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
  });

  test(
      "Ensuring Immutability | IMap.addAll() | "
      "Removing from the original IMap doesn't change it", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final IMap<String, int> imap = original.lock;

    expect(imap.unlock, original);

    final IMap<String, int> iMapNew = imap.remove("a");

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMapNew.unlock, <String, int>{"b": 2});
  });

  // //////////////////////////////////////////////////////////////////////////////

  test("IMap.entries", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};
    imap.entries.forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("IMap.comparableEntries", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.comparableEntries.toSet(), {
      Entry("a", 1),
      Entry("b", 2),
      Entry("c", 3),
      Entry("d", 4),
      Entry("e", 5),
      Entry("f", 6),
    });
  });

  test("IMap.keys", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<String> keys = ["a", "b", "c", "d", "e", "f"];
    expect(imap.keys, keys.toSet());
  });

  test("IMap.values", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<int> values = [1, 2, 3, 4, 5, 6];
    expect(imap.values, values.toSet());
  });

  test("IMap.entryList", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};
    expect(imap.entryList(), isA<IList<MapEntry<String, int>>>());
    imap
        .entryList()
        .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("IMap.entrySet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};
    expect(imap.entrySet(), isA<ISet<MapEntry<String, int>>>());
    imap
        .entrySet()
        .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("IMap.keyList", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<String> keys = ["a", "b", "c", "d", "e", "f"];
    expect(imap.keyList(), isA<IList<String>>());
    imap.keyList().forEach((String key) => expect(keys.contains(key), isTrue));
  });

  test("IMap.keySet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<String> keys = ["a", "b", "c", "d", "e", "f"];
    expect(imap.keySet(), isA<ISet<String>>());
    imap.keySet().forEach((String key) => expect(keys.contains(key), isTrue));
  });

  test("IMap.valueList", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<int> values = [1, 2, 3, 4, 5, 6];
    expect(imap.valueList(), isA<IList<int>>());
    imap.valueList().forEach((int value) => expect(values.contains(value), isTrue));
  });

  test("IMap.valueSet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<int> values = [1, 2, 3, 4, 5, 6];
    expect(imap.valueSet(), isA<ISet<int>>());
    imap.valueSet().forEach((int value) => expect(values.contains(value), isTrue));
  });

  test("IMap.iterator", () {
    final IMap<String, int> imap = {"a": 1, "b": 2, "c": 3}
        .lock
        .add("d", 4)
        .addAll(IMap({"e": 5, "f": 6}))
        .withConfig(ConfigMap(sortKeys: false));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};

    final Iterator<MapEntry<String, int>> iterator = imap.iterator;
    final Map<String, int> result = iterator.toMap();

    expect(result, finalMap);
  });

  test("IMap.iterator | with sorted keys", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    final Iterator<MapEntry<String, int>> iterator = imap.iterator;

    expect(iterator.current, isNull);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current.asEntry, Entry<String, int>("a", 1));
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current.asEntry, Entry<String, int>("b", 2));
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current.asEntry, Entry<String, int>("c", 3));
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current.asEntry, Entry<String, int>("d", 4));
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current.asEntry, Entry<String, int>("e", 5));
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current.asEntry, Entry<String, int>("f", 6));
    expect(iterator.moveNext(), isFalse);
    expect(iterator.current, isNull);
  });

  test("IMap.fastIterator", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};

    final Iterator<MapEntry<String, int>> fastIterator = imap.fastIterator;
    final Map<String, int> result = fastIterator.toMap();

    expect(result, finalMap);
  });

  test("IMap.any()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.any((String k, int v) => v == 4), isTrue);
    expect(imap.any((String k, int v) => k == "f"), isTrue);
    expect(imap.any((String k, int v) => v == 100), isFalse);
    expect(imap.any((String k, int v) => k == "z"), isFalse);
  });

  test("IMap.anyEntry()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.anyEntry((MapEntry<String, int> entry) => entry.value == 4), isTrue);
    expect(imap.anyEntry((MapEntry<String, int> entry) => entry.key == "f"), isTrue);
    expect(imap.anyEntry((MapEntry<String, int> entry) => entry.value == 100), isFalse);
    expect(imap.anyEntry((MapEntry<String, int> entry) => entry.key == "z"), isFalse);
  });

  test("IMap.cast()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.cast<String, num>(), isA<IMap<String, num>>());
    IMap<String, num> casted = imap.cast<String, num>();
    var result = casted["a"];
    expect(result, 1);
  });

  test("IMap.cast() | Error when type can't be cast", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));

    Object error;
    try {
      IMap<String, bool> casted = imap.cast<String, bool>();
      casted["a"];
    } catch (_error) {
      error = _error;
    }
    expect(error is TypeError, isTrue);
    expect(error.toString(), "type 'int' is not a subtype of type 'bool?' in type cast");
  });

  test("IMap.[] operator", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap["a"], 1);
    expect(imap["z"], isNull);
  });

  test("IMap.get()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.get("a"), 1);
    expect(imap.get("z"), isNull);
  });

  test("IMap.contains()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.contains("a", 1), isTrue);
    expect(imap.contains("a", 2), isFalse);
    expect(imap.contains("b", 2), isTrue);
    expect(imap.contains("b", 3), isFalse);
    expect(imap.contains("c", 3), isTrue);
    expect(imap.contains("c", 4), isFalse);
    expect(imap.contains("z", 100), isFalse);
  });

  test("IMap.containsKey()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.containsKey("a"), isTrue);
    expect(imap.containsKey("z"), isFalse);
  });

  test("IMap.containsValue()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.containsValue(1), isTrue);
    expect(imap.containsValue(100), isFalse);
  });

  test("IMap.containsEntry()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.containsEntry(MapEntry<String, int>("a", 1)), isTrue);
    expect(imap.containsEntry(MapEntry<String, int>("a", 2)), isFalse);
    expect(imap.containsEntry(MapEntry<String, int>("b", 1)), isFalse);
    expect(imap.containsEntry(MapEntry<String, int>("z", 100)), isFalse);
  });

  test("IMap.containsEntry()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.containsEntry(MapEntry<String, int>("a", 1)), isTrue);
    expect(imap.containsEntry(MapEntry<String, int>("a", 2)), isFalse);
    expect(imap.containsEntry(MapEntry<String, int>("b", 1)), isFalse);
    expect(imap.containsEntry(MapEntry<String, int>("z", 100)), isFalse);
  });

  test("IMap.toList()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};
    expect(imap.toEntryList(), isA<List<MapEntry<String, int>>>());
    imap
        .toEntryList()
        .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("IMap.toISet()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};
    expect(imap.toEntrySet(), isA<Set<MapEntry<String, int>>>());
    imap
        .toEntrySet()
        .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("IMap.toKeySet()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<String> keys = ["a", "b", "c", "d", "e", "f"];
    expect(imap.toKeySet(), isA<Set<String>>());
    expect(imap.toKeySet(), keys.toSet());
  });

  test("IMap.toValueSet()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<int> values = [1, 2, 3, 4, 5, 6];
    expect(imap.toValueSet(), isA<Set<int>>());
    expect(imap.toValueSet(), values.toSet());
  });

  test("IMap.toKeyISet()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<String> keys = ["a", "b", "c", "d", "e", "f"];
    expect(imap.keySet(), isA<ISet<String>>());
    expect(imap.keySet(), keys.toSet());
  });

  test("IMap.length()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.length, 6);
  });

  test("IMap.length when with an empty IMap", () {
    final IMap<String, int> imap = IMap.empty();

    expect(imap.length, 0);
    expect(imap.isEmpty, isTrue);
  });

  test("IMap.toValueISet()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<int> values = [1, 2, 3, 4, 5, 6];
    expect(imap.valueSet(), isA<ISet<int>>());
    expect(imap.valueSet(), values.toSet());
  });

  test("IMap.forEach()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    int result = 100;
    imap.forEach((String k, int v) => result *= 1 + v);
    expect(result, 504000);
  });

  test("Simple Example", () {
    final IMap<String, int> example =
        {"a": 1, "b": 2, "c": 3}.lock.map<String, int>((String k, int v) => MapEntry(k, v + 1));

    expect(example.unlock, <String, int>{"a": 2, "b": 3, "c": 4});
  });

  test("IMap.map()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.map<String, int>((String k, int v) => MapEntry(k, v + 1)).unlock,
        {"a": 2, "b": 3, "c": 4, "d": 5, "e": 6, "f": 7});
  });

  test("IMap.where()", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.where((String k, int v) => v < 0).unlock, <String, int>{});
    expect(imap.where((String k, int v) => k == "a" || k == "b").unlock,
        <String, int>{"a": 1, "b": 2});
    expect(imap.where((String k, int v) => v < 5).unlock,
        <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
    expect(imap.where((String k, int v) => v < 100).unlock,
        <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6});
  });

  test("IMap.toString(false)", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.toString(false), "{c: 3, a: 1, b: 2, d: 4, e: 5, f: 6}");
  });

  test("IMap.toString() | ImmutableCollection.prettyPrint is Off", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));

    ImmutableCollection.prettyPrint = false;

    expect(imap.toString(), "{c: 3, a: 1, b: 2, d: 4, e: 5, f: 6}");
  });

  test("IMap.toString(true)", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(
        imap.toString(true),
        "{\n"
        "   c: 3,   \n"
        "a: 1,   \n"
        "b: 2,   \n"
        "d: 4,   \n"
        "e: 5,   \n"
        "f: 6\n"
        "}");
  });

  test("IMap.toString() | ImmutableCollection.prettyPrint is On", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    
    ImmutableCollection.prettyPrint = true;

    expect(
        imap.toString(),
        "{\n"
        "   c: 3,   \n"
        "a: 1,   \n"
        "b: 2,   \n"
        "d: 4,   \n"
        "e: 5,   \n"
        "f: 6\n"
        "}");
  });

  test("IMap.clear()", () {
    final IMap<String, int> imap =
        IMap.withConfig({"a": 1, "b": 2}, ConfigMap(isDeepEquals: false));

    final IMap<String, int> iMapCleared = imap.clear();

    // TODO: Marcelo, eu fiz com que o clear retornasse um `IMap` (estava com `void`).
    expect(iMapCleared.unlock, allOf(isA<Map<String, int>>(), {}));
    expect(iMapCleared.config.isDeepEquals, isFalse);
  });

  test("IMap.putIfAbsent()", () {
    IMap<String, int> scores = {"Bob": 36}.lock;

    Output<int> item;
    for (String key in ["Bob", "Rohan", "Sophia"]) {
      item = Output();
      // TODO: Marcelo, nomear o parametro de `value` mas com tipo `Item`, que contém um `value`
      // como propriedade me parece um tanto confuso. E o método `update` ainda possui `value`
      // como parâmetro da função de `update`.
      scores = scores.putIfAbsent(key, () => key.length, value: item);
      expect(item.value, scores[key]);
    }

    expect(scores["Bob"], 36);
    expect(scores["Rohan"], 5);
    expect(scores["Sophia"], 6);
  });

  test("IMap.update() | Updating an existing key", () {
    final IMap<String, int> scores = {"Bob": 36}.lock;

    final Output<int> item = Output();
    final IMap<String, int> updatedScores =
        scores.update("Bob", (int value) => value * 2, value: item);

    expect(scores.unlock, {"Bob": 36});
    expect(updatedScores.unlock, {"Bob": 72});
    expect(item.value, 72);
  });

  test("IMap.update() | Updating a nonexistent key", () {
    final IMap<String, int> scores = {"Bob": 36}.lock;

    final Output<int> item = Output();
    final IMap<String, int> updatedScores =
        scores.update("Joe", (int value) => value * 2, value: item, ifAbsent: () => 1);

    expect(scores.unlock, {"Bob": 36});
    expect(updatedScores.unlock, {"Bob": 36, "Joe": 1});
    expect(item.value, 1);
  });

  test(
      "IMap.update() | Return the original map if update a nonexistent key without the ifAbsent parameter",
      () {
    final IMap<String, int> scores = {"Bob": 36}.lock;

    Output<int> item = Output();
    expect(
        () => scores.update("Joe", (int value) => value * 2,
            value: item, ifAbsent: () => throw ArgumentError()),
        throwsArgumentError);

    item = Output();
    expect(scores.update("Joe", (int value) => value * 2, value: item), scores);
    expect(item.value, null);
  });

  test("IMap.update() | ifRemove", () {
    final IMap<String, int> scores = {"Bob": 36, "Joe": 10}.lock;

    final Output<int> item = Output();
    final IMap<String, int> newScores = scores.update("Joe", (int value) => 2 * value,
        ifRemove: (int value) => value == 20, value: item);
    expect(newScores.unlock, {"Bob": 36});
    expect(item.value, 20);
  });

  test("IMap.updateAll()", () {
    final IMap<String, int> scores = {"Bob": 36, "Joe": 100}.lock;
    final IMap<String, int> updatedScores = scores.updateAll((String key, int value) => value * 2);

    expect(updatedScores.unlock, {"Bob": 72, "Joe": 200});
  });

  test("IMap.flushFactor", () => expect(IMap.flushFactor, 20));

  test("IMap.flushFactor setter", () {
    IMap.flushFactor = 200;
    expect(IMap.flushFactor, 200);
  });

  test("IMap.flushFactor setter | can't be smaller than 0", () {
    expect(() => IMap.flushFactor = 0, throwsStateError);
    expect(() => IMap.flushFactor = -100, throwsStateError);
  });

  test("IMap.asyncAutoFlush", () => expect(IMap.asyncAutoflush, isTrue));

  test("IMap.lockConfig()", () {
    ImmutableCollection.lockConfig();

    expect(() => IMap.flushFactor = 1000, throwsStateError);
    expect(() => IMap.asyncAutoflush = false, throwsStateError);
  });

  test("IMap.unlockView", () {
    final Map<String, int> unmodifiableMapView = {"a": 1, "b": 2}.lock.unlockView;

    expect(unmodifiableMapView,
        allOf(isA<Map<String, int>>(), isA<UnmodifiableMapView<String, int>>(), {"a": 1, "b": 2}));
  });

  test("IMap.unlockLazy", () {
    final Map<String, int> modifiableMapView = {"a": 1, "b": 2}.lock.unlockLazy;

    expect(modifiableMapView,
        allOf(isA<Map<String, int>>(), isA<ModifiableMapView<String, int>>(), {"a": 1, "b": 2}));
  });

  // //////////////////////////////////////////////////////////////////////////////

  test("IMapOfSetsExtension.lock", () {
    const Map<String, Set<int>> map = {
      "a": {1, 2},
      "b": {1, 2, 3}
    };
    final IMapOfSets<String, int> iMapOfSets = map.lock;

    expect(iMapOfSets, isA<IMapOfSets<String, int>>());
    expect(iMapOfSets.unlock, map);
    expect(iMapOfSets["a"], {1, 2});
    expect(iMapOfSets["b"], {1, 2, 3});
  });
}

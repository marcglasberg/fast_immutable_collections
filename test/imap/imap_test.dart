// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/imap/imap.dart';
import "package:test/test.dart";

import "../utils.dart";

void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("Runtime Type", () {
    expect(IMap(), isA<IMap>());
    expect(IMap({}), isA<IMap>());
    expect(IMap<String, int>({}), isA<IMap<String, int>>());
    expect(IMap({"a": 1}), isA<IMap<String, int>>());
    expect(IMapImpl.empty<String, int>(), isA<IMap<String, int>>());
  });

  test("isEmpty | isNotEmpty", () {
    expect(IMap().isEmpty, isTrue);
    expect(IMap({}).isEmpty, isTrue);
    expect(IMap<String, int>({}).isEmpty, isTrue);
    expect(IMap({"a": 1}).isEmpty, isFalse);
    expect(IMapImpl.empty<String, int>().isEmpty, isTrue);

    expect(IMap().isNotEmpty, isFalse);
    expect(IMap({}).isNotEmpty, isFalse);
    expect(IMap<String, int>({}).isNotEmpty, isFalse);
    expect(IMap({"a": 1}).isNotEmpty, isTrue);
    expect(IMapImpl.empty<String, int>().isNotEmpty, isFalse);
  });

  test("unlock", () {
    final Map<String, int> map = {"a": 1, "b": 2};
    final IMap<String, int> imap = IMap(map);
    expect(imap.unlock, map);
    expect(identical(imap.unlock, map), isFalse);
  });

  test("unlockSorted", () {
    final IMap<String, int> imap = {"c": 3, "a": 1, "b": 2}.lock.withConfig(ConfigMap(sort: false));

    expect(imap.unlockSorted, allOf(isA<LinkedHashMap<String, int>>(), {"a": 1, "b": 2, "c": 3}));
  });

  test("unlockView", () {
    final Map<String, int> unmodifiableMapView = {"a": 1, "b": 2}.lock.unlockView;

    expect(
        unmodifiableMapView,
        allOf(isA<Map<String, int>>(), isA<UnmodifiableMapFromIMap<String, int>>(),
            {"a": 1, "b": 2}));
  });

  test("unlockLazy", () {
    final Map<String, int> modifiableMapView = {"a": 1, "b": 2}.lock.unlockLazy;

    expect(
        modifiableMapView,
        allOf(
            isA<Map<String, int>>(), isA<ModifiableMapFromIMap<String, int>>(), {"a": 1, "b": 2}));
  });

  test("fromEntries", () {
    // 1) Regular usage
    const List<MapEntry<String, int>> entries = [
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("b", 2),
    ];
    final IMap<String, int> fromEntries = IMap.fromEntries(entries);

    expect(fromEntries["a"], 1);
    expect(fromEntries["b"], 2);

    // 2) Sorting
    var imap1 = IMap.fromEntries(
      [
        MapEntry("c", 3),
        MapEntry("a", 1),
        MapEntry("b", 2),
      ],
      config: ConfigMap(sort: false),
    );

    var imap2 = IMap.fromEntries(
      [
        MapEntry("c", 3),
        MapEntry("a", 1),
        MapEntry("b", 2),
      ],
      config: ConfigMap(sort: true),
    );

    expect(imap1.keys, ["c", "a", "b"]);
    expect(imap2.keys, ["a", "b", "c"]);
  });

  test("fromKeys", () {
    // 1) Regular usage
    List<String?> keys = ["a", "b"];
    final IMap<String?, int> fromKeys =
        IMap.fromKeys(keys: keys, valueMapper: (String? key) => key.hashCode);

    expect(fromKeys["a"], "a".hashCode);
    expect(fromKeys["b"], "b".hashCode);

    // 2) Sorting
    var imap1 = IMap.fromKeys(
      keys: ["c", "b", "a"],
      valueMapper: (dynamic key) => 1,
      config: ConfigMap(sort: false),
    );

    var imap2 = IMap.fromKeys(
      keys: ["c", "b", "a"],
      valueMapper: (dynamic key) => 1,
      config: ConfigMap(sort: true),
    );

    expect(imap1.keys, ["c", "b", "a"]);
    expect(imap2.keys, ["a", "b", "c"]);
  });

  test("fromValues", () {
    // 1) Regular usage
    const List<int> values = [1, 2];
    final IMap<String, int> fromKeys =
        IMap.fromValues(values: values, keyMapper: (int value) => value.toString());

    expect(fromKeys["1"], 1);
    expect(fromKeys["2"], 2);

    // 2) Sorting
    var imap1 = IMap.fromValues(
      keyMapper: (dynamic value) {
        if (value == 1)
          return "a";
        else if (value == 2)
          return "b";
        else if (value == 3)
          return "c";
        else
          throw Exception();
      },
      values: [3, 1, 2],
      config: ConfigMap(sort: false),
    );

    var imap2 = IMap.fromValues(
      keyMapper: (dynamic value) {
        if (value == 1)
          return "a";
        else if (value == 2)
          return "b";
        else if (value == 3)
          return "c";
        else
          throw Exception();
      },
      values: [3, 1, 2],
      config: ConfigMap(sort: true),
    );

    expect(imap1.keys, ["c", "a", "b"]);
    expect(imap2.keys, ["a", "b", "c"]);
  });

  test("fromIterable", () {
    // 1) Regular usage
    const Iterable<int> iterable = [1, 2];
    IMap fromIterable = IMap.fromIterable(iterable,
        keyMapper: (int key) => (key + 1).toString(), valueMapper: (dynamic value) => value + 2);

    expect(fromIterable["2"], 3);
    expect(fromIterable["3"], 4);

    // 2) if no mappers are passed, the identity function is used
    fromIterable = IMap.fromIterable([1, 2]);

    expect(fromIterable[1], 1);
    expect(fromIterable[2], 2);

    // 3) Sorting
    var imap1 = IMap.fromIterable(
      [3, 1, 2],
      keyMapper: (dynamic value) {
        if (value == 1)
          return "a";
        else if (value == 2)
          return "b";
        else if (value == 3)
          return "c";
        else
          throw Exception();
      },
      valueMapper: (dynamic value) => value,
      config: ConfigMap(sort: false),
    );

    var imap2 = IMap.fromIterable(
      [3, 1, 2],
      keyMapper: (dynamic value) {
        if (value == 1)
          return "a";
        else if (value == 2)
          return "b";
        else if (value == 3)
          return "c";
        else
          throw Exception();
      },
      valueMapper: (dynamic value) => value,
      config: ConfigMap(sort: true),
    );

    expect(imap1.keys, ["c", "a", "b"]);
    expect(imap2.keys, ["a", "b", "c"]);
  });

  test("fromIterables", () {
    // 1) Regular usage
    Iterable<String> keys = ["a", "c", "b"];
    Iterable<int> values = [1, 5, 2];

    IMap<String, int> imap = IMap.fromIterables(keys, values, config: ConfigMap(sort: false));
    expect(imap["a"], 1);
    expect(imap["c"], 5);
    expect(imap["b"], 2);
    expect(imap.keys, ["a", "c", "b"]);

    imap = IMap.fromIterables(keys, values, config: ConfigMap(sort: true));
    expect(imap["a"], 1);
    expect(imap["c"], 5);
    expect(imap["b"], 2);
    expect(imap.keys, ["a", "b", "c"]);

    // 2) Sorting
    var imap1 = IMap.fromIterables(
      ["c", "b", "a"],
      [3, 1, 2],
      config: ConfigMap(sort: false),
    );

    var imap2 = IMap.fromIterables(
      ["c", "b", "a"],
      [3, 1, 2],
      config: ConfigMap(sort: true),
    );

    expect(imap1.keys, ["c", "b", "a"]);
    expect(imap2.keys, ["a", "b", "c"]);
  });

  test("orNull", () {
    // 1) Null -> Null
    Map<String, int>? map;
    expect(IMap.orNull(map), isNull);

    // 2) Map -> IMap
    map = {"a": 1, "b": 2, "c": 3};
    expect(IMap.orNull(map)?.unlock, {"a": 1, "b": 2, "c": 3});

    // 3) Map with Config -> IMap with Config
    IMap<String, int>? imap = IMap.orNull(map, ConfigMap(isDeepEquals: false));
    expect(imap?.unlock, {"a": 1, "b": 2, "c": 3});
    expect(imap?.config, ConfigMap(isDeepEquals: false));
  });

  test("empty", () {
    // 1) Regular usage
    var imap = IMapImpl.empty();

    expect(imap, isEmpty);
    expect(imap.unlock, {});
    expect(imap.config, ConfigMap());

    // 2) With another config
    imap = IMapImpl.empty(ConfigMap(sort: true));

    expect(imap.config, ConfigMap(sort: true));
  });

  test("unsafe", () {
    // 1) Normal usage
    Map<String, int> map = {"a": 1, "b": 2};
    final IMap<String, int> imap = IMap.unsafe(map, config: ConfigMap());

    expect(map, {"a": 1, "b": 2});
    expect(imap.unlock, {"a": 1, "b": 2});

    map.addAll({"c": 3});

    expect(map, {"a": 1, "b": 2, "c": 3});
    expect(imap.unlock, {"a": 1, "b": 2, "c": 3});

    // 2) Disallowing it
    ImmutableCollection.disallowUnsafeConstructors = true;
    map = {"a": 1, "b": 2};

    expect(() => IMap.unsafe(map, config: ConfigMap()), throwsUnsupportedError);
  });

  test("isIdentityEquals and IMap.isDeepEquals properties", () {
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2}),
        iMap2 = IMap({"a": 1, "b": 2}).withIdentityEquals;

    expect(iMap1.isIdentityEquals, isFalse);
    expect(iMap1.isDeepEquals, isTrue);
    expect(iMap2.isIdentityEquals, isTrue);
    expect(iMap2.isDeepEquals, isFalse);
  });

  test("==", () {
    // 1) IMap with identity-equals compares the map instance, not the items
    var myMap = IMap({"a": 1, "b": 2}).withIdentityEquals;
    expect(myMap == myMap, isTrue);
    expect(myMap == IMap({"a": 1, "b": 2}).withIdentityEquals, isFalse);
    expect(myMap == {"a": 1, "b": 2}.lock.withIdentityEquals, isFalse);
    expect(myMap == IMap({"a": 1, "b": 2, "c": 3}).withIdentityEquals, isFalse);

    // 2) IMap with deep-equals compares the items, not the map instance
    myMap = IMap({"a": 1, "b": 2}).withDeepEquals;
    expect(myMap == myMap, isTrue);
    expect(myMap == IMap({"b": 2}).add("a", 1).withDeepEquals, isTrue);
    expect(myMap == IMap({"a": 1, "b": 2}).withDeepEquals, isTrue);
    expect(myMap == {"a": 1, "b": 2}.lock.withDeepEquals, isTrue);
    expect(myMap == IMap({"a": 1, "b": 2, "c": 3}).withDeepEquals, isFalse);

    myMap = IMap({"a": 1, "b": 2});
    expect(myMap == myMap, isTrue);
    expect(myMap == IMap({"a": 1, "b": 2}), isTrue);
    expect(myMap == IMap({"a": 1, "b": 2, "c": 3}), isFalse);

    // 3) IMap with deep-equals is always different from imap with identity-equals
    expect(IMap({"a": 1, "b": 2}).withDeepEquals == IMap({"a": 1, "b": 2}).withIdentityEquals,
        isFalse);
    expect(IMap({"a": 1, "b": 2}).withIdentityEquals == IMap({"a": 1, "b": 2}).withDeepEquals,
        isFalse);
    expect(IMap({"a": 1, "b": 2}).withIdentityEquals == IMap({"a": 1, "b": 2}), isFalse);
    expect(IMap({"a": 1, "b": 2}) == IMap({"a": 1, "b": 2}).withIdentityEquals, isFalse);
  });

  test("same", () {
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2});
    expect(iMap1.same(iMap1), isTrue);
    expect(iMap1.same(IMap({"a": 1, "b": 2})), isFalse);
    expect(iMap1.same(IMap({"a": 1})), isFalse);
    expect(iMap1.same(IMap({"b": 2}).add("a", 1)), isFalse);
    expect(iMap1.same(IMap({"a": 1, "b": 2}).withIdentityEquals), isFalse);
    expect(iMap1.same(iMap1.remove("c")), isTrue);
  });

  test("equalItemsAndConfig", () {
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2});
    expect(iMap1.equalItemsAndConfig(iMap1), isTrue);
    expect(iMap1.equalItemsAndConfig(IMap({"a": 1, "b": 2})), isTrue);
    expect(iMap1.equalItemsAndConfig(IMap({"a": 1})), isFalse);
    expect(iMap1.equalItemsAndConfig(IMap({"b": 2}).add("a", 1)), isTrue);
    expect(iMap1.equalItemsAndConfig(IMap({"a": 1, "b": 2}).withIdentityEquals), isFalse);
    expect(iMap1.equalItemsAndConfig(iMap1.remove("c")), isTrue);
  });

  test("equalItems", () {
    // 1) Identity
    final Iterable<MapEntry<String, int>> iterable1 = [
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("b", 2),
    ];
    expect(IMap({"a": 1, "b": 2}).equalItems(iterable1), isTrue);

    // 2) The order doesn't matter
    final Iterable<MapEntry<String, int>> iterable4 = [
      MapEntry<String, int>("b", 2),
      MapEntry<String, int>("a", 1),
    ];
    expect(IMap({"a": 1, "b": 2}).equalItems(iterable4), isTrue);

    // 3) Different items yield false
    final Iterable<MapEntry<String, int>> iterable3 = [
      MapEntry<String, int>("a", 1),
    ];
    expect(IMap({"a": 1, "b": 2}).equalItems(iterable3), isFalse);
  });

  test("equalItemsToMap", () {
    final IMap<String, int> imap = IMap({"a": 1, "b": 2});
    expect(imap.equalItemsToMap({"a": 1, "b": 2}), isTrue);
    expect(imap.equalItemsToMap({"a": 1, "b": 3}), isFalse);
    expect(imap.equalItemsToMap({"a": 1, "c": 2}), isFalse);
    expect(imap.equalItemsToMap({"a": 1, "b": 2, "c": 3}), isFalse);
  });

  test("hashCode", () {
    // 1) deepEquals vs deepEquals
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2});
    expect(iMap1 == IMap({"a": 1, "b": 2}), isTrue);
    expect(iMap1 == IMap({"a": 1, "b": 2, "c": 3}), isFalse);
    expect(iMap1 == IMap({"b": 2}).add("a", 1), isTrue);
    expect(iMap1.hashCode, IMap({"a": 1, "b": 2}).hashCode);
    expect(iMap1.hashCode, isNot(IMap({"a": 1, "b": 2, "c": 3}).hashCode));
    expect(iMap1.hashCode, IMap({"b": 2}).add("a", 1).hashCode);

    // 2) identityEquals vs identityEquals
    final IMap<String, int> iMap1WithIdentity = IMap({"a": 1, "b": 2}).withIdentityEquals;
    expect(iMap1WithIdentity == IMap({"a": 1, "b": 2}).withIdentityEquals, isFalse);
    expect(iMap1WithIdentity == IMap({"a": 1, "b": 2, "c": 3}).withIdentityEquals, isFalse);
    expect(iMap1WithIdentity == IMap({"b": 2}).add("a", 1).withIdentityEquals, isFalse);
    expect(iMap1WithIdentity.hashCode, isNot(IMap({"a": 1, "b": 2}).withIdentityEquals.hashCode));
    expect(iMap1WithIdentity.hashCode,
        isNot(IMap({"a": 1, "b": 2, "c": 3}).withIdentityEquals.hashCode));
    expect(
        iMap1WithIdentity.hashCode, isNot(IMap({"b": 2}).add("a", 1).withIdentityEquals.hashCode));

    // 3) deepEquals vs identityEquals
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

    // 4) When cache is on
    ImmutableCollection.disallowUnsafeConstructors = false;

    Map<String, int> map = {"a": 1, "b": 2};

    final IMap<String, int> iMapWithCache =
        IMap.unsafe(map, config: ConfigMap(cacheHashCode: true));

    int hashBefore = iMapWithCache.hashCode;

    map.addAll({"c": 3});

    int hashAfter = iMapWithCache.hashCode;

    expect(hashAfter, hashBefore);

    // 5) When cache is off
    ImmutableCollection.disallowUnsafeConstructors = false;

    map = {"a": 1, "b": 2};

    final IMap<String, int> iMapWithoutCache =
        IMap.unsafe(map, config: ConfigMap(cacheHashCode: false));

    hashBefore = iMapWithoutCache.hashCode;

    map.addAll({"c": 3});

    hashAfter = iMapWithoutCache.hashCode;

    expect(hashAfter, isNot(hashBefore));
  });

  test("withConfig", () {
    // 1) Regular usage
    final IMap<String, int> imap = IMap({"a": 1, "b": 2});

    expect(imap.isDeepEquals, isTrue);
    expect(imap.config.sort, isFalse);

    final IMap<String, int> iMapWithCompare = imap.withConfig(imap.config.copyWith(
      sort: true,
    ));

    expect(iMapWithCompare.isDeepEquals, isTrue);
    expect(iMapWithCompare.config.sort, isTrue);

    // 2) Sorting
    IMap<String, int> imap1 = IMap({"c": 3, "a": 1, "b": 2}).withConfig(ConfigMap(sort: false));
    IMap<String, int> imap2 = IMap({"c": 3, "a": 1, "b": 2}).withConfig(ConfigMap(sort: true));

    expect(imap1.keys, ["c", "a", "b"]);
    expect(imap2.keys, ["a", "b", "c"]);
  });

  test("withConfig factory", () {
    // 1) Regular usage
    IMap<String, int> imap = IMap.withConfig({"a": 1, "b": 2}, ConfigMap(isDeepEquals: false));
    expect(imap.unlock, {"a": 1, "b": 2});
    expect(imap.config, const ConfigMap(isDeepEquals: false));

    // 2) Sorting
    Map<String, int> map = {"c": 3, "a": 1, "b": 2};
    IMap<String, int> imap1 = IMap.withConfig(map, ConfigMap(sort: false));
    IMap<String, int> imap2 = IMap.withConfig(map, ConfigMap(sort: true));

    expect(imap1.keys, ["c", "a", "b"]);
    expect(imap2.keys, ["a", "b", "c"]);
  });

  test("Changing configs", () {
    var imap1 = IMap.withConfig({"a": 1, "c": 3, "b": 2}, ConfigMap(sort: true))
        .withConfig(ConfigMap(sort: true));
    expect(imap1.keys, ["a", "b", "c"]);
    expect(imap1.values, [1, 2, 3]);

    var imap2 = IMap.withConfig({"a": 1, "c": 3, "b": 2}, ConfigMap(sort: true))
        .withConfig(ConfigMap(sort: false));
    expect(imap2.keys, ["a", "b", "c"]);
    expect(imap2.values, [1, 2, 3]);

    var imap3 = IMap.withConfig({"a": 1, "c": 3, "b": 2}, ConfigMap(sort: false))
        .withConfig(ConfigMap(sort: true));
    expect(imap3.keys, ["a", "b", "c"]);
    expect(imap3.values, [1, 2, 3]);

    var imap4 = IMap.withConfig({"a": 1, "c": 3, "b": 2}, ConfigMap(sort: false))
        .withConfig(ConfigMap(sort: false));
    expect(imap4.keys, ["a", "c", "b"]);
    expect(imap4.values, [1, 3, 2]);
  });

  test("withConfigFrom", () {
    final IMap<String, int> iMap1 = IMap({"a": 1, "b": 2});
    final IMap<String, int> iMap2 =
        IMap.withConfig({"a": 1, "b": 2}, ConfigMap(isDeepEquals: false));

    expect(iMap1.isDeepEquals, isTrue);
    expect(iMap1.config.sort, isFalse);

    expect(iMap2.isDeepEquals, isFalse);
    expect(iMap2.config.sort, isFalse);

    final IMap<String, int> iMap3 = iMap1.withConfigFrom(iMap2);

    expect(iMap3.isDeepEquals, isFalse);
    expect(iMap3.config.sort, isFalse);

    expect(iMap1.unlock, {"a": 1, "b": 2});
    expect(iMap2.unlock, {"a": 1, "b": 2});
    expect(iMap3.unlock, {"a": 1, "b": 2});

    // 3) Sorting
    IMap<String, int> originalIMap = {"c": 3, "a": 1, "b": 2}.lock;
    IMap<String, int> originalIMapWithSort =
        {"c": 3, "a": 1, "b": 2}.lock.withConfig(ConfigMap(sort: true));
    IMap<String, int> imapWithSortFromConfig = originalIMap.withConfigFrom(originalIMapWithSort);

    expect(originalIMap.keys, ["c", "a", "b"]);
    expect(originalIMapWithSort.keys, ["a", "b", "c"]);
    expect(imapWithSortFromConfig.keys, ["a", "b", "c"]);
  });

  test("default constructor", () {
    final Map<String, int> map = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> imap = IMap(map);

    expect(imap.unlock, map);
    expect(identical(imap.unlock, map), isFalse);
  });

  test("flush", () {
    final IMap<String, int> imap = {"a": 1, "b": 2, "c": 3}
        .lock
        .add("d", 4)
        .addMap({"f": 6, "e": 5})
        .add("g", 7)
        .addMap({})
        .addAll(IMap({"h": 8, "i": 9}));

    expect(imap.isFlushed, isFalse);

    imap.flush;

    expect(imap.isFlushed, isTrue);
    expect(imap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8, "i": 9});
  });

  test("add", () {
    // 1) Regular usage
    IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.add("c", 3);

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3});

    // 2) Adding the same item overwrites it
    imap = IMapImpl.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.add("a", 1);
    newMap = newMap.add("b", 2);
    newMap = newMap.add("a", 3);
    newMap = newMap.add("a", 4);
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});

    // 3) Null checks

    // 3.1) Regular usage
    expect(<String, int>{}.lock.add("a", 1).unlock, {"a": 1});
    expect(<String, int?>{"a": null}.lock.add("b", 1).unlock, {"a": null, "b": 1});
    expect(<String, int>{"a": 1}.lock.add("b", 10).unlock, {"a": 1, "b": 10});
    expect(<String, int?>{"a": null, "b": null, "c": null}.lock.add("z", 10).unlock,
        {"a": null, "b": null, "c": null, "z": 10});
    expect(<String, int?>{"a": null, "b": 1, "c": null, "d": 3}.lock.add("z", 10).unlock,
        {"a": null, "b": 1, "c": null, "d": 3, "z": 10});
    expect({"a": 1, "b": 2, "c": 3}.lock.add("d", 4).unlock, {"a": 1, "b": 2, "c": 3, "d": 4});

    // 3.2) Adding null
    expect(<String, int?>{"a": null}.lock.add("b", null).unlock, {"a": null, "b": null});
    expect(<String, int?>{"a": null, "b": null, "c": null}.lock.add("d", null).unlock,
        {"a": null, "b": null, "c": null, "d": null});
    expect(<String, int?>{"a": null, "b": 1, "c": null, "d": 3}.lock.add("z", null).unlock,
        {"a": null, "b": 1, "c": null, "d": 3, "z": null});
  });

  test("addEntry", () {
    // 1) Regular usage
    IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.addEntry(MapEntry<String, int>("c", 3));

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3});

    // 2) addEntry to the same entry overwrites it
    imap = IMapImpl.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.addEntry(MapEntry<String, int>("a", 1));
    newMap = newMap.addEntry(MapEntry<String, int>("b", 2));
    newMap = newMap.addEntry(MapEntry<String, int>("a", 3));
    newMap = newMap.addEntry(MapEntry<String, int>("a", 4));
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});

    // 3) Guaranteeing non-repeated additions to the IMap
    imap = {"a": 1, "z": 100}.lock.addEntry(MapEntry("a", 40));

    expect(imap.keys, ["a", "z"]);
    expect(imap.values, [40, 100]);
  });

  test("addAll | set with insertion order", () {
    // 1) Regular usage
    IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.addAll({"c": 3, "d": 4}.lock);

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});

    // 2) addAll to the same keys overwrites them.
    imap = IMapImpl.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.addAll({"a": 1}.lock);
    newMap = newMap.addAll({"b": 2}.lock);
    newMap = newMap.addAll({"a": 3}.lock);
    newMap = newMap.addAll({"a": 4}.lock);
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});

    // 3) Null checks

    // 3.1) Regular usage
    expect(<String, int>{}.lock.addAll({"a": 1, "b": 2}.lock).unlock, {"a": 1, "b": 2});
    expect(<String, int?>{"a": null}.lock.addAll({"b": 1, "c": 2}.lock).unlock,
        {"a": null, "b": 1, "c": 2});
    expect(
        <String, int>{"a": 1}.lock.addAll({"b": 2, "c": 3}.lock).unlock, {"a": 1, "b": 2, "c": 3});
    expect(
        <String, int?>{"a": null, "b": null, "c": null}.lock.addAll({"d": 1, "e": 2}.lock).unlock,
        {"a": null, "b": null, "c": null, "d": 1, "e": 2});
    expect(
        <String, int?>{"a": null, "b": 1, "c": null, "d": 3}
            .lock
            .addAll({"e": 10, "f": 11}.lock)
            .unlock,
        {"a": null, "b": 1, "c": null, "d": 3, "e": 10, "f": 11});
    expect({"a": 1, "b": 2, "c": 3, "d": 4}.lock.addAll({"e": 5, "f": 6}.lock).unlock,
        {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6});

    // 3.2) Adding nulls
    expect(<String, int?>{"a": null}.lock.addAll({"b": null, "c": null}.lock).unlock,
        {"a": null, "b": null, "c": null});
    expect(
        <String, int?>{"a": null, "b": null, "c": null}
            .lock
            .addAll({"d": null, "e": null}.lock)
            .unlock,
        {"a": null, "b": null, "c": null, "d": null, "e": null});
    expect(
        <String, int?>{"a": null, "b": 1, "c": null, "d": 3}
            .lock
            .addAll({"e": null, "f": null}.lock)
            .unlock,
        {"a": null, "b": 1, "c": null, "d": 3, "e": null, "f": null});

    // 3.3) Adding null and an item
    expect(<String, int?>{"a": null}.lock.addAll({"b": null, "c": 1}.lock).unlock,
        {"a": null, "b": null, "c": 1});
    expect(
        <String, int?>{"a": null, "b": null, "c": null}
            .lock
            .addAll({"d": null, "e": 1}.lock)
            .unlock,
        {"a": null, "b": null, "c": null, "d": null, "e": 1});
    expect(
        <String, int?>{"a": null, "b": 1, "c": null, "d": 3}
            .lock
            .addAll({"e": null, "f": 1}.lock)
            .unlock,
        {"a": null, "b": 1, "c": null, "d": 3, "e": null, "f": 1});

    // 4) Guaranteeing non-repeated additions to the IMap
    imap = {"a": 1, "z": 100}.lock.addAll({"a": 40}.lock, keepOrder: true);
    expect(imap.keys, ["a", "z"]);
    expect(imap.values, [40, 100]);

    imap = {"a": 1, "z": 100}.lock.addAll({"a": 40}.lock, keepOrder: false);
    expect(imap.keys, ["z", "a"]);
    expect(imap.values, [100, 40]);

    // 5) keepOrder = false
    imap = <String, int>{}
        .lock
        .addAll({"z": 100, "a": 1}.lock)
        .addAll({"z": 40, "c": 3}.lock, keepOrder: false);
    expect(imap.keys, ["a", "z", "c"]);
    expect(imap.values, [1, 40, 3]);

    // keepOrder = true
    imap = <String, int>{}
        .lock
        .addAll({"z": 100, "a": 1}.lock)
        .addAll({"z": 40, "c": 3}.lock, keepOrder: true);
    expect(imap.keys, ["z", "a", "c"]);
    expect(imap.values, [40, 1, 3]);
  });

  test("addMap", () {
    // 1) Regular usage
    IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.addMap({"c": 3, "d": 4});

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});

    // 2) addMap to the keys overwrites them
    imap = IMapImpl.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.addMap({"a": 1});
    newMap = newMap.addMap({"b": 2});
    newMap = newMap.addMap({"a": 3});
    newMap = newMap.addMap({"a": 4});
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});

    // 3) Guaranteeing non-repeated additions to the IMap
    imap = {"a": 1, "z": 100}.lock.addMap({"a": 40});

    expect(imap.keys, ["a", "z"]);
    expect(imap.values, [40, 100]);
  });

  test("addEntries", () {
    // 1) Regular usage
    IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap =
        imap.addEntries([MapEntry<String, int>("c", 3), MapEntry<String, int>("d", 4)]);

    expect(newIMap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});

    // 2) addEntries to the keys overwrites them
    imap = IMapImpl.empty<String, int>().withDeepEquals;
    IMap<String, int> newMap = imap.addEntries([MapEntry<String, int>("a", 1)]);
    newMap = newMap.addEntries([MapEntry<String, int>("b", 2)]);
    newMap = newMap.addEntries([MapEntry<String, int>("a", 3)]);
    newMap = newMap.addEntries([MapEntry<String, int>("a", 4)]);
    expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
    expect(newMap.unlock, {"a": 4, "b": 2});

    // 3) Guaranteeing non-repeated additions to the IMap
    imap = {"a": 1, "z": 100}.lock.addEntries([MapEntry("a", 40)]);

    expect(imap.keys, ["a", "z"]);
    expect(imap.values, [40, 100]);
  });

  test("add | sorted set", () {
    IMap<String, int> imap = <String, int>{}
        .lock
        .withConfig(const ConfigMap(sort: true))
        .add("z", 100)
        .add("a", 1)
        .add("a", 40)
        .add("c", 3);
    expect(imap.keys, ["a", "c", "z"]);
    expect(imap.values, [40, 3, 100]);
  });

  test("addEntry | sorted set", () {
    IMap<String, int> imap = <String, int>{}
        .lock
        .withConfig(const ConfigMap(sort: true))
        .addEntry(MapEntry("z", 100))
        .addEntry(MapEntry("a", 1))
        .addEntry(MapEntry("a", 40))
        .addEntry(MapEntry("c", 3));
    expect(imap.keys, ["a", "c", "z"]);
    expect(imap.values, [40, 3, 100]);
  });

  test("addAll | sorted set", () {
    IMap<String, int> imap = <String, int>{}
        .lock
        .withConfig(const ConfigMap(sort: true))
        .addAll({"z": 100, "a": 1}.lock)
        .addAll({"a": 40, "c": 3}.lock);
    expect(imap.keys, ["a", "c", "z"]);
    expect(imap.values, [40, 3, 100]);
  });

  test("addMap | sorted set", () {
    IMap<String, int> imap = <String, int>{}
        .lock
        .withConfig(const ConfigMap(sort: true))
        .addMap({"z": 100, "a": 1}).addMap({"a": 40, "c": 3});
    expect(imap.keys, ["a", "c", "z"]);
    expect(imap.values, [40, 3, 100]);
  });

  test("addEntries | sorted set", () {
    IMap<String, int> imap =
        <String, int>{}.lock.withConfig(const ConfigMap(sort: true)).addEntries([
      MapEntry("z", 100),
      MapEntry("a", 1),
    ]).addEntries([
      MapEntry("a", 40),
      MapEntry("c", 3),
    ]);
    expect(imap.keys, ["a", "c", "z"]);
    expect(imap.values, [40, 3, 100]);
  });

  test(
      "Guarantees sorting after adding entries, if sort == true | "
      "and also guarantees that repeated keys get updated with all the last key insertion", () {
    IMap<String, int> imap = <String, int>{}
        .lock
        .withConfig(const ConfigMap(sort: true))
        .add("k", 20)
        .addEntry(MapEntry("y", 1000))
        .addAll({"a": 40, "c": 3, "f": 10}.lock)
        .addMap({"g": 200}).addEntries([MapEntry("z", 100), MapEntry("a", 1)]);

    expect(imap.config, const ConfigMap(sort: true));
    expect(imap.keys, ["a", "c", "f", "g", "k", "y", "z"]);
    expect(imap.values, [1, 3, 10, 200, 20, 1000, 100]);
  });

  test("remove", () {
    // 1) Simple
    final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.remove("b");

    expect(newIMap.unlock, {"a": 1});

    // 2) Multiple times
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

    // 3) Poking around with nulls
    expect(<String, int>{}.lock.remove("a").unlock, <String, int>{});

    expect(<String, int?>{"a": null}.lock.remove("b").unlock, <String, int?>{"a": null});

    expect(<String, int>{"a": 1}.lock.remove("a").unlock, <String, int>{});

    expect(<String, int?>{"a": null, "b": null, "c": null}.lock.remove("a").unlock,
        <String, int?>{"b": null, "c": null});
    expect(<String, int?>{"a": null, "b": null, "c": null}.lock.remove("z").unlock,
        <String, int?>{"a": null, "b": null, "c": null});

    expect(<String, int?>{"a": null, "b": 1, "c": null, "d": 1}.lock.remove("a").unlock,
        <String, int?>{"b": 1, "c": null, "d": 1});
    expect(<String, int?>{"a": null, "b": 1, "c": null, "d": 1}.lock.remove("b").unlock,
        <String, int?>{"a": null, "c": null, "d": 1});
  });

  test("removeWhere", () {
    final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    final IMap<String, int> newIMap = imap.removeWhere((String key, int? value) => key == "b");

    expect(newIMap.unlock, {"a": 1});
  });

  test("Chaining add and addAll", () {
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

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable map doesn't change the IMap
    Map<String, int> original = {"a": 1, "b": 2};
    IMap<String, int> imap = original.lock;

    expect(imap.unlock, original);

    original.addEntries([MapEntry<String, int>("c", 3)]);
    original.addEntries([MapEntry<String, int>("d", 4)]);

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});

    // 1.2) Changing the IMap also doesn't change the original map
    original = {"a": 1, "b": 2};
    imap = original.lock;

    expect(imap.unlock, original);

    IMap<String, int> iMapNew = imap.add("c", 3);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMapNew.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside the IMap
    original = {"a": 1, "b": 2};
    imap = original.lock;

    expect(imap.unlock, original);

    int willChange = 4;
    iMapNew = imap.add("c", willChange);

    willChange = 5;

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
    expect(willChange, 5);
    expect(iMapNew.unlock, <String, int>{"a": 1, "b": 2, "c": 4});

    // 2) addAll

    // 2.1) Changing the passed mutable map doesn't change the IMap
    original = {"a": 1, "b": 2};
    imap = original.lock;

    expect(imap.unlock, original);

    original.addAll(<String, int>{"c": 3, "d": 4});

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});

    // 2.2) Changing the passed immutable map doesn't change the IMap
    original = {"a": 1, "b": 2};
    imap = original.lock;

    expect(imap.unlock, original);

    iMapNew = imap.addAll(IMap({"c": 3, "d": 4}));

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMapNew.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});

    // 2.3) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = {"a": 1, "b": 2};
    final IMap<String, int> iMap1 = original.lock;
    final IMap<String, int> iMap2 = original.lock;

    expect(iMap1.unlock, original);
    expect(iMap2.unlock, original);

    iMapNew = iMap1.addAll(iMap2);
    original.addAll(<String, int>{"c": 3, "d": 4});

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
    expect(iMap1.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMap2.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMapNew.unlock, <String, int>{"a": 1, "b": 2});

    // 3) remove

    // 3.1) Changing the passed mutable map doesn't change the IMap
    original = {"a": 1, "b": 2};
    imap = original.lock;

    expect(imap.unlock, original);

    original.remove("a");

    expect(original, <String, int>{"b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});

    // 3.2) Removing from the original IMap doesn't change it
    original = {"a": 1, "b": 2};
    imap = original.lock;

    expect(imap.unlock, original);

    iMapNew = imap.remove("a");

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(imap.unlock, <String, int>{"a": 1, "b": 2});
    expect(iMapNew.unlock, <String, int>{"b": 2});
  });

  test("entries", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};
    imap.entries
        .forEach((MapEntry<String, int?> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("entry", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));

    expect(imap.entry("a").key, "a");
    expect(imap.entry("a").value, 1);

    expect(imap.entry("z").key, "z");
    expect(imap.entry("z").value, null);
  });

  test("entryOrNull", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));

    expect(imap.entryOrNull("a")?.key, "a");
    expect(imap.entryOrNull("a")?.value, 1);

    expect(imap.entryOrNull("z"), isNull);
  });

  test("comparableEntries", () {
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

  test("keys", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    const List<String> keys = ["a", "b", "c", "d", "e", "f"];
    expect(imap.keys, keys.toSet());
    expect(imap.keys, ["a", "b", "c", "d", "f", "e"]);

    // Keys is not sorted! If you need sorted, use keyList.
    expect(imap.withConfig(ConfigMap(sort: true)).keys, ["a", "b", "c", "d", "e", "f"]);
    expect(imap.withConfig(ConfigMap(sort: true)).toKeyIList(), ["a", "b", "c", "d", "e", "f"]);
  });

  test("values", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    const List<int> values = [1, 2, 3, 4, 5, 6];
    expect(imap.values, values.toSet());
    expect(imap.values, [1, 2, 3, 4, 6, 5]);
  });

  test("entryList", () {
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};

    // 1) Simple usage
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.toEntryIList(), isA<IList<MapEntry<String, int>>>());
    imap
        .toEntryIList()
        .forEach((MapEntry<String, int?>? entry) => expect(finalMap[entry!.key], entry.value));

    // 2.1) Sorting with compare
    final IMap<String, int> imap2 =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    final IList<MapEntry<String, int>> correctEntries = [
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("b", 2),
      MapEntry<String, int>("c", 3),
      MapEntry<String, int>("d", 4),
      MapEntry<String, int>("e", 5),
      MapEntry<String, int>("f", 6)
    ].lock;
    final orderedEntries = imap2.withConfig(ConfigMap(sort: false)).toEntryIList(
        compare: (MapEntry<String, int?>? a, MapEntry<String, int?>? b) =>
            a!.key.compareTo(b!.key));

    for (int i = 0; i < orderedEntries.length; i++) {
      expect(orderedEntries[i].key, correctEntries[i].key);
      expect(orderedEntries[i].value, correctEntries[i].value);
    }

    // 2.2) Sorting with sortKeys
    final orderedEntriesFromConfig = imap2.withConfig(ConfigMap(sort: true)).toEntryIList();

    for (int i = 0; i < orderedEntries.length; i++) {
      expect(orderedEntriesFromConfig[i].key, correctEntries[i].key);
      expect(orderedEntriesFromConfig[i].value, correctEntries[i].value);
    }
  });

  test("keyList", () {
    final IMap<String, int> imap =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    expect(imap.toKeyIList(), allOf(isA<IList<String>>(), ["a", "c", "b", "d", "f", "e"]));

    expect(
        imap
            .withConfig(ConfigMap(sort: false))
            .toKeyIList(compare: (String? a, String? b) => a!.compareTo(b!)),
        ["a", "b", "c", "d", "e", "f"]);
    expect(imap.withConfig(ConfigMap(sort: true)).toKeyIList(), ["a", "b", "c", "d", "e", "f"]);
  });

  test("valueList", () {
    final IMap<String, int> imap =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    expect(imap.toValueIList(), allOf(isA<IList<int>>(), [1, 3, 2, 4, 6, 5]));

    expect(() => imap.toValueIList(sort: false, compare: (int? a, int? b) => a!.compareTo(b!)),
        throwsAssertionError);

    expect(imap.toValueIList(sort: true, compare: (int? a, int? b) => a!.compareTo(b!)),
        [1, 2, 3, 4, 5, 6]);

    expect(imap.toValueIList(sort: true), [1, 2, 3, 4, 5, 6]);
  });

  test("entrySet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};
    expect(imap.toEntryISet(), isA<ISet<MapEntry<String, int>>>());
    imap
        .toEntryISet()
        .forEach((MapEntry<String, int?>? entry) => expect(finalMap[entry!.key], entry.value));
  });

  test("keySet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<String> keys = ["a", "b", "c", "d", "e", "f"];
    expect(imap.toKeyISet(), isA<ISet<String>>());
    imap.toKeyISet().forEach((String? key) => expect(keys.contains(key), isTrue));
  });

  test("valueSet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<int> values = [1, 2, 3, 4, 5, 6];
    expect(imap.toValueISet(), allOf(isA<ISet<int>>(), {1, 2, 3, 4, 5, 6}));
    imap.toValueISet().forEach((int? value) => expect(values.contains(value), isTrue));
  });

  test("toEntryList", () {
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};

    // 1) Simple usage
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.toEntryList(), isA<List<MapEntry<String, int>>>());
    imap
        .toEntryList()
        .forEach((MapEntry<String, int?> entry) => expect(finalMap[entry.key], entry.value));

    // 2.1) Sorting with compare
    final IMap<String, int> imap2 =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    final List<MapEntry<String, int>> correctEntries = [
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("b", 2),
      MapEntry<String, int>("c", 3),
      MapEntry<String, int>("d", 4),
      MapEntry<String, int>("e", 5),
      MapEntry<String, int>("f", 6)
    ];
    final orderedEntries = imap2.withConfig(ConfigMap(sort: false)).toEntryList(
        compare: (MapEntry<String, int?> a, MapEntry<String, int?> b) => a.key.compareTo(b.key));

    for (int i = 0; i < orderedEntries.length; i++) {
      expect(orderedEntries[i].key, correctEntries[i].key);
      expect(orderedEntries[i].value, correctEntries[i].value);
    }

    // 2.2) Sorting with sortKeys
    final orderedEntriesFromConfig = imap2.withConfig(ConfigMap(sort: true)).toEntryList();

    for (int i = 0; i < orderedEntries.length; i++) {
      expect(orderedEntriesFromConfig[i].key, correctEntries[i].key);
      expect(orderedEntriesFromConfig[i].value, correctEntries[i].value);
    }
  });

  test("toKeyList", () {
    final IMap<String, int> imap =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    expect(imap.toKeyList(), allOf(isA<List<String>>(), ["a", "c", "b", "d", "f", "e"]));

    expect(
        imap
            .withConfig(ConfigMap(sort: false))
            .toKeyList(compare: (String a, String b) => a.compareTo(b)),
        ["a", "b", "c", "d", "e", "f"]);
    expect(imap.withConfig(ConfigMap(sort: true)).toKeyList(), ["a", "b", "c", "d", "e", "f"]);
  });

  test("toValueList", () {
    final IMap<String, int> imap =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    expect(imap.toValueList(), allOf(isA<List<int>>(), [1, 3, 2, 4, 6, 5]));

    expect(() => imap.toValueList(compare: (int? a, int? b) => a!.compareTo(b!), sort: false),
        throwsAssertionError);

    expect(imap.toValueList(compare: (int? a, int? b) => a!.compareTo(b!), sort: true),
        [1, 2, 3, 4, 5, 6]);

    expect(imap.toValueList(sort: true), [1, 2, 3, 4, 5, 6]);
  });

  test("toEntrySet", () {
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};

    // 1) Simple usage
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.toEntrySet(), isA<Set<MapEntry<String, int>>>());
    imap
        .toEntrySet()
        .forEach((MapEntry<String, int?> entry) => expect(finalMap[entry.key], entry.value));

    // 2) When compare = null
    expect(imap.toEntrySet(compare: null), isA<Set<MapEntry<String, int>>>());
    imap
        .toEntrySet(compare: null)
        .forEach((MapEntry<String, int?> entry) => expect(imap[entry.key], entry.value));
  });

  test("toKeySet", () {
    final IMap<String, int> imap =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    expect(imap.toKeySet(), allOf(isA<Set<String>>(), {"a", "c", "b", "d", "f", "e"}));
    expect(imap.toKeySet(compare: null), allOf(isA<Set<String>>(), {"a", "c", "b", "d", "f", "e"}));
  });

  test("toValueSet", () {
    final IMap<String, int> imap =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    expect(imap.toValueSet(), allOf(isA<Set<int>>(), {1, 3, 2, 4, 6, 5}));
    expect(imap.toValueSet(compare: null), allOf(isA<Set<int>>(), {1, 3, 2, 4, 6, 5}));
  });

  test("iterator", () {
    // 1) Regular usage
    final IMap<String, int> imap1 = {"a": 1, "b": 2, "d": 4}
        .lock
        .add("c", 3)
        .addAll(IMap({"e": 5, "f": 6}))
        .withConfig(ConfigMap(sort: false));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "d": 4, "c": 3, "e": 5, "f": 6};

    Iterator<MapEntry<String, int>> iter1 = imap1.iterator;
    final Map<String, int> result = iter1.toMap();

    expect(result, finalMap);

    iter1 = imap1.iterator;

    // Throws StateError before first moveNext().
    expect(() => iter1.current, throwsStateError);

    expect(iter1.moveNext(), isTrue);
    expect(iter1.current.asComparableEntry, Entry<String, int>("a", 1));
    expect(iter1.moveNext(), isTrue);
    expect(iter1.current.asComparableEntry, Entry<String, int>("b", 2));
    expect(iter1.moveNext(), isTrue);
    expect(iter1.current.asComparableEntry, Entry<String, int>("d", 4));
    expect(iter1.moveNext(), isTrue);
    expect(iter1.current.asComparableEntry, Entry<String, int>("c", 3));
    expect(iter1.moveNext(), isTrue);
    expect(iter1.current.asComparableEntry, Entry<String, int>("e", 5));
    expect(iter1.moveNext(), isTrue);
    expect(iter1.current.asComparableEntry, Entry<String, int>("f", 6));
    expect(iter1.moveNext(), isFalse);

    // Throws StateError after last moveNext().
    expect(() => iter1.current, throwsStateError);

    // 2) With sorted keys
    final IMap<String, int> imap2 =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    final Iterator<MapEntry<String, int>> iter2 = imap2.iterator;

    // Throws StateError before first moveNext().
    expect(() => iter2.current, throwsStateError);

    expect(iter2.moveNext(), isTrue);
    expect(iter2.current.asComparableEntry, Entry<String, int>("a", 1));
    expect(iter2.moveNext(), isTrue);
    expect(iter2.current.asComparableEntry, Entry<String, int>("b", 2));
    expect(iter2.moveNext(), isTrue);
    expect(iter2.current.asComparableEntry, Entry<String, int>("c", 3));
    expect(iter2.moveNext(), isTrue);
    expect(iter2.current.asComparableEntry, Entry<String, int>("d", 4));
    expect(iter2.moveNext(), isTrue);
    expect(iter2.current.asComparableEntry, Entry<String, int>("e", 5));
    expect(iter2.moveNext(), isTrue);
    expect(iter2.current.asComparableEntry, Entry<String, int>("f", 6));
    expect(iter2.moveNext(), isFalse);

    // Throws StateError after last moveNext().
    expect(() => iter2.current, throwsStateError);
  });

  test("any", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.any((String k, int v) => v == 4), isTrue);
    expect(imap.any((String k, int v) => k == "f"), isTrue);
    expect(imap.any((String k, int v) => v == 100), isFalse);
    expect(imap.any((String k, int v) => k == "z"), isFalse);
  });

  test("anyEntry", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.anyEntry((MapEntry<String, int?> entry) => entry.value == 4), isTrue);
    expect(imap.anyEntry((MapEntry<String, int?> entry) => entry.key == "f"), isTrue);
    expect(imap.anyEntry((MapEntry<String, int?> entry) => entry.value == 100), isFalse);
    expect(imap.anyEntry((MapEntry<String, int?> entry) => entry.key == "z"), isFalse);
  });

  test("everyEntry", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.everyEntry((MapEntry<String, int?> entry) => entry.value! < 7), isTrue);
    expect(imap.everyEntry((MapEntry<String, int?> entry) => entry.key.length <= 1), isTrue);
    expect(imap.everyEntry((MapEntry<String, int?> entry) => entry.key == "a"), isFalse);
    expect(imap.everyEntry((MapEntry<String, int?> entry) => entry.value! < 4), isFalse);
  });

  test("cast", () {
    // 1) Regular usage
    IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.cast<String, num>(), isA<IMap<String, num>>());
    IMap<String, num> casted = imap.cast<String, num>();
    var result = casted["a"];
    expect(result, 1);

    // 2) Error when type can't be cast
    imap = {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));

    Object? error;
    try {
      IMap<String, bool> casted = imap.cast<String, bool>();
      casted["a"]; // ignore: unnecessary_statements
    } catch (_error) {
      error = _error;
    }
    expect(error is TypeError, isTrue);
    expect(error.toString(), "type 'int' is not a subtype of type 'bool?' in type cast");
  });

  test("[]", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap["a"], 1);
    expect(imap["z"], isNull);
  });

  test("get", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.get("a"), 1);
    expect(imap.get("z"), isNull);
  });

  test("contains", () {
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

  test("containsKey", () {
    final IMap<String?, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.containsKey("a"), isTrue);
    expect(imap.containsKey("z"), isFalse);
    expect(imap.containsKey(null), isFalse);
  });

  test("containsValue", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.containsValue(1), isTrue);
    expect(imap.containsValue(100), isFalse);
    expect(imap.containsValue(null), isFalse);
  });

  test("containsEntry", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.containsEntry(MapEntry<String, int>("a", 1)), isTrue);
    expect(imap.containsEntry(MapEntry<String, int>("a", 2)), isFalse);
    expect(imap.containsEntry(MapEntry<String, int>("b", 1)), isFalse);
    expect(imap.containsEntry(MapEntry<String, int>("z", 100)), isFalse);
  });

  test("containsEntry", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.containsEntry(MapEntry<String, int>("a", 1)), isTrue);
    expect(imap.containsEntry(MapEntry<String, int>("a", 2)), isFalse);
    expect(imap.containsEntry(MapEntry<String, int>("b", 1)), isFalse);
    expect(imap.containsEntry(MapEntry<String, int>("z", 100)), isFalse);
  });

  test("toEntryList", () {
    // 1) Insertion Order
    final IMap<String, int> imap =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};
    expect(imap.toEntryList(), isA<List<MapEntry<String, int>>>());
    imap
        .toEntryList()
        .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));

    final List<Entry<String, int>> correctEntryList = [
      Entry("a", 1),
      Entry("c", 3),
      Entry("b", 2),
      Entry("d", 4),
      Entry("f", 6),
      Entry("e", 5)
    ];
    final List<MapEntry<String, int>> mapEntryList = imap.toEntryList();
    for (int i = 0; i < mapEntryList.length; i++)
      expect(mapEntryList[i].asComparableEntry, correctEntryList[i]);

    // 2) With sort
    final List<Entry<String, int>> correctEntryListSorted = [
      Entry("a", 1),
      Entry("b", 2),
      Entry("c", 3),
      Entry("d", 4),
      Entry("e", 5),
      Entry("f", 6)
    ];
    final List<MapEntry<String, int>> mapEntryListSorted =
        imap.withConfig(ConfigMap(sort: true)).toEntryList();
    for (int i = 0; i < mapEntryListSorted.length; i++)
      expect(mapEntryListSorted[i].asComparableEntry, correctEntryListSorted[i]);
  });

  test("toKeyList", () {
    // 1) Insertion Order
    final IMap<String, int> imap =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    expect(imap.toKeyList(), ["a", "c", "b", "d", "f", "e"]);

    // 2) With sorting
    expect(imap.withConfig(ConfigMap(sort: true)).toKeyList(), ["a", "b", "c", "d", "e", "f"]);
  });

  test("toValueList", () {
    // 1) Insertion Order
    final IMap<String, int> imap =
        {"a": 1, "c": 3, "b": 2}.lock.add("d", 4).addAll(IMap({"f": 6, "e": 5}));
    expect(imap.toValueList(), [1, 3, 2, 4, 6, 5]);

    // 2) With sorting
    expect(imap.toValueList(sort: true), [1, 2, 3, 4, 5, 6]);
  });

  test("toISet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};
    expect(imap.toEntrySet(), isA<Set<MapEntry<String, int>>>());
    imap
        .toEntrySet()
        .forEach((MapEntry<String, int?> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("toKeySet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<String> keys = ["a", "b", "c", "d", "e", "f"];
    expect(imap.toKeySet(), isA<Set<String>>());
    expect(imap.toKeySet(), keys.toSet());
  });

  test("toValueSet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<int> values = [1, 2, 3, 4, 5, 6];
    expect(imap.toValueSet(), isA<Set<int>>());
    expect(imap.toValueSet(), values.toSet());
  });

  test("toKeyISet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<String> keys = ["a", "b", "c", "d", "e", "f"];
    expect(imap.toKeyISet(), isA<ISet<String>>());
    expect(imap.toKeyISet(), keys.toSet());
  });

  test("length", () {
    // 1) Regular usage
    IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    expect(imap.length, 6);

    // 2) When with an empty IMap
    imap = IMapImpl.empty();

    expect(imap.length, 0);
    expect(imap.isEmpty, isTrue);
  });

  test("toValueISet", () {
    final IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    const List<int> values = [1, 2, 3, 4, 5, 6];
    expect(imap.toValueISet(), isA<ISet<int>>());
    expect(imap.toValueISet(), values.toSet());
  });

  test("forEach", () {
    IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));

    int result = 100;
    imap.forEach((String k, int? v) => result *= 1 + v!);
    expect(result, 504000);
  });

  test("map", () {
    IMap<String, int> imap =
        {"x": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));

    // ---

    var imap1 = imap.map<String, int>(
      (String k, int? v) => MapEntry(k, v! + 1),
      config: ConfigMap(sort: false),
    );
    expect(imap1.keys, ["x", "b", "c", "d", "e", "f"]);
    expect(imap1.values, [2, 3, 4, 5, 6, 7]);

    // ---

    var imap2 = imap.map<String, int>(
      (String k, int? v) => MapEntry(k, v! + 1),
      config: ConfigMap(sort: true),
    );
    expect(imap2.keys, ["b", "c", "d", "e", "f", "x"]);
    expect(imap2.values, [3, 4, 5, 6, 7, 2]);

    // ---

    var imap3 = imap.map<int, String>(
      (String k, int? v) => MapEntry(-v!, k),
      config: ConfigMap(sort: false),
    );
    expect(imap3.keys, [-1, -2, -3, -4, -5, -6]);
    expect(imap3.values, ["x", "b", "c", "d", "e", "f"]);

    // ---

    var imap4 = imap.map<int, String>(
      (String k, int? v) => MapEntry(-v!, k),
      config: ConfigMap(sort: true),
    );
    expect(imap4.keys, [-6, -5, -4, -3, -2, -1]);
    expect(imap4.values, ["f", "e", "d", "c", "b", "x"]);

    // ---

    var imap5 = imap.map<int, String>(
      (String k, int? v) => MapEntry(-v!, k),
      config: ConfigMap(sort: true),
      ifRemove: (int key, String value) => key == -5 || value == "c",
    );
    expect(imap5.keys, [-6, -4, -2, -1]);
    expect(imap5.values, ["f", "d", "b", "x"]);
  });

  test("mapTo", () {
    IMap<String, int> imap = {"x": 1, "b": 2, "c": 3}.lock;
    var imap1 = imap.mapTo<String>((String k, int? v) => "$k:$v");
    expect(imap1, ["x:1", "b:2", "c:3"]);
  });

  test("where", () {
    IMap<String, int> imap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));

    expect(imap.where((String k, int? v) => v! < 0).unlock, <String, int>{});
    expect(imap.where((String k, int? v) => k == "a" || k == "b").unlock,
        <String, int>{"a": 1, "b": 2});
    expect(imap.where((String k, int? v) => v! < 5).unlock,
        <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
    expect(imap.where((String k, int? v) => v! < 100).unlock,
        <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6});
  });

  test("toString", () {
    // 1) Global configuration prettyPrint == false
    ImmutableCollection.prettyPrint = false;
    expect({}.lock.toString(), "{}");
    expect({"a": 1}.lock.toString(), "{a: 1}");
    expect({"a": 1, "b": 2, "c": 3}.lock.toString(), "{a: 1, b: 2, c: 3}");

    // 2) Global configuration prettyPrint == true
    ImmutableCollection.prettyPrint = true;
    expect({}.lock.toString(), "{}");
    expect({"a": 1}.lock.toString(), "{a: 1}");
    expect(
        {"a": 1, "b": 2, "c": 3}.lock.toString(),
        "{\n"
        "   a: 1,\n"
        "   b: 2,\n"
        "   c: 3\n"
        "}");

    // 3) Local prettyPrint == false
    ImmutableCollection.prettyPrint = true;
    expect({}.lock.toString(false), "{}");
    expect({"a": 1}.lock.toString(false), "{a: 1}");
    expect({"a": 1, "b": 2, "c": 3}.lock.toString(false), "{a: 1, b: 2, c: 3}");

    // 4) Local prettyPrint == true
    expect({}.lock.toString(true), "{}");
    expect({"a": 1}.lock.toString(true), "{a: 1}");
    expect(
        {"a": 1, "b": 2, "c": 3}.lock.toString(true),
        "{\n"
        "   a: 1,\n"
        "   b: 2,\n"
        "   c: 3\n"
        "}");
  });

  test("clear", () {
    final IMap<String, int> imap =
        IMap.withConfig({"a": 1, "b": 2}, ConfigMap(isDeepEquals: false));
    final IMap<String, int> iMapCleared = imap.clear();
    expect(iMapCleared.unlock, allOf(isA<Map<String, int>>(), {}));
    expect(iMapCleared.config.isDeepEquals, isFalse);
  });

  test("putIfAbsent", () {
    // 1) Regular usage
    IMap<String, int?> scores = {"Bob": 36}.lock;

    var value = Output<int>();
    scores = scores.putIfAbsent("Bob", () => 3, previousValue: value);
    expect(value.value, 36);

    value = Output<int>();
    scores = scores.putIfAbsent("Rohan", () => 5, previousValue: value);
    expect(value.value, 5);

    value = Output<int>();
    scores = scores.putIfAbsent("Sophia", () => 6, previousValue: value);
    expect(value.value, 6);

    expect(scores["Bob"], 36);
    expect(scores["Rohan"], 5);
    expect(scores["Sophia"], 6);

    // 2) Sorted set
    IMap<String, int> imap = <String, int>{}
        .lock
        .withConfig(const ConfigMap(sort: true))
        .putIfAbsent("z", () => 100)
        .putIfAbsent("a", () => 1)
        .putIfAbsent("a", () => 40)
        .putIfAbsent("c", () => 3);
    expect(imap.keys, ["a", "c", "z"]);
    expect(imap.values, [1, 3, 100]);
  });

  test("update", () {
    // 1) Existent key
    IMap<String, int> scores = {"Bob": 36}.lock;

    Output<int> value = Output();
    IMap<String, int?> updatedScores =
        scores.update("Bob", (int? value) => value! * 2, previousValue: value);

    expect(scores.unlock, {"Bob": 36});
    expect(updatedScores.unlock, {"Bob": 72});
    expect(value.value, 36);

    // 2) Nonexistent key
    scores = {"Bob": 36}.lock;

    value = Output();
    updatedScores =
        scores.update("Joe", (int? value) => value! * 2, previousValue: value, ifAbsent: () => 1);

    expect(scores.unlock, {"Bob": 36});
    expect(updatedScores.unlock, {"Bob": 36, "Joe": 1});
    expect(value.value, null);

    // 3) Return the original map if update a nonexistent key without the ifAbsent parameter
    scores = {"Bob": 36}.lock;

    value = Output();
    expect(
        () => scores.update("Joe", (int? value) => value! * 2,
            previousValue: value, ifAbsent: (() => throw ArgumentError())),
        throwsArgumentError);

    value = Output();
    expect(scores.update("Joe", (int? value) => value! * 2, previousValue: value), scores);
    expect(value.value, null);

    // 4) ifRemove
    scores = {"Bob": 36, "Joe": 10}.lock;

    value = Output();
    final IMap<String, int?> newScores = scores.update("Joe", (int? value) => 2 * value!,
        ifRemove: (String key, int value) => value == 20, previousValue: value);
    expect(newScores.unlock, {"Bob": 36});
    expect(value.value, 10);

    // 5) Sorted map
    IMap<String, int> imap = <String, int>{}
        .lock
        .withConfig(const ConfigMap(sort: true))
        .update("z", ((int value) => 0), ifAbsent: () => 100)
        .update("a", ((int value) => 0), ifAbsent: () => 1)
        .update("a", ((int value) => 40), ifAbsent: () => 0)
        .update("c", ((int value) => 0), ifAbsent: () => 3);
    expect(imap.keys, ["a", "c", "z"]);
    expect(imap.values, [40, 3, 100]);

    // 6) Nullable value
    IMap<String, int?> nullableMap = <String, int?>{'foo': null}.lock;

    nullableMap = nullableMap.update('foo', (_) => 1);

    expect(nullableMap.get('foo'), 1);
  });

  test("updateAll", () {
    final IMap<String, int> scores = {"Bob": 36, "Joe": 100}.lock;
    final IMap<String, int?> updatedScores =
        scores.updateAll((String key, int? value) => value! * 2);

    expect(updatedScores.unlock, {"Bob": 72, "Joe": 200});
  });

  test("flushFactor", () {
    // 1) Default value
    expect(IMap.flushFactor, 50);

    // 2) Setter
    IMap.flushFactor = 200;
    expect(IMap.flushFactor, 200);

    // 3) Can't be smaller or equal to 0
    expect(() => IMap.flushFactor = 0, throwsStateError);
    expect(() => IMap.flushFactor = -100, throwsStateError);
  });
}

import "package:flutter_test/flutter_test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("Empty Initialization | Runtime Type", () {
    expect(IMapOfSets.empty<String, int>(), isA<IMapOfSets<String, int>>());
  });

  test("Empty Initialization | isEmpty | isNotEmpty", () {
    expect(IMapOfSets.empty().isEmpty, isTrue);
    expect(IMapOfSets.empty().isNotEmpty, isFalse);
  });

  test("IMapOfSets.equalItems()", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });

    expect(
        iMapOfSets1.equalItems([
          MapEntry<String, ISet<int>>("a", {1, 2}.lock),
          MapEntry<String, ISet<int>>("b", {1, 2, 3}.lock)
        ]),
        isTrue);
    expect(
        iMapOfSets1.equalItems([
          MapEntry<String, ISet<int>>("a", {1, 2, 3}.lock),
          MapEntry<String, ISet<int>>("b", {1, 2, 3}.lock)
        ]),
        isFalse);
    expect(
        iMapOfSets1.equalItems([
          MapEntry<String, ISet<int>>("b", {1, 2, 3}.lock)
        ]),
        isFalse);
  });

  test("IMapOfSets.equalItemsToIMap()", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });

    expect(
        iMapOfSets1.equalItemsToIMap(IMap({
          "a": {1, 2}.lock,
          "b": {1, 2, 3}.lock,
        })),
        isTrue);
    expect(
        iMapOfSets1.equalItemsToIMap(IMap({
          "a": {1, 2, 3}.lock,
          "b": {1, 2, 3}.lock,
        })),
        isFalse);
    expect(
        iMapOfSets1.equalItemsToIMap(IMap({
          "b": {1, 2, 3}.lock,
        })),
        isFalse);
  });

  test("IMapOfSets.equalItemsToIMapOfSets()", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });

    expect(
        iMapOfSets1.equalItemsToIMapOfSets(IMapOfSets({
          "a": {1, 2}.lock,
          "b": {1, 2, 3}.lock,
        })),
        isTrue);
    expect(
        iMapOfSets1.equalItemsToIMapOfSets(IMapOfSets({
          "a": {1, 2, 3}.lock,
          "b": {1, 2, 3}.lock,
        })),
        isFalse);
    expect(
        iMapOfSets1.equalItemsToIMapOfSets(IMapOfSets({
          "b": {1, 2, 3}.lock,
        })),
        isFalse);
  });

  test("IMapOfSets.== Operator", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2, 3},
        }),
        iMapOfSets2 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2, 3},
        }),
        iMapOfSets3 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2},
        }),
        iMapOfSets4 = IMapOfSets({
          "b": {1, 2, 3},
        }).add("a", 1).add("a", 2);

    expect(iMapOfSets1 == iMapOfSets2, isTrue);
    expect(iMapOfSets1 == iMapOfSets3, isFalse);
    expect(iMapOfSets1 == iMapOfSets4, isTrue);
    expect(iMapOfSets1 == iMapOfSets2.remove("a", 3), isTrue);
  });

  test("IMapOfSets.== Operator | !isDeepEquals", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2, 3},
        }).withConfig(ConfigMapOfSets(isDeepEquals: false)),
        iMapOfSets2 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2, 3},
        });

    expect(iMapOfSets1 == iMapOfSets2, isFalse);
  });

  test("IMapOfSets.same()", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2, 3},
        }),
        iMapOfSets2 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2, 3},
        }),
        iMapOfSets3 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2},
        }),
        iMapOfSets4 = IMapOfSets({
          "b": {1, 2, 3},
        }).add("a", 1).add("a", 2);

    expect(iMapOfSets1.same(iMapOfSets2), isFalse);
    expect(iMapOfSets1.same(iMapOfSets3), isFalse);
    expect(iMapOfSets1.same(iMapOfSets4), isFalse);
    expect(iMapOfSets1.same(iMapOfSets1.remove("a", 3)), isTrue);
  });

  test("IMapOfSets.hashCode()", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2, 3},
        }),
        iMapOfSets2 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2, 3},
        }),
        iMapOfSets3 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2},
        }),
        iMapOfSets4 = IMapOfSets({
          "b": {1, 2, 3},
        }).add("a", 1).add("a", 2),
        iMapOfSets5 = IMapOfSets({
          "a": {1, 2},
          "b": {1, 2, 3},
        }).withConfig(ConfigMapOfSets(isDeepEquals: false));

    expect(iMapOfSets1 == iMapOfSets2, isTrue);
    expect(iMapOfSets1 == iMapOfSets3, isFalse);
    expect(iMapOfSets1 == iMapOfSets4, isTrue);
    expect(iMapOfSets1 == iMapOfSets5, isFalse);
    expect(iMapOfSets1.hashCode, iMapOfSets2.hashCode);
    expect(iMapOfSets1.hashCode, isNot(iMapOfSets3.hashCode));
    expect(iMapOfSets1.hashCode, iMapOfSets4.hashCode);
    expect(iMapOfSets1.hashCode, isNot(iMapOfSets5.hashCode));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets.flush and IMapOfSets.isFlushed", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    }).addValues("a", {4, 5, 6});

    expect(iMapOfSets1.unlock, {
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets2.unlock, {
      "a": {1, 2, 4, 5, 6},
      "b": {1, 2, 3},
    });

    expect(iMapOfSets1.isFlushed, isTrue);
    expect(iMapOfSets2.isFlushed, isFalse);

    iMapOfSets1.flush;
    iMapOfSets2.flush;

    expect(iMapOfSets1.isFlushed, isTrue);
    expect(iMapOfSets2.isFlushed, isTrue);
  }, skip: true);

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Ensuring Immutability | IMapOfSets.add() | "
      "Changing the passed mutable map of sets doesn't change the IMapOfSets", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    original.addAll({
      "a": {1}
    });
    original.addAll({
      "c": {4, 5}
    });

    expect(original, <String, Set<int>>{
      "a": {1},
      "b": {1, 2, 3},
      "c": {4, 5},
    });
    expect(iMapOfSets.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
  });

  test(
      "Ensuring Immutability | IMapOfSets.add() | "
      "Changing the IMapOfSets also doesn't change the original map of sets", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    IMapOfSets<String, int> iMapOfSetsNew = iMapOfSets.add("a", 1);
    iMapOfSetsNew = iMapOfSetsNew.add("c", 4);

    expect(original, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSetsNew.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {4},
    });
  });

  test(
      "Ensuring Immutability | IMapOfSets.add() | "
      "If the item being passed is a variable, a pointer to it shouldn't exist inside ISet", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    int willChange = 4;
    final IMapOfSets<String, int> iMapOfSetsNew = iMapOfSets.add("c", willChange);

    willChange = 5;

    expect(original, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(willChange, 5);
    expect(iMapOfSetsNew.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {4},
    });
  });

  test(
      "Ensuring Immutability | IMapOfSets.addAll() | "
      "Changing the passed mutable map of sets doesn't change the immutable map of sets", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    original.addAll({
      "a": {1},
      "c": {4, 5}
    });

    expect(original, <String, Set<int>>{
      "a": {1},
      "b": {1, 2, 3},
      "c": {4, 5},
    });
    expect(iMapOfSets.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
  });

  test(
      "Ensuring Immutability | IMapOfSets.addAll() | "
      "Changing the passed immutable map of sets doesn't change the IMapOfSets", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    IMapOfSets<String, int> iMapOfSetsNew = iMapOfSets.replaceSet("a", <int>{1}.lock);
    iMapOfSetsNew = iMapOfSetsNew.replaceSet("c", <int>{4, 5}.lock);

    expect(original, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSetsNew.unlock, <String, Set<int>>{
      "a": {1},
      "b": {1, 2, 3},
      "c": {4, 5}
    });
  });

  test(
      "Ensuring Immutability | IMapOfSets.addAll() | "
      "If the items being passed are from a variable, "
      "it shouldn't have a pointer to the variable", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(original);
    ISet<int> sety = {10, 11}.lock;

    expect(iMapOfSets.unlock, original);

    final IMapOfSets<String, int> iMapOfSetsNew = iMapOfSets.replaceSet("z", sety);
    original.addAll({
      "c": {99}
    });

    sety = sety.add(12);

    expect(original, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {99}
    });
    expect(iMapOfSets.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(sety, {10, 11, 12});
    expect(iMapOfSetsNew.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
      "z": {10, 11},
    });
  });

  test(
      "Ensuring Immutability | IMapOfSets.remove() | "
      "Changing the passed mutable map of sets doesn't change the IMapOfSets", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    original.remove("a");

    expect(original, <String, Set<int>>{
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
  });

  test(
      "Ensuring Immutability | IMapOfSets.remove() | "
      "Removing from the original IMapOfSets doesn't change it", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    final IMapOfSets<String, int> iMapOfSetsNew = iMapOfSets.removeSet("a");

    expect(original, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSetsNew.unlock, <String, Set<int>>{
      "b": {1, 2, 3},
    });
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets.removeValues()", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {8, 12, 1},
      "d": {2},
      "e": {2, 0},
      "f": {2},
    };

    final IMapOfSets<String, int> iMapOfSets = original.lock;

    // Remove 1 value.
    expect(iMapOfSets.removeValues([2]).unlock, <String, Set<int>>{
      "a": {1},
      "b": {1, 3},
      "c": {8, 12, 1},
      "e": {0},
    });

    // Remove 2 values.
    expect(iMapOfSets.removeValues([1, 2]).unlock, <String, Set<int>>{
      "b": {3},
      "c": {8, 12},
      "e": {0},
    });

    // Don't remove anything (returns same instance).
    expect(iMapOfSets.removeValues([32, 47]).unlock, original);
    expect(iMapOfSets.removeValues([32, 47]).same(iMapOfSets), true);
  });

  test("IMapOfSets.removeValues() | numberOfRemovedValues", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {8, 12, 1},
      "d": {2},
      "e": {2, 0},
      "f": {2},
    };
    final Output<int> numberOfRemovedValues = Output<int>();

    final IMapOfSets<String, int> iMapOfSets = original.lock;

    iMapOfSets.removeValues([2], numberOfRemovedValues: numberOfRemovedValues);

    expect(numberOfRemovedValues.value, 5);
  });

  test("IMapOfSets.removeValuesWhere()", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {8, 12, 1},
      "d": {2},
      "e": {2, 0},
      "f": {2},
    };

    final IMapOfSets<String, int> iMapOfSets = original.lock;

    // Removes all odd values.
    expect(iMapOfSets.removeValuesWhere((key, value) => value % 2 == 0).unlock, <String, Set<int>>{
      "a": {1},
      "b": {1, 3},
      "c": {1},
    });

    // Removes all odd values from keys which are not "a" and "f".
    expect(
        iMapOfSets
            .removeValuesWhere((key, value) => key != "a" && key != "f" && value % 2 == 0)
            .unlock,
        <String, Set<int>>{
          "a": {1, 2},
          "b": {1, 3},
          "c": {1},
          "f": {2},
        });

    // Don't remove anything (returns same instance).
    expect(iMapOfSets.removeValuesWhere((key, value) => value == 32).unlock, original);
    expect(iMapOfSets.removeValuesWhere((key, value) => value == 32).same(iMapOfSets), true);
  });

  test("IMapOfSets.removeValuesWhere() | numberOfRemovedValues", () {
    final Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {8, 12, 1},
      "d": {2},
      "e": {2, 0},
      "f": {2},
    };
    final Output<int> numberOfRemovedValues = Output<int>();

    final IMapOfSets<String, int> iMapOfSets = original.lock;

    iMapOfSets.removeValuesWhere((String key, int value) => value == 2,
        numberOfRemovedValues: numberOfRemovedValues);

    expect(numberOfRemovedValues.value, 5);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("From a map of sets", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets1["a"], ISet({1, 2}));
    expect(iMapOfSets1["b"], ISet({1, 2, 3}));
  });

  test("From a map of lists", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    final Map<String, List<int>> mapOfLists = {
      "a": [1, 2],
      "b": [1, 2, 3],
    };
    final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets(mapOfLists);
    expect(iMapOfSets2["a"], ISet({1, 2}));
    expect(iMapOfSets2["b"], ISet({1, 2, 3}));
    expect(iMapOfSets2, iMapOfSets1);
  });

  test("From an IMap", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    final IMap<String, ISet<int>> iMap = IMap({
      "a": ISet({1, 2}),
      "b": ISet({1, 2, 3}),
    });
    final IMapOfSets<String, int> iMapOfSets3 = IMapOfSets.from(iMap);
    expect(iMapOfSets3["a"], ISet({1, 2}));
    expect(iMapOfSets3["b"], ISet({1, 2, 3}));
    expect(iMapOfSets3, iMapOfSets1);
  });

//////////////////////////////////////////////////////////////////////////////

  test("Empty Initialization from .withConfig() factory", () {
    expect(IMapOfSets.withConfig(null, null), isA<IMapOfSets>());
    expect(IMapOfSets.withConfig(null, null), IMapOfSets());
    expect(IMapOfSets.withConfig(null, null).isEmpty, isTrue);
  });

  test("Config | IMapOfSets.withConfig factory constructor", () {
    final ConfigMapOfSets configMapOfSets =
        ConfigMapOfSets(isDeepEquals: false, sortKeys: false, sortValues: false);
    final Map<String, Set<int>> mapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets.withConfig(mapOfSets, configMapOfSets);

    expect(iMapOfSets2.config.isDeepEquals, isFalse);
    expect(iMapOfSets2.config.sortKeys, isFalse);
    expect(iMapOfSets2.config.sortValues, isFalse);
  });

  test("IMapOfSets.withConfig() | config cannot be null", () {
    expect(() => IMapOfSets().withConfig(null), throwsAssertionError);
  });

  test("Config | IMapOfSets.withConfig()", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets1.config.isDeepEquals, isTrue);
    expect(iMapOfSets1.config.sortKeys, isTrue);
    expect(iMapOfSets1.config.sortValues, isTrue);

    final ConfigMapOfSets configMapOfSets =
        ConfigMapOfSets(isDeepEquals: false, sortKeys: false, sortValues: false);
    final IMapOfSets<String, int> iMapOfSets2 = iMapOfSets1.withConfig(configMapOfSets);

    expect(iMapOfSets2.config.isDeepEquals, isFalse);
    expect(iMapOfSets2.config.sortKeys, isFalse);
    expect(iMapOfSets2.config.sortValues, isFalse);
  });

  test("Config | IMap.isIdentityEquals getter", () {
    final Map<String, Set<int>> mapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets(mapOfSets);
    final ConfigMapOfSets configMapOfSets =
        ConfigMapOfSets(isDeepEquals: false, sortKeys: false, sortValues: false);

    expect(iMapOfSets1.isIdentityEquals, isFalse);
    final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets.withConfig(mapOfSets, configMapOfSets);
    expect(iMapOfSets2.isIdentityEquals, isTrue);
  });

  test("Config | Partial Configuration Checking | IMapOfSets.config getter", () {
    final Map<String, Set<int>> mapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final ConfigMapOfSets configMapOfSets =
        ConfigMapOfSets(isDeepEquals: false, sortKeys: false, sortValues: false);
    final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets.withConfig(mapOfSets, configMapOfSets);

    expect(
        iMapOfSets2.config,
        const ConfigMapOfSets(
          isDeepEquals: false,
          sortKeys: false,
          sortValues: false,
        ));
  });

  test("Config | Partial Configuration Checking | IMapOfSets.configSet getter", () {
    final Map<String, Set<int>> mapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final ConfigMapOfSets configMapOfSets =
        ConfigMapOfSets(isDeepEquals: false, sortKeys: false, sortValues: false);
    final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets.withConfig(mapOfSets, configMapOfSets);

    expect(
        iMapOfSets2.configSet,
        const ConfigSet(
          sort: false,
          isDeepEquals: false,
        ));
  });

  test("Config | Partial Configuration Checking | IMapOfSets.configMap getter", () {
    final Map<String, Set<int>> mapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final ConfigMapOfSets configMapOfSets =
        ConfigMapOfSets(isDeepEquals: false, sortKeys: false, sortValues: false);
    final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets.withConfig(mapOfSets, configMapOfSets);

    expect(
        iMapOfSets2.configMap,
        const ConfigMap(
          isDeepEquals: false,
          sortKeys: false,
          sortValues: false,
        ));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Runtime Type",
      () => expect(IMapOfSets.empty<String, int>(), isA<IMapOfSets<String, int>>()));

  test("isEmpty | isNotEmpty", () {
    expect(IMapOfSets.empty().isEmpty, isTrue);
    expect(IMapOfSets.empty().isNotEmpty, isFalse);
  });

  test("Adding an element", () {
    IMapOfSets<String, int> mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([1]));
  });

  test("Adding a second element with the same key", () {
    IMapOfSets<String, int> mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    mapOfSets = mapOfSets.add("a", 2);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([1, 2]));
  });

  test("Adding a third, different element", () {
    IMapOfSets<String, int> mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    mapOfSets = mapOfSets.add("a", 2);
    mapOfSets = mapOfSets.add("b", 3);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([1, 2]));
    expect(mapOfSets["b"], ISet<int>([3]));
  });

  test("Removing an element with an existing key of multiple elements", () {
    IMapOfSets<String, int> mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    mapOfSets = mapOfSets.add("a", 2);
    mapOfSets = mapOfSets.remove("a", 1);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([2]));
  });

  test("Removing an element completely", () {
    IMapOfSets<String, int> mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    mapOfSets = mapOfSets.add("b", 3);
    mapOfSets = mapOfSets.add("a", 2);
    mapOfSets = mapOfSets.remove("b", 3);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([1, 2]));
    expect(mapOfSets["b"], isNull);
  });

//////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets.[] operator", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets["a"], ISet({1, 2}));
    expect(iMapOfSets["b"], ISet({3}));
  });

  test("IMapOfSets.entries getter", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final ISet<MapEntry<String, ISet<int>>> entries = iMapOfSets.entriesAsSet;
    expect(
        entries,
        ISet([
          MapEntry("a", ISet({1, 2})),
          MapEntry("b", ISet({3})),
        ]).withDeepEquals);
  });

  test("IMapOfSets.keys getter", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.keys, isA<Iterable<String>>());
    expect(iMapOfSets.keys, ["a", "b"]);
  });

  test("IMapOfSets.sets getter", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.sets, isA<Iterable<ISet<int>>>());
    expect(iMapOfSets.sets, [
      ISet<int>({1, 2}),
      ISet<int>({3}),
    ]);
  });

  test("IMapOfSets.values getter", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.values, ISet<int>({1, 2, 3}));
  });

  test("IMapOfSets.add()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newSet = iMapOfSets.add("a", 5);
    expect(newSet["a"], ISet({1, 2, 5}));
  });

  test("IMapOfSets.addValues() | Adding to an existing key", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newMapOfSets = iMapOfSets.addValues("a", [2, 3, 4]);
    expect(newMapOfSets["a"], {1, 2, 3, 4});
  });

  test("IMapOfSets.addValues() | Adding to a nonexistent key", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets["z"], isNull);
    final IMapOfSets<String, int> newMapOfSets = iMapOfSets.addValues("z", [2, 3, 4]);
    expect(newMapOfSets["z"], {2, 3, 4});
  });

  test("IMapOfSets.addValues() | Adding to a nonexistent key", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets["z"], isNull);
    final IMapOfSets<String, int> newMapOfSets = iMapOfSets.addValues("z", [2, 3, 4]);
    expect(newMapOfSets["z"], {2, 3, 4});
  });

  test("IMapOfSets.addValuesToKeys()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> iMapOfSetsResult =
        iMapOfSets.addValuesToKeys(["a", "b", "c"], [4, 5]);

    expect(iMapOfSetsResult["a"], {1, 2, 4, 5});
    expect(iMapOfSetsResult["b"], {3, 4, 5});
    expect(iMapOfSetsResult["c"], {4, 5});
  });

  test("IMapOfSets.addAll()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newIMapOfSets = iMapOfSets.addMap({
      "a": {1, 2, 3},
      "b": {4},
      "c": {10, 11},
    });

    expect(newIMapOfSets.unlock, {
      "a": {1, 2, 3},
      "b": {3, 4},
      "c": {10, 11},
    });
  });

  test("IMapOfSets.addEntries()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    const MapEntry<String, Set<int>> entry1 = MapEntry("a", {1, 2, 3}),
        entry2 = MapEntry("b", {3, 4}),
        entry3 = MapEntry("c", {10, 11});
    final IMapOfSets<String, int> newIMapOfSets = iMapOfSets.addEntries([entry1, entry2, entry3]);

    expect(newIMapOfSets.unlock, {
      "a": {1, 2, 3},
      "b": {3, 4},
      "c": {10, 11},
    });
  });

  test("IMapOfSets.addIMap()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);

    expect(iMapOfSets.unlock, {
      "a": {1, 2},
      "b": {3},
    });
    expect(
        iMapOfSets
            .addIMap(IMap<String, Set<int>>({
              "a": {3, 4}
            }))
            .unlock,
        {
          "a": {1, 2, 3, 4},
          "b": {3},
        });
    expect(
        iMapOfSets
            .addIMap(IMap<String, Set<int>>({
              "c": {3, 4}
            }))
            .unlock,
        {
          "a": {1, 2},
          "b": {3},
          "c": {3, 4}
        });
  });

  test("IMapOfSets.remove()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newSet = iMapOfSets.add("a", 2);
    expect(newSet["a"], ISet({1, 2}));
  });

  test("IMapOfSets.replaceSet() | replacement set cannot be null",
      () => expect(() => IMapOfSets().replaceSet("a", null), throwsAssertionError));

  test("IMapOfSets.replaceSet() | Adding a new set on a new key", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newSet = iMapOfSets.replaceSet("z", ISet({2, 3, 4}));
    expect(newSet["z"], ISet({2, 3, 4}));
  });

  test("IMapOfSets.replaceSet() | Adding a new set on an existing key", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newSet = iMapOfSets.replaceSet("a", ISet({100}));
    expect(newSet["a"], ISet({100}));
  });

  test("IMapOfSets.replaceSet() | if removeEmptySets is true", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newSet = iMapOfSets.replaceSet("b", ISet({}));
    expect(newSet["b"], isNull);
  });

  test("IMapOfSets.clearSet() | nullifies the empty set if removeEmptySets is true", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> clearedSet = iMapOfSets.clearSet("a");
    expect(clearedSet["a"], isNull);
    expect(clearedSet["b"], {3});
  });

  test("IMapOfSets.clearSet() | empties set if removeEmptySets is false", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>(const ConfigMapOfSets(removeEmptySets: false))
            .add("a", 1)
            .add("a", 2)
            .add("b", 3);
    final IMapOfSets<String, int> clearedSet = iMapOfSets.clearSet("a");
    expect(clearedSet["a"], <int>{});
    expect(clearedSet["b"], {3});
  });

  test("IMapOfSets.removeSet()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newSet = iMapOfSets.removeSet("a");
    expect(newSet.keys.length, 1);
  });

  // TODO: Marcelo, o nome da função é getOrNull mas ela nunca retorna null?
  //Pelo menos é isso que está escrito na documentação...
  test("IMapOfSets.getOrNull()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.getOrNull("a"), ISet<int>({1, 2}));
    expect(iMapOfSets.getOrNull("b"), ISet<int>({3}));
    expect(iMapOfSets.getOrNull("c"), null);
  });

  test("IMapOfSets.get()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.get("a"), ISet<int>({1, 2}));
    expect(iMapOfSets.get("b"), ISet<int>({3}));
    expect(iMapOfSets.get("c"), ISet<int>());
  });

  test("IMapOfSets.containsKey()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.containsKey("a"), isTrue);
    expect(iMapOfSets.containsKey("b"), isTrue);
    expect(iMapOfSets.containsKey("c"), isFalse);
  });

  test("IMapOfSets.containsValue()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.containsValue(1), isTrue);
    expect(iMapOfSets.containsValue(2), isTrue);
    expect(iMapOfSets.containsValue(3), isTrue);
    expect(iMapOfSets.containsValue(4), isFalse);
  });

  test("IMapOfSets.contains()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.contains("a", 1), isTrue);
    expect(iMapOfSets.contains("a", 2), isTrue);
    expect(iMapOfSets.contains("b", 3), isTrue);
    expect(iMapOfSets.contains("b", 4), isFalse);
    expect(iMapOfSets.contains("c", 1), isFalse);
  });

  test("IMapOfSets.keyWithValue()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.getKeyWithValue(1), "a");
    expect(iMapOfSets.getKeyWithValue(2), "a");
    expect(iMapOfSets.getKeyWithValue(3), "b");
    expect(iMapOfSets.getKeyWithValue(4), isNull);
  });

  test("IMapOfSets.withValue family | IMapOfSets.entryWithValue()", () {
    final iMapOfSets = {
      "a": {1, 2},
      "b": {3},
      "d": {1}
    }.lock;
    expect(iMapOfSets.getEntryWithValue(1).asEntry, Entry("a", ISet<int>({1, 2})));
    expect(iMapOfSets.getEntryWithValue(2).asEntry, Entry("a", ISet<int>({1, 2})));
    expect(iMapOfSets.getEntryWithValue(3).asEntry, Entry("b", ISet<int>({3})));
    expect(iMapOfSets.getEntryWithValue(4), isNull);
  });

  test("IMapOfSets.withValue family | IMapOfSets.allEntriesWithValue()", () {
    final iMapOfSets = {
      "a": {1, 2},
      "b": {3},
      "d": {1}
    }.lock;
    expect(iMapOfSets.allEntriesWithValue(1).toString(), "{MapEntry(a: {1, 2}), MapEntry(d: {1})}");
    expect(iMapOfSets.allEntriesWithValue(2).toString(), "{MapEntry(a: {1, 2})}");
    expect(iMapOfSets.allEntriesWithValue(3).toString(), "{MapEntry(b: {3})}");
  });

  test("IMapOfSets.withValue family | IMapOfSets.allKeysWithValue()", () {
    final iMapOfSets = {
      "a": {1, 2},
      "b": {3},
      "d": {1}
    }.lock;
    expect(iMapOfSets.allKeysWithValue(1), {"a", "d"});
    expect(iMapOfSets.allKeysWithValue(2), {"a"});
    expect(iMapOfSets.allKeysWithValue(3), {"b"});
  });

  test("IMapOfSets.toString()", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.toString(), "{a: {1, 2}, b: {3}}");
  });

  test("IMapOfSets.flatten method", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });

    final List<MapEntry<String, int>> flattenedIMap = iMapOfSets.flatten().toList();
    final List<MapEntry<String, int>> correctFlattenedMap = [
      MapEntry<String, int>("a", 1),
      MapEntry<String, int>("a", 2),
      MapEntry<String, int>("b", 1),
      MapEntry<String, int>("b", 2),
      MapEntry<String, int>("b", 3),
    ];

    for (int i = 0; i < correctFlattenedMap.length; i++) {
      expect(flattenedIMap[i].asEntry.key, correctFlattenedMap[i].asEntry.key);
      expect(flattenedIMap[i].asEntry.value, correctFlattenedMap[i].asEntry.value);
    }
  });

  test("IMapOfSets.entriesAsSet()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.entriesAsSet.isDeepEquals, isTrue);
    expect(iMapOfSets.entriesAsSet, isA<ISet<MapEntry<String, ISet<int>>>>());
    expect(iMapOfSets.entriesAsSet.toString(),
        "{MapEntry(a: {1, 2}), MapEntry(b: {1, 2, 3}), MapEntry(c: {1, 2})}");
  });

  test("IMapOfSets.keyAsSet()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.keysAsSet.isDeepEquals, isTrue);
    expect(iMapOfSets.keysAsSet, isA<ISet<String>>());
    expect(iMapOfSets.keysAsSet, <String>{"a", "b", "c"});
  });

  test("IMapOfSets.keyAsSet()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.setsAsSet.isDeepEquals, isTrue);
    expect(iMapOfSets.setsAsSet, isA<ISet<ISet<int>>>());
    expect(iMapOfSets.setsAsSet, <Set<int>>{
      {1, 2},
      {1, 2, 3},
    });
  });

  test("IMapOfSets.valuesAsSet()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.valuesAsSet.isDeepEquals, isTrue);
    expect(iMapOfSets.valuesAsSet, isA<ISet<int>>());
    expect(iMapOfSets.valuesAsSet, <int>{1, 2, 3});
  });

  test("IMapOfSets.keysAsList()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.keysAsList.isDeepEquals, isTrue);
    expect(iMapOfSets.keysAsList, isA<IList<String>>());
    expect(iMapOfSets.keysAsList, <String>["a", "b", "c"]);
  });

  test("IMapOfSets.setsAsList()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.setsAsList.isDeepEquals, isTrue);
    expect(iMapOfSets.setsAsList, isA<IList<ISet<int>>>());
    expect(iMapOfSets.setsAsList, <Set<int>>[
      {1, 2},
      {1, 2, 3},
      {1, 2},
    ]);
  });

  test("IMapOfSets.cast()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    final IMapOfSets<int, int> iMapOfSets2 = IMapOfSets({
      1: {1, 2, 3},
      2: {4},
      3: {10, 11},
    });
    final IMapOfSets<String, num> newIMapOfSets1 = iMapOfSets.cast<String, num>();
    final IMapOfSets<num, int> newIMapOfSets2 = iMapOfSets2.cast<num, int>();
    final IMapOfSets<num, num> newIMapOfSets3 = iMapOfSets2.cast<num, num>();

    expect(newIMapOfSets1, isA<IMapOfSets<String, num>>());
    expect(newIMapOfSets2, isA<IMapOfSets<num, int>>());
    expect(newIMapOfSets3, isA<IMapOfSets<num, num>>());
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets.toggle method", () {
    IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.contains("a", 2), isTrue);

    iMapOfSets = iMapOfSets.toggle("a", 2);
    expect(iMapOfSets.contains("a", 2), isFalse);

    iMapOfSets = iMapOfSets.toggle("a", 2);
    expect(iMapOfSets.contains("a", 2), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IMapofSets.length getter", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.lengthOfKeys, 2);
  });

  test("IMapofSets.lengthOfValues getter", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.lengthOfValues, 5);
  });

  test("IMapofSets.lengthOfNonRepeatingValues getter", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.lengthOfNonRepeatingValues, 3);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets.unlock getter", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.unlock, {
      "a": {1, 2},
      "b": {1, 2, 3},
    });
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets.clear()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    final IMapOfSets<String, int> iMapOfSetsCleared = iMapOfSets.clear();

    // TODO: Marcelo, Ao que parece `.empty` leva a uma chamada sobre em `IMapOfSets.from` com
    // `mapOfSets` como `null`. Para resolver isso, eu adicionei um `?.` no `mapOfSets.map`.
    expect(iMapOfSetsCleared, IMapOfSets.empty<String, int>());
    expect(iMapOfSetsCleared.unlock, <String, Set<int>>{});
  });

  test("IMapOfSets.forEach()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    iMapOfSets.forEach((String key, ISet<int> set) => expect(iMapOfSets[key], set));
  });

  test("IMapOfSets.map()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    final IMapOfSets<num, num> mappedIMapOfSets = iMapOfSets.map<num, num>(
        (String key, ISet<int> set) =>
            MapEntry<num, ISet<num>>(num.parse(key + key), set.cast<num>()));

    expect(mappedIMapOfSets, isA<IMapOfSets<num, num>>());
    expect(
        mappedIMapOfSets,
        IMapOfSets<num, num>({
          11: {1, 2, 3},
          22: {4},
          33: {10, 11},
        }));
  });

  test("IMapOfSets.removeWhere()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    final IMapOfSets<String, int> newIMapOfSets =
        iMapOfSets.removeWhere((String key, ISet<int> set) => set.contains(10));

    expect(
        newIMapOfSets,
        IMapOfSets<String, int>({
          "1": {1, 2, 3},
          "2": {4},
        }));
  });

  test("IMapOfSets.update() | Updating an existing key", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    // TODO: Marcelo, talvez não seria melhor renomear este método para `updateSet`?
    // TODO: Este método nao possui o parâmetro `value` (`Item`), como no caso do IMap, é isso
    // mesmo?
    final IMapOfSets<String, int> newIMapOfSets =
        iMapOfSets.update("1", (ISet<int> set) => {100}.lock);

    expect(
        newIMapOfSets,
        IMapOfSets<String, int>({
          "1": {100},
          "2": {4},
          "3": {10, 11},
        }));
  });

  test("IMapOfSets.update() | Updating a nonexistent key", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    final IMapOfSets<String, int> newIMapOfSets =
        iMapOfSets.update("4", (ISet<int> set) => {100}.lock, ifAbsent: () => {1000}.lock);

    expect(
        newIMapOfSets,
        IMapOfSets<String, int>({
          "1": {1, 2, 3},
          "2": {4},
          "3": {10, 11},
          "4": {1000},
        }));
  });

  test("IMapOfSets.update() | Updating a nonexistent key without ifAbsent yields an error", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    expect(() => iMapOfSets.update("4", (ISet<int> set) => {100}.lock), throwsArgumentError);
  });

  test("IMapOfSets.updateAll()", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    final IMapOfSets<String, int> newIMapOfSets =
        iMapOfSets.updateAll((String key, ISet<int> set) => {int.parse(key)}.lock);

    expect(
        newIMapOfSets,
        IMapOfSets<String, int>({
          "1": {1},
          "2": {2},
          "3": {3},
        }));
  });

  // //////////////////////////////////////////////////////////////////////////////

  test("IMapOfSetsExtension.invertKeysAndValues", () {
    IMapOfSets<String, int> iMapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {5, 1},
      "d": {5, 8},
      "e": {12, 5},
    }.lock;

    var invertedIMapOfSets = iMapOfSets.invertKeysAndValues();
    expect(invertedIMapOfSets.unlock, {
      1: {"a", "b", "c"},
      2: {"a", "b"},
      3: {"b"},
      5: {"c", "d", "e"},
      8: {"d"},
      12: {"e"},
    });

    // Invert twice return to normal.
    expect(invertedIMapOfSets.invertKeysAndValues(), iMapOfSets);
  });

  // //////////////////////////////////////////////////////////////////////////////
}

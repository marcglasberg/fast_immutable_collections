// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

/// These tests cover code paths of [IMapOfSets] which were not reached by other tests.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
    IMapOfSets.defaultConfig = const ConfigMapOfSets();
  });

  tearDown(() {
    ImmutableCollection.resetAllConfigurations();
    IMapOfSets.defaultConfig = const ConfigMapOfSets();
  });

  //////////////////////////////////////////////////////////////////////////////

  test("defaultConfig | setting the same value", () {
    expect(IMapOfSets.defaultConfig, const ConfigMapOfSets());

    // Setting the same value (equal, but not identical) does nothing.
    IMapOfSets.defaultConfig = ConfigMapOfSets();
    expect(IMapOfSets.defaultConfig, const ConfigMapOfSets());

    // Setting a different value, and then setting it again.
    const ConfigMapOfSets config = ConfigMapOfSets(removeEmptySets: false, sortKeys: true);
    IMapOfSets.defaultConfig = config;
    expect(IMapOfSets.defaultConfig, config);
    IMapOfSets.defaultConfig = ConfigMapOfSets(removeEmptySets: false, sortKeys: true);
    expect(IMapOfSets.defaultConfig, config);
    expect(IMapOfSets<String, int>({"a": {1}}).config, config);
  });

  //////////////////////////////////////////////////////////////////////////////

  group("removeValues | with empty sets |", () {
    //
    test("removeEmptySets is false", () {
      final IMapOfSets<String, int> iMapOfSets = IMapOfSets.withConfig({
        "a": <int>{},
        "b": {1, 2},
        "c": {1},
      }, ConfigMapOfSets(removeEmptySets: false));

      final Output<int> numberOfRemovedValues = Output();
      final IMapOfSets<String, int> result =
          iMapOfSets.removeValues([1], numberOfRemovedValues: numberOfRemovedValues);

      expect(numberOfRemovedValues.value, 2);
      expect(result.unlock, <String, Set<int>>{
        "a": {},
        "b": {2},
        "c": {},
      });
      expect(result.config, ConfigMapOfSets(removeEmptySets: false));

      // The empty set is kept as is.
      expect(identical(result["a"], iMapOfSets["a"]), isTrue);
    });

    test("removeEmptySets is true", () {
      final IMapOfSets<String, int> iMapOfSets = IMapOfSets.withConfig({
        "a": <int>{},
        "b": {1, 2},
        "c": {1},
      }, ConfigMapOfSets(removeEmptySets: true));

      // The empty set already in the map is discarded too.
      final Output<int> numberOfRemovedValues = Output();
      final IMapOfSets<String, int> result =
          iMapOfSets.removeValues([1], numberOfRemovedValues: numberOfRemovedValues);
      expect(numberOfRemovedValues.value, 2);
      expect(result.unlock, <String, Set<int>>{"b": {2}});
    });

    test("nothing removed returns the same instance", () {
      final IMapOfSets<String, int> iMapOfSets = IMapOfSets.withConfig({
        "a": <int>{},
        "b": {1, 2},
      }, ConfigMapOfSets(removeEmptySets: true));

      final Output<int> numberOfRemovedValues = Output();
      final IMapOfSets<String, int> result =
          iMapOfSets.removeValues([10], numberOfRemovedValues: numberOfRemovedValues);
      expect(numberOfRemovedValues.value, 0);
      expect(identical(result, iMapOfSets), isTrue);
      expect(result.unlock, <String, Set<int>>{
        "a": {},
        "b": {1, 2},
      });
    });
  });

  //////////////////////////////////////////////////////////////////////////////

  group("removeValuesWhere | with empty sets |", () {
    //
    test("removeEmptySets is false", () {
      final IMapOfSets<String, int> iMapOfSets = IMapOfSets.withConfig({
        "a": <int>{},
        "b": {1, 2},
        "c": {1},
      }, ConfigMapOfSets(removeEmptySets: false));

      final Output<int> numberOfRemovedValues = Output();
      final IMapOfSets<String, int> result = iMapOfSets.removeValuesWhere(
          (String key, int value) => value == 1,
          numberOfRemovedValues: numberOfRemovedValues);

      expect(numberOfRemovedValues.value, 2);
      expect(result.unlock, <String, Set<int>>{
        "a": {},
        "b": {2},
        "c": {},
      });
      expect(identical(result["a"], iMapOfSets["a"]), isTrue);
    });

    test("removeEmptySets is true", () {
      final IMapOfSets<String, int> iMapOfSets = IMapOfSets.withConfig({
        "a": <int>{},
        "b": {1, 2},
        "c": {1},
      }, ConfigMapOfSets(removeEmptySets: true));

      final Output<int> numberOfRemovedValues = Output();
      final IMapOfSets<String, int> result = iMapOfSets.removeValuesWhere(
          (String key, int value) => key == "b" && value == 2,
          numberOfRemovedValues: numberOfRemovedValues);

      expect(numberOfRemovedValues.value, 1);
      expect(result.unlock, <String, Set<int>>{
        "b": {1},
        "c": {1},
      });
    });

    test("the test is never called for empty sets", () {
      final IMapOfSets<String, int> iMapOfSets = IMapOfSets.withConfig({
        "a": <int>{},
      }, ConfigMapOfSets(removeEmptySets: false));

      int calls = 0;
      final IMapOfSets<String, int> result = iMapOfSets.removeValuesWhere((String key, int value) {
        calls++;
        return true;
      });
      expect(calls, 0);
      expect(identical(result, iMapOfSets), isTrue);
    });
  });

  //////////////////////////////////////////////////////////////////////////////

  test("remove | removing the last value of a set", () {
    final IMapOfSets<String, int> removeEmpty = IMapOfSets.withConfig({
      "a": {1},
      "b": {2},
    }, ConfigMapOfSets(removeEmptySets: true));
    expect(removeEmpty.remove("a", 1).unlock, <String, Set<int>>{"b": {2}});

    final IMapOfSets<String, int> keepEmpty = IMapOfSets.withConfig({
      "a": {1},
      "b": {2},
    }, ConfigMapOfSets(removeEmptySets: false));
    expect(keepEmpty.remove("a", 1).unlock, <String, Set<int>>{
      "a": {},
      "b": {2},
    });
    expect(keepEmpty.remove("a", 1).isEmptyForKey("a"), isTrue);
    expect(keepEmpty.remove("a", 1).containsKey("a"), isTrue);

    // Removing a value which isn't there returns the same instance.
    expect(identical(keepEmpty.remove("a", 99), keepEmpty), isTrue);
    expect(identical(keepEmpty.remove("z", 1), keepEmpty), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("equalItemsAndConfig", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {3},
    });

    // Identical.
    expect(iMapOfSets.equalItemsAndConfig(iMapOfSets), isTrue);

    // Same items and config, different instances.
    expect(
        iMapOfSets.equalItemsAndConfig(IMapOfSets({
          "a": {1, 2},
          "b": {3},
        })),
        isTrue);

    // Same internals, different instances.
    final IMapOfSets<String, int> sameInternals =
        IMapOfSets.from(iMapOfSets.asIMap(), config: iMapOfSets.config);
    expect(identical(sameInternals, iMapOfSets), isFalse);
    expect(iMapOfSets.equalItemsAndConfig(sameInternals), isTrue);

    // Same items, different config.
    expect(
        iMapOfSets.equalItemsAndConfig(
            iMapOfSets.withConfig(ConfigMapOfSets(removeEmptySets: false))),
        isFalse);

    // Different items.
    expect(iMapOfSets.equalItemsAndConfig(iMapOfSets.add("b", 4)), isFalse);
    expect(iMapOfSets.equalItemsAndConfig(iMapOfSets.removeSet("b")), isFalse);
    expect(IMapOfSets.empty<String, int>().equalItemsAndConfig(IMapOfSets<String, int>()), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
    "withConfig factory | null map keeps the given config",
    () {
      const ConfigMapOfSets config = ConfigMapOfSets(removeEmptySets: false);
      final IMapOfSets<String, int> iMapOfSets = IMapOfSets.withConfig(null, config);
      expect(iMapOfSets.isEmpty, isTrue);
      expect(iMapOfSets.config, config);
    },
  );

  test(
    "removeValues | removeValuesWhere | result keeps the map config, and hashCode agrees with ==",
    () {
      const ConfigMapOfSets config = ConfigMapOfSets(sortKeys: true);
      final IMapOfSets<String, int> iMapOfSets = IMapOfSets.withConfig({
        "a": {1, 2},
        "b": {1, 3},
      }, config);
      final IMapOfSets<String, int> expected = IMapOfSets.withConfig({
        "a": {1},
        "b": {1, 3},
      }, config);

      final IMapOfSets<String, int> result1 = iMapOfSets.removeValues([2]);
      expect(result1, expected);
      expect(result1.asIMap().config, config.asConfigMap);
      expect(result1.hashCode, expected.hashCode);

      final IMapOfSets<String, int> result2 =
          iMapOfSets.removeValuesWhere((String key, int value) => value == 2);
      expect(result2, expected);
      expect(result2.asIMap().config, config.asConfigMap);
      expect(result2.hashCode, expected.hashCode);
    },
  );
}

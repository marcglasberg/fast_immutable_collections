// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/iset/iset.dart';
import "package:test/test.dart";

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("Runtime Type", () {
    expect(IMapOfSets.empty<String, int>(), isA<IMapOfSets<String, int>>());
    expect(<String, Set<int>>{}.lock, isA<IMapOfSets<String, int>>());
  });

  test("isEmpty | isNotEmpty", () {
    expect(IMapOfSets.empty().isEmpty, isTrue);
    expect(IMapOfSets.empty().isNotEmpty, isFalse);

    expect(<String, Set<int>>{}.lock.isEmpty, isTrue);
    expect(<String, Set<int>>{}.lock.isNotEmpty, isFalse);
  });

  test("isEmptyForKey and isNotEmptyForKey", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1},
      "b": {1, 2, 3},
      "c": {},
    });

    expect(iMapOfSets1.isEmptyForKey('a'), isFalse);
    expect(iMapOfSets1.isEmptyForKey('b'), isFalse);
    expect(iMapOfSets1.isEmptyForKey('c'), isTrue);
    expect(iMapOfSets1.isEmptyForKey('d'), isTrue);

    expect(iMapOfSets1.isNotEmptyForKey('a'), isTrue);
    expect(iMapOfSets1.isNotEmptyForKey('b'), isTrue);
    expect(iMapOfSets1.isNotEmptyForKey('c'), isFalse);
    expect(iMapOfSets1.isNotEmptyForKey('d'), isFalse);
  });

  test("equalItems", () {
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

  test("equalItemsToIMap", () {
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

  test("equalItemsToIMapOfSets", () {
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

  test("==", () {
    // 1) Default
    IMapOfSets<String, int?> iMapOfSets1 = IMapOfSets({
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

    // 2) !isDeepEquals
    iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    }).withConfig(ConfigMapOfSets(isDeepEquals: false));
    iMapOfSets2 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });

    expect(iMapOfSets1 == iMapOfSets2, isFalse);
  });

  test("same", () {
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

  test("hashCode", () {
    final IMapOfSets<String, int?> iMapOfSets1 = IMapOfSets({
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

  test("flush and IMapOfSets.isFlushed", () {
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets1.isFlushed, isTrue);

    final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    }).addValues("a", {4, 5, 6});

    expect(iMapOfSets1.isFlushed, isTrue);
    expect(iMapOfSets2.isFlushed, isFalse);

    // Unlocking does not flush the collection.
    var mapOfSets1 = iMapOfSets1.unlock;
    var mapOfSets2 = iMapOfSets2.unlock;
    expect(iMapOfSets1.isFlushed, isTrue);
    expect(iMapOfSets2.isFlushed, isFalse);

    // ---

    // The equals is flushing the collection (this may change in the future).
    expect(mapOfSets1, {
      "a": {1, 2},
      "b": {1, 2, 3}
    });

    expect(mapOfSets2, {
      "a": {1, 2, 4, 5, 6},
      "b": {1, 2, 3}
    });

    expect(iMapOfSets1.isFlushed, isTrue);
    expect(iMapOfSets2.isFlushed, isFalse);

    iMapOfSets1.flush;
    iMapOfSets2.flush;

    expect(iMapOfSets1.isFlushed, isTrue);
    expect(iMapOfSets2.isFlushed, isTrue);
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable map of sets doesn't change the IMapOfSets
    Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    IMapOfSets<String, int> iMapOfSets = IMapOfSets(original);

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

    // 1.2) Changing the IMapOfSets also doesn't change the original map of sets
    original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    iMapOfSets = IMapOfSets(original);

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

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside IMapOfSets
    original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    int willChange = 4;
    iMapOfSetsNew = iMapOfSets.add("c", willChange);

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

    // 2) addAll

    // 2.1) Changing the passed mutable map of sets doesn't change the immutable map of sets
    original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    iMapOfSets = IMapOfSets(original);

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

    // 2.2) Changing the passed immutable map of sets doesn't change the IMapOfSets
    original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    iMapOfSetsNew = iMapOfSets.replaceSet("a", <int>{1}.lock);
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

    // 2.3) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    iMapOfSets = IMapOfSets(original);
    ISet<int> sety = {10, 11}.lock;

    expect(iMapOfSets.unlock, original);

    iMapOfSetsNew = iMapOfSets.replaceSet("z", sety);
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

    // 3) remove

    // 3.1) Changing the passed mutable map of sets doesn't change the IMapOfSets
    original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    original.remove("a");

    expect(original, <String, Set<int>>{
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.unlock, <String, Set<int>>{
      "a": {1, 2},
      "b": {1, 2, 3},
    });

    // 3.2) Removing from the original IMapOfSets doesn't change it
    original = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    iMapOfSets = IMapOfSets(original);

    expect(iMapOfSets.unlock, original);

    iMapOfSetsNew = iMapOfSets.removeSet("a");

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

  test("removeValues", () {
    // 1) Regular usage
    Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {8, 12, 1},
      "d": {2},
      "e": {2, 0},
      "f": {2},
    };

    IMapOfSets<String, int> iMapOfSets = original.lock;

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

    // 2) Guaranteeing that we remove empty sets
    final IMapOfSets<String, int> original1 = IMapOfSets.withConfig({
      "a": {1, 2},
      "b": {1, 2, 3},
    }, const ConfigMapOfSets(removeEmptySets: true));
    final IMapOfSets<String, int?> original2 =
        original1.withConfig(const ConfigMapOfSets(removeEmptySets: false));

    expect(original1.removeValues([1, 2]).unlock, {
      "b": {3}
    });
    expect(
        original2.removeValuesWhere((String key, int? value) => value == 1 || value == 2).unlock, {
      "a": <int>{},
      "b": {3}
    });

    // 3) numberOfRemovedValues
    original = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {8, 12, 1},
      "d": {2},
      "e": {2, 0},
      "f": {2},
    };
    final Output<int> numberOfRemovedValues = Output<int>();

    iMapOfSets = original.lock;

    var _ = iMapOfSets.removeValues([2], numberOfRemovedValues: numberOfRemovedValues);

    expect(numberOfRemovedValues.value, 5);
  });

  test("removeValuesWhere", () {
    // 1) Regular usage
    Map<String, Set<int>> original = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {8, 12, 1},
      "d": {2},
      "e": {2, 0},
      "f": {2},
    };

    IMapOfSets<String, int> iMapOfSets = original.lock;

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

    // 2) Guaranteeing that we remove empty sets when the configuration says so
    final IMapOfSets<String, int> original1 = IMapOfSets.withConfig({
      "a": {1, 2},
      "b": {1, 2, 3},
    }, const ConfigMapOfSets(removeEmptySets: true));
    final IMapOfSets<String, int?> original2 =
        original1.withConfig(const ConfigMapOfSets(removeEmptySets: false));

    expect(
        original1.removeValuesWhere((String key, int? value) => value == 1 || value == 2).unlock, {
      "b": {3}
    });
    expect(
        original2.removeValuesWhere((String key, int? value) => value == 1 || value == 2).unlock, {
      "a": <int>{},
      "b": {3}
    });

    // 3) numberOfRemovedValues
    original = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {8, 12, 1},
      "d": {2},
      "e": {2, 0},
      "f": {2},
    };
    final Output<int> numberOfRemovedValues = Output<int>();

    iMapOfSets = original.lock;

    var _ = iMapOfSets.removeValuesWhere((String key, int? value) => value == 2,
        numberOfRemovedValues: numberOfRemovedValues);

    expect(numberOfRemovedValues.value, 5);
  });

  test("Default Constructor", () {
    // 1) From a map of sets
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets1["a"], ISet({1, 2}));
    expect(iMapOfSets1["b"], ISet({1, 2, 3}));

    // 2) From a map of lists
    final Map<String, List<int>> mapOfLists = {
      "a": [1, 2],
      "b": [1, 2, 3],
    };
    final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets(mapOfLists);
    expect(iMapOfSets2["a"], ISet({1, 2}));
    expect(iMapOfSets2["b"], ISet({1, 2, 3}));
    expect(iMapOfSets2, iMapOfSets1);

    // 3) From an IMap
    final IMap<String, ISet<int>> imap = IMap({
      "a": ISet({1, 2}),
      "b": ISet({1, 2, 3}),
    });
    final IMapOfSets<String, int> iMapOfSets3 = IMapOfSets.from(imap);
    expect(iMapOfSets3["a"], ISet({1, 2}));
    expect(iMapOfSets3["b"], ISet({1, 2, 3}));
    expect(iMapOfSets3, iMapOfSets1);
  });

  test("from", () {
    // 1) Regular usage
    var imapOfSets = IMapOfSets.from({
      "c": {1, 2, 3}.lock,
      "a": {1, 2}.lock,
      "b": {3}.lock,
    }.lock);

    expect(imapOfSets["a"], {1, 2}.lock);
    expect(imapOfSets["b"], {3}.lock);
    expect(imapOfSets["c"], {1, 2, 3}.lock);

    // 2) With sorting
    var imapOfSets1 = IMapOfSets.from(
        {
          "c": {1, 2, 3}.lock,
          "a": {1, 2}.lock,
          "b": {3}.lock,
        }.lock,
        config: ConfigMapOfSets(sortKeys: false));

    var imapOfSets2 = IMapOfSets.from(
        {
          "c": {1, 2, 3}.lock,
          "a": {1, 2}.lock,
          "b": {3}.lock,
        }.lock,
        config: ConfigMapOfSets(sortKeys: true));

    expect(imapOfSets1.keys, ["c", "a", "b"]);
    expect(imapOfSets2.keys, ["a", "b", "c"]);
  });

  test("fromIterable", () {
    // 1) Regular usage
    final IMapOfSets<String, int> fromIterable = IMapOfSets.fromIterable(
      [1, 2, 2, 3],
      keyMapper: (int n) => n.toString(),
      valueMapper: (int n) => 2 * n,
      config: ConfigMapOfSets(cacheHashCode: false),
    );

    expect(fromIterable.unlock, {
      "1": {2},
      "2": {4},
      "3": {6}
    });
    expect(fromIterable.config, const ConfigMapOfSets(cacheHashCode: false));

    // 2) no functions means the identity function
    final IMapOfSets<int, int> fromIterable2 = IMapOfSets.fromIterable(
      [1, 2, 2, 3],
      config: ConfigMapOfSets(cacheHashCode: false),
    );

    expect(fromIterable2.unlock, {
      1: {1},
      2: {2},
      3: {3}
    });
    expect(fromIterable2.config, const ConfigMapOfSets(cacheHashCode: false));

    // 3) With sorting
    var imapOfSets1 = IMapOfSets.fromIterable(
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
      config: ConfigMapOfSets(sortKeys: false),
    );

    var imapOfSets2 = IMapOfSets.fromIterable(
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
      config: ConfigMapOfSets(sortKeys: true),
    );

    expect(imapOfSets1.keys, ["c", "a", "b"]);
    expect(imapOfSets2.keys, ["a", "b", "c"]);

    // 4) Ignoring values
    final IMapOfSets<String, int> fromIterableIgnoring = IMapOfSets.fromIterable(
      [1, 2, 2, 3],
      keyMapper: (int n) => n.toString(),
      valueMapper: (int n) => 2 * n,
      config: ConfigMapOfSets(cacheHashCode: false),
      ignore: (int n) => n == 1, // Removes n == 1.
    );

    expect(fromIterableIgnoring.unlock, {
      "2": {4},
      "3": {6}
    });
    expect(fromIterableIgnoring.config, const ConfigMapOfSets(cacheHashCode: false));
  });

  test("withConfig factory", () {
    // 1) Empty initialization
    expect(IMapOfSets.withConfig(null, IMapOfSets.defaultConfig),
        allOf(isA<IMapOfSets>(), IMapOfSets()));
    expect(IMapOfSets.withConfig(null, IMapOfSets.defaultConfig).isEmpty, isTrue);

    // 2) Regular usage
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

    // 3) With sorting
    var imapOfSets1 = IMapOfSets.withConfig({
      "c": {1, 2},
      "a": {1, 2, 3},
      "b": {1},
    }, ConfigMapOfSets(sortKeys: false));

    var imapOfSets2 = IMapOfSets.withConfig({
      "c": {1, 2},
      "a": {1, 2, 3},
      "b": {1},
    }, ConfigMapOfSets(sortKeys: true));

    expect(imapOfSets1.keys, ["c", "a", "b"]);
    expect(imapOfSets2.keys, ["a", "b", "c"]);
  });

  test("Changing configs", () {
    var imapOfSets1 = IMapOfSets.withConfig({
      "c": {1, 2},
      "a": {1, 2, 3},
      "b": {1},
    }, ConfigMapOfSets(sortKeys: true))
        .withConfig(ConfigMapOfSets(sortKeys: true));
    expect(imapOfSets1.keys, ["a", "b", "c"]);

    var imapOfSets2 = IMapOfSets.withConfig({
      "c": {1, 2},
      "a": {1, 2, 3},
      "b": {1},
    }, ConfigMapOfSets(sortKeys: true))
        .withConfig(ConfigMapOfSets(sortKeys: false));
    expect(imapOfSets2.keys, ["a", "b", "c"]);

    var imapOfSets3 = IMapOfSets.withConfig({
      "c": {1, 2},
      "a": {1, 2, 3},
      "b": {1},
    }, ConfigMapOfSets(sortKeys: false))
        .withConfig(ConfigMapOfSets(sortKeys: true));
    expect(imapOfSets3.keys, ["a", "b", "c"]);

    var imapOfSets4 = IMapOfSets.withConfig({
      "c": {1, 2},
      "a": {1, 2, 3},
      "b": {1},
    }, ConfigMapOfSets(sortKeys: false))
        .withConfig(ConfigMapOfSets(sortKeys: false));
    expect(imapOfSets4.keys, ["c", "a", "b"]);
  });

  test("withConfig", () {
    // 1) Regular usage
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets1.config.isDeepEquals, isTrue);
    expect(iMapOfSets1.config.sortKeys, isFalse);
    expect(iMapOfSets1.config.sortValues, isFalse);

    final ConfigMapOfSets configMapOfSets =
        ConfigMapOfSets(isDeepEquals: false, sortKeys: true, sortValues: true);
    final IMapOfSets<String, int?> iMapOfSets2 = iMapOfSets1.withConfig(configMapOfSets);

    expect(iMapOfSets2.config.isDeepEquals, isFalse);
    expect(iMapOfSets2.config.sortKeys, isTrue);
    expect(iMapOfSets2.config.sortValues, isTrue);

    // 2) With sorting
    var imapOfSets1 = {
      "c": {1, 2},
      "a": {1, 2, 3},
      "b": {1},
    }.lock.withConfig(ConfigMapOfSets(sortKeys: false));

    var imapOfSets2 = {
      "c": {1, 2},
      "a": {1, 2, 3},
      "b": {1},
    }.lock.withConfig(ConfigMapOfSets(sortKeys: true));

    expect(imapOfSets1.keys, ["c", "a", "b"]);
    expect(imapOfSets2.keys, ["a", "b", "c"]);
  });

  test("orNull", () {
    // 1) Null -> Null
    Map<String, Iterable<int>>? mapOfSets;
    expect(IMapOfSets.orNull(mapOfSets), isNull);

    // 2) Map -> IMapOfSets
    mapOfSets = {
      "a": {1, 2, 3},
      "b": {1},
      "c": {1, 2},
    };
    expect(
        IMapOfSets.orNull(mapOfSets),
        {
          "a": {1, 2, 3},
          "b": {1},
          "c": {1, 2},
        }.lock);

    // 3) Map with Config -> IMapOfSets with Config
    IMapOfSets<String, int>? imapOfSets =
        IMapOfSets.orNull(mapOfSets, ConfigMapOfSets(isDeepEquals: false));
    expect(imapOfSets?.unlock, {
      "a": {1, 2, 3},
      "b": {1},
      "c": {1, 2},
    });
    expect(imapOfSets?.config, ConfigMapOfSets(isDeepEquals: false));
  });

  test("isIdentityEquals", () {
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

  test("config", () {
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

  test("configSet", () {
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

  test("configMap", () {
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
          sort: false,
        ));
  });

  test("add", () {
    // 1) Regular usage
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newSet = iMapOfSets.add("a", 5);
    expect(newSet["a"], ISet({1, 2, 5}));

    // 2) Adding an element
    IMapOfSets<String, int> mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([1]));

    // 3) Adding a second element with the same key
    mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    mapOfSets = mapOfSets.add("a", 2);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([1, 2]));

    // 4) Adding a third, different element
    mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    mapOfSets = mapOfSets.add("a", 2);
    mapOfSets = mapOfSets.add("b", 3);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([1, 2]));
    expect(mapOfSets["b"], ISet<int>([3]));
  });

  test("add | sorted set", () {
    final IMapOfSets<String, int> imapOfSets =
        IMapOfSets.empty<String, int>(ConfigMapOfSets(sortKeys: true))
            .add("z", 100)
            .add("a", 1)
            .add("a", 40)
            .add("c", 3);

    expect(imapOfSets.keys, ["a", "c", "z"]);

    expect(imapOfSets.sets, [
      {40, 1},
      {3},
      {100}
    ]);
  });

  test("addValues | sorted set", () {
    final IMapOfSets<String, int> imapOfSets =
        IMapOfSets.empty<String, int>(ConfigMapOfSets(sortKeys: true))
            .addValues("z", {100}).addValues("a", {1}).addValues("a", {40}).addValues("c", {3});
    expect(imapOfSets.keys, ["a", "c", "z"]);
    expect(imapOfSets.sets, [
      {40, 1},
      {3},
      {100}
    ]);
  });

  test("addValuesToKeys | sorted set", () {
    final IMapOfSets<String, int> imapOfSets =
        IMapOfSets.empty<String, int>(ConfigMapOfSets(sortKeys: true))
            .addValuesToKeys(["z"], {100}).addValuesToKeys(["a"], {1}).addValuesToKeys(
                ["a", "z"], {40}).addValuesToKeys(["c"], {3});
    expect(imapOfSets.keys, ["a", "c", "z"]);
    expect(imapOfSets.sets, [
      {40, 1},
      {3},
      {100, 40}
    ]);
  });

  test("addMap | sorted set", () {
    final IMapOfSets<String, int> imapOfSets =
        IMapOfSets.empty<String, int>(ConfigMapOfSets(sortKeys: true)).addMap({
      "z": {100}
    }).addMap({
      "a": {1}
    }).addMap({
      "a": {40},
      "z": {40}
    }).addMap({
      "c": {3}
    });
    expect(imapOfSets.keys, ["a", "c", "z"]);
    expect(imapOfSets.sets, [
      {40, 1},
      {3},
      {100, 40}
    ]);
  });

  test("addIMap | sorted set", () {
    final IMapOfSets<String, int> imapOfSets =
        IMapOfSets.empty<String, int>(ConfigMapOfSets(sortKeys: true))
            .addIMap(IMap({
              "z": {100}
            }))
            .addIMap(IMap({
              "a": {1}
            }))
            .addIMap(IMap({
              "a": {40},
              "z": {40}
            }))
            .addIMap(IMap({
              "c": {3}
            }));
    expect(imapOfSets.keys, ["a", "c", "z"]);
    expect(imapOfSets.sets, [
      {40, 1},
      {3},
      {100, 40}
    ]);
  });

  test("addEntries | sorted set", () {
    final IMapOfSets<String, int> imapOfSets =
        IMapOfSets.empty<String, int>(ConfigMapOfSets(sortKeys: true)).addEntries([
      MapEntry("z", {100})
    ]).addEntries([
      MapEntry("a", {1})
    ]).addEntries([
      MapEntry("a", {40}),
      MapEntry("z", {40})
    ]).addEntries([
      MapEntry("c", {3})
    ]);
    expect(imapOfSets.keys, ["a", "c", "z"]);
    expect(imapOfSets.sets, [
      {40, 1},
      {3},
      {100, 40}
    ]);
  });

  test("remove", () {
    // 1) Removing an element with an existing key of multiple elements
    IMapOfSets<String, int> mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    mapOfSets = mapOfSets.add("a", 2);
    mapOfSets = mapOfSets.remove("a", 1);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([2]));

    // 2) Removing an element completely
    mapOfSets = IMapOfSets.empty();
    mapOfSets = mapOfSets.add("a", 1);
    mapOfSets = mapOfSets.add("b", 3);
    mapOfSets = mapOfSets.add("a", 2);
    mapOfSets = mapOfSets.remove("b", 3);
    expect(mapOfSets.isEmpty, isFalse);
    expect(mapOfSets.isNotEmpty, isTrue);
    expect(mapOfSets["a"], ISet<int>([1, 2]));
    expect(mapOfSets["b"], isNull);

    // 3) Guaranteeing that we don't remove empty sets if the configuration doesn't say so
    final IMapOfSets<String, int> original = IMapOfSets.withConfig({
      "a": {1},
      "b": {1, 2, 3},
    }, const ConfigMapOfSets(removeEmptySets: false));

    expect(original.remove("a", 1).unlock, {
      "a": <int>{},
      "b": {1, 2, 3}
    });
  });

  test("[]", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets["a"], ISet({1, 2}));
    expect(iMapOfSets["b"], ISet({3}));
  });

  test("entries", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("b", 3).add("a", 1).add("a", 2);
    final ISet<MapEntry<String, ISet<int?>?>> entries = iMapOfSets.entriesAsSet;
    expect(
        entries,
        ISet([
          MapEntry("a", ISet({1, 2})),
          MapEntry("b", ISet({3})),
        ]).withDeepEquals);
  });

  test("entry", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("b", 3).add("a", 1).add("a", 2);

    expect(iMapOfSets.entry("a").key, "a");
    expect(iMapOfSets.entry("a").value, {1, 2});

    expect(iMapOfSets.entry("b").key, "b");
    expect(iMapOfSets.entry("b").value, {3});

    expect(iMapOfSets.entry("z").key, "z");
    expect(iMapOfSets.entry("z").value, null);
  });

  test("entryOrNull", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("b", 3).add("a", 1).add("a", 2);

    expect(iMapOfSets.entryOrNull("a")?.key, "a");
    expect(iMapOfSets.entryOrNull("a")?.value, {1, 2});

    expect(iMapOfSets.entryOrNull("z"), isNull);
  });

  test("keys", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("b", 3).add("a", 1).add("a", 2);
    expect(iMapOfSets.keys, allOf(isA<Iterable<String>>(), ["b", "a"]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: true)).keys,
        allOf(isA<Iterable<String>>(), ["a", "b"]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: false)).keys,
        allOf(isA<Iterable<String>>(), ["b", "a"]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: true)).keyList(),
        allOf(isA<Iterable<String>>(), ["a", "b"]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: false)).keyList(),
        allOf(isA<Iterable<String>>(), ["b", "a"]));
  });

  test("sets", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("b", 3).add("a", 1).add("a", 2);
    expect(iMapOfSets.sets, isA<Iterable<ISet<int>>>());
    expect(iMapOfSets.sets, [
      ISet<int>({3}),
      ISet<int>({1, 2}),
    ]);
  });

  test("values", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("b", 5).add("b", 1).add("a", 3).add("a", 2).add("a", 5);

    expect(
        iMapOfSets,
        {
          "b": {5, 1},
          "a": {3, 2, 5}
        }.lock);

    // ---

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: false, sortValues: false)).values,
        allOf(isA<Iterable<int>>(), [5, 1, 3, 2, 5]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: false, sortValues: true)).values,
        allOf(isA<Iterable<int>>(), [1, 5, 2, 3, 5]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: true, sortValues: false)).values,
        allOf(isA<Iterable<int>>(), [3, 2, 5, 5, 1]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: true, sortValues: true)).values,
        allOf(isA<Iterable<int>>(), [2, 3, 5, 1, 5]));

    // ---

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: false, sortValues: false)).valueList(),
        allOf(isA<Iterable<int>>(), [5, 1, 3, 2, 5]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: false, sortValues: true)).valueList(),
        allOf(isA<Iterable<int>>(), [1, 5, 2, 3, 5]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: true, sortValues: false)).valueList(),
        allOf(isA<Iterable<int>>(), [3, 2, 5, 5, 1]));

    expect(iMapOfSets.withConfig(ConfigMapOfSets(sortKeys: true, sortValues: true)).valueList(),
        allOf(isA<Iterable<int>>(), [2, 3, 5, 1, 5]));
  });

  test("addValues", () {
    // 1) Adding to an existing key
    IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    IMapOfSets<String, int> newMapOfSets = iMapOfSets.addValues("a", [2, 3, 4]);
    expect(newMapOfSets["a"], {1, 2, 3, 4});

    // 2) Adding to a nonexistent key
    iMapOfSets = IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets["z"], isNull);
    newMapOfSets = iMapOfSets.addValues("z", [2, 3, 4]);
    expect(newMapOfSets["z"], {2, 3, 4});

    // 3) Adding to a nonexistent key
    iMapOfSets = IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets["z"], isNull);
    newMapOfSets = iMapOfSets.addValues("z", [2, 3, 4]);
    expect(newMapOfSets["z"], {2, 3, 4});
  });

  test("addValuesToKeys", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> iMapOfSetsResult =
        iMapOfSets.addValuesToKeys(["a", "b", "c"], [4, 5]);

    expect(iMapOfSetsResult["a"], {1, 2, 4, 5});
    expect(iMapOfSetsResult["b"], {3, 4, 5});
    expect(iMapOfSetsResult["c"], {4, 5});
  });

  test("addAll", () {
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

  test("addEntries", () {
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

  test("addIMap", () {
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

  test("replaceSet", () {
    // 1) Adding a new set on a new key
    IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    IMapOfSets<String, int> newSet = iMapOfSets.replaceSet("z", ISet({2, 3, 4}));
    expect(newSet["z"], ISet({2, 3, 4}));

    // 2) Adding a new set on an existing key
    iMapOfSets = IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    newSet = iMapOfSets.replaceSet("a", ISet({100}));
    expect(newSet["a"], ISet({100}));

    // 3) if removeEmptySets is true
    iMapOfSets = IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    newSet = iMapOfSets.replaceSet("b", ISet({}));
    expect(newSet["b"], isNull);

    // 4) if removeEmptySets is false
    iMapOfSets = IMapOfSets.empty<String, int>(const ConfigMapOfSets(removeEmptySets: false))
        .add("a", 1)
        .add("a", 2)
        .add("b", 3);
    newSet = iMapOfSets.replaceSet("b", ISet({}));
    expect(newSet["b"], <int>{});
  });

  test("clearSet", () {
    // 1) nullifies the empty set if removeEmptySets is true
    IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    IMapOfSets<String, int> clearedSet = iMapOfSets.clearSet("a");
    expect(clearedSet["a"], isNull);
    expect(clearedSet["b"], {3});

    // 2) empties set if removeEmptySets is false
    iMapOfSets = IMapOfSets.empty<String, int>(const ConfigMapOfSets(removeEmptySets: false))
        .add("a", 1)
        .add("a", 2)
        .add("b", 3);
    clearedSet = iMapOfSets.clearSet("a");
    expect(clearedSet["a"], <int>{});
    expect(clearedSet["b"], {3});
  });

  test("removeSet", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    final IMapOfSets<String, int> newSet = iMapOfSets.removeSet("a");
    expect(newSet.keys.length, 1);
  });

  test("getOrNull", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.getOrNull("a"), ISet<int>({1, 2}));
    expect(iMapOfSets.getOrNull("b"), ISet<int>({3}));
    expect(iMapOfSets.getOrNull("c"), null);
  });

  test("get", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.get("a"), ISet<int>({1, 2}));
    expect(iMapOfSets.get("b"), ISet<int>({3}));
    expect(iMapOfSets.get("c"), ISet<int>());
  });

  test("containsKey", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.containsKey("a"), isTrue);
    expect(iMapOfSets.containsKey("b"), isTrue);
    expect(iMapOfSets.containsKey("c"), isFalse);
  });

  test("containsValue", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.containsValue(1), isTrue);
    expect(iMapOfSets.containsValue(2), isTrue);
    expect(iMapOfSets.containsValue(3), isTrue);
    expect(iMapOfSets.containsValue(4), isFalse);
  });

  test("contains", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.contains("a", 1), isTrue);
    expect(iMapOfSets.contains("a", 2), isTrue);
    expect(iMapOfSets.contains("b", 3), isTrue);
    expect(iMapOfSets.contains("b", 4), isFalse);
    expect(iMapOfSets.contains("c", 1), isFalse);
  });

  test("keyWithValue", () {
    final IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.getKeyWithValue(1), "a");
    expect(iMapOfSets.getKeyWithValue(2), "a");
    expect(iMapOfSets.getKeyWithValue(3), "b");
    expect(iMapOfSets.getKeyWithValue(4), isNull);
  });

  test("entryWithValue", () {
    final iMapOfSets = {
      "a": {1, 2},
      "b": {3},
      "d": {1}
    }.lock;
    expect(iMapOfSets.getEntryWithValue(1)!.asComparableEntry, Entry("a", ISet<int>({1, 2})));
    expect(iMapOfSets.getEntryWithValue(2)!.asComparableEntry, Entry("a", ISet<int>({1, 2})));
    expect(iMapOfSets.getEntryWithValue(3)!.asComparableEntry, Entry("b", ISet<int>({3})));
    expect(iMapOfSets.getEntryWithValue(4), isNull);
  });

  test("allEntriesWithValue", () {
    ImmutableCollection.prettyPrint = false;
    final iMapOfSets = {
      "a": {1, 2},
      "b": {3},
      "d": {1}
    }.lock;
    expect(iMapOfSets.allEntriesWithValue(1).toString(), "{MapEntry(a: {1, 2}), MapEntry(d: {1})}");
    expect(iMapOfSets.allEntriesWithValue(2).toString(), "{MapEntry(a: {1, 2})}");
    expect(iMapOfSets.allEntriesWithValue(3).toString(), "{MapEntry(b: {3})}");
  });

  test("allKeysWithValue", () {
    final iMapOfSets = {
      "a": {1, 2},
      "b": {3},
      "d": {1}
    }.lock;
    expect(iMapOfSets.allKeysWithValue(1), {"a", "d"});
    expect(iMapOfSets.allKeysWithValue(2), {"a"});
    expect(iMapOfSets.allKeysWithValue(3), {"b"});
  });

  test("toString", () {
    // 1) Global configuration prettyPrint == false
    ImmutableCollection.prettyPrint = false;
    IMapOfSets<String, int> iMapOfSets =
        IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.toString(), "{a: {1, 2}, b: {3}}");

    // 2) Global configuration prettyPrint == true
    ImmutableCollection.prettyPrint = true;
    iMapOfSets = IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(
        iMapOfSets.toString(),
        "{\n"
        "   a: {\n"
        "   1,\n"
        "   2\n"
        "},\n"
        "   b: {3}\n"
        "}");

    // 3) Local prettyPrint == false
    ImmutableCollection.prettyPrint = true;
    iMapOfSets = IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(iMapOfSets.toString(false), "{a: {1, 2}, b: {3}}");

    // 4) Local prettyPrint == true
    ImmutableCollection.prettyPrint = true;
    iMapOfSets = IMapOfSets.empty<String, int>().add("a", 1).add("a", 2).add("b", 3);
    expect(
        iMapOfSets.toString(true),
        "{\n"
        "   a: {\n"
        "   1,\n"
        "   2\n"
        "},\n"
        "   b: {3}\n"
        "}");
  });

  test("flatten", () {
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
      expect(flattenedIMap[i].asComparableEntry.key, correctFlattenedMap[i].asComparableEntry.key);
      expect(
          flattenedIMap[i].asComparableEntry.value, correctFlattenedMap[i].asComparableEntry.value);
    }
  });

  test("entriesAsSet", () {
    ImmutableCollection.prettyPrint = false;
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.entriesAsSet.isDeepEquals, isTrue);
    expect(iMapOfSets.entriesAsSet, isA<ISet<MapEntry<String, ISet<int>>>>());
    expect(iMapOfSets.entriesAsSet.toString(false),
        "{MapEntry(a: {1, 2}), MapEntry(b: {1, 2, 3}), MapEntry(c: {1, 2})}");
  });

  test("keyAsSet", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.keysAsSet.isDeepEquals, isTrue);
    expect(iMapOfSets.keysAsSet, isA<ISet<String>>());
    expect(iMapOfSets.keysAsSet, <String>{"a", "b", "c"});
  });

  test("setAsSet", () {
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

  test("valuesAsSet", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.valuesAsSet.isDeepEquals, isTrue);
    expect(iMapOfSets.valuesAsSet, isA<ISet<int>>());
    expect(iMapOfSets.valuesAsSet, <int>{1, 2, 3});
  });

  test("keysAsList", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });
    expect(iMapOfSets.keysAsList.isDeepEquals, isTrue);
    expect(iMapOfSets.keysAsList, isA<IList<String>>());
    expect(iMapOfSets.keysAsList, <String>["a", "b", "c"]);
  });

  test("setsAsList", () {
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

  test("cast", () {
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

  test("toggle", () {
    // 1) Toggling an existing element
    IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.contains("a", 2), isTrue);

    iMapOfSets = iMapOfSets.toggle("a", 2);
    expect(iMapOfSets.contains("a", 2), isFalse);

    iMapOfSets = iMapOfSets.toggle("a", 2);
    expect(iMapOfSets.contains("a", 2), isTrue);

    // 2) toggling on a nonexistent key
    iMapOfSets = IMapOfSets({
      "a": {1},
      "b": {1, 2, 3},
    });

    expect(iMapOfSets.toggle("c", 10).unlock, {
      "a": {1},
      "b": {1, 2, 3},
      "c": {10}
    });

    // 3) force toggle
    iMapOfSets = IMapOfSets({
      "a": {1},
      "b": {1, 2, 3},
    });

    expect(iMapOfSets.toggle("a", 10, state: true).unlock, {
      "a": {1, 10},
      "b": {1, 2, 3},
    });

    expect(iMapOfSets.toggle("a", 10, state: false).unlock, {
      "a": {1},
      "b": {1, 2, 3},
    });

    expect(iMapOfSets.toggle("a", 1, state: false).unlock, {
      "b": {1, 2, 3},
    });

    expect(iMapOfSets.toggle("c", 10, state: false).unlock, {
      "a": {1},
      "b": {1, 2, 3},
    });

    expect(iMapOfSets.toggle("c", 10, state: true).unlock, {
      "a": {1},
      "b": {1, 2, 3},
      "c": {10},
    });

    // 4) nullifying or emptying the set depending on ConfigMapOfSets.removeEmptySets
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets({
      "a": {1},
      "b": {1, 2, 3},
    });
    final IMapOfSets<String, int?> iMapOfSets2 =
        iMapOfSets1.withConfig(ConfigMapOfSets(removeEmptySets: false));

    expect(iMapOfSets1.toggle("a", 1).unlock, {
      "b": {1, 2, 3},
    });
    expect(iMapOfSets2.toggle("a", 1).unlock, {
      "a": <int>{},
      "b": {1, 2, 3},
    });
  });

  test("length", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.lengthOfKeys, 2);
  });

  test("lengthOfValues", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.lengthOfValues, 5);
  });

  test("lengthOfNonRepeatingValues", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.lengthOfNonRepeatingValues, 3);
  });

  test("unlock", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.unlock, {
      "a": {1, 2},
      "b": {1, 2, 3},
    });
  });

  test("clear", () {
    // 1) If removeEmptySets == true
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    final IMapOfSets<String, int> iMapOfSetsCleared = iMapOfSets.clear();

    expect(iMapOfSetsCleared.unlock, <String, Set<int>>{});

    // 2) If removeEmptySets == false
    final IMapOfSets<String, int?> iMapOfSetsWithoutRemoveEmptySets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    }).withConfig(const ConfigMapOfSets(removeEmptySets: false));
    final IMapOfSets<String, int?> iMapOfSetsClearedButNotRemoved =
        iMapOfSetsWithoutRemoveEmptySets.clear();

    expect(iMapOfSetsClearedButNotRemoved.unlock, {
      "1": <int>{},
      "2": <int>{},
      "3": <int>{},
    });
  });

  test("forEach", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    iMapOfSets.forEach((String key, ISet<int?>? set) => expect(iMapOfSets[key], set));
  });

  test("map", () {
    // 1) Regular usage
    IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    final IMapOfSets<num, num> mappedIMapOfSets = iMapOfSets.map<num, num>(
      (String key, ISet<int> set) =>
          MapEntry<num, ISet<num>>(num.parse(key + key), set.cast<num>().toISet()),
    );

    expect(mappedIMapOfSets, isA<IMapOfSets<num, num>>());
    expect(
        mappedIMapOfSets,
        IMapOfSets<num, num>({
          11: {1, 2, 3},
          22: {4},
          33: {10, 11},
        }));

    // 2) emptying sets vs ConfigMapOfSets.removeEmptySets
    iMapOfSets = IMapOfSets({
      "1": {1, 2, 3}
    });

    MapEntry<num, ISet<num>> mapper(String key, ISet<int?>? set) =>
        MapEntry<num, ISet<num>>(num.parse(key), <int>{}.lock);

    var doRemoveEmptySets = ConfigMapOfSets(removeEmptySets: true);
    var dontRemoveEmptySets = ConfigMapOfSets(removeEmptySets: false);

    expect(
      iMapOfSets.map<num, num>(mapper, config: doRemoveEmptySets).unlock,
      {},
    );

    expect(
      iMapOfSets.map<num, num>(mapper, config: dontRemoveEmptySets).unlock,
      {1: <int>{}},
    );
  });

  test("removeWhere", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    final IMapOfSets<String, int> newIMapOfSets =
        iMapOfSets.removeWhere((String key, ISet<int?>? set) => set!.contains(10));

    expect(
        newIMapOfSets,
        IMapOfSets<String, int>({
          "1": {1, 2, 3},
          "2": {4},
        }));
  });

  test("update", () {
    // 1) Updating an existing key
    IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });

    var previousSet = Output<ISet<int>>();

    IMapOfSets<String, int> newIMapOfSets =
        iMapOfSets.update("1", (ISet<int?>? set) => {100}.lock, previousSet: previousSet);

    expect(
        newIMapOfSets,
        IMapOfSets<String, int>({
          "1": {100},
          "2": {4},
          "3": {10, 11},
        }));

    expect(previousSet.value, {1, 2, 3});

    // 2) Updating a nonexistent key
    iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    newIMapOfSets =
        iMapOfSets.update("4", (ISet<int?>? set) => {100}.lock, ifAbsent: () => {1000}.lock);

    expect(
        newIMapOfSets,
        IMapOfSets<String, int>({
          "1": {1, 2, 3},
          "2": {4},
          "3": {10, 11},
          "4": {1000},
        }));

    // 3) Updating a nonexistent key without ifAbsent returns the original map of sets
    iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    expect(
        () => iMapOfSets.update("4", (ISet<int?>? set) => {100}.lock,
            ifAbsent: (() => throw ArgumentError())),
        throwsArgumentError);

    expect(iMapOfSets.update("4", (ISet<int?>? set) => {100}.lock), iMapOfSets);

    // 4) If updating results in empty sets, they are removed
    iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    expect(
        iMapOfSets.update("2", (ISet<int?>? set) => ISetImpl.empty()),
        {
          "1": {1, 2, 3},
          "3": {10, 11},
        }.lock);

    expect(
        iMapOfSets
            .withConfig(ConfigMapOfSets(removeEmptySets: false))
            .update("2", (ISet<int?>? set) => ISetImpl.empty()),
        {
          "1": {1, 2, 3},
          "2": <int>{},
          "3": {10, 11},
        }.lock.withConfig(const ConfigMapOfSets(removeEmptySets: false)));

    // 5) Sorted map of sets
    iMapOfSets = IMapOfSets.empty<String, int>(ConfigMapOfSets(sortKeys: true))
        .update("z", (ISet<int?>? value) => {0}.lock, ifAbsent: () => {100}.lock)
        .update("a", (ISet<int?>? value) => {0}.lock, ifAbsent: () => {1}.lock)
        .update("a", (ISet<int?>? value) => {40}.lock, ifAbsent: () => {0}.lock)
        .update("c", (ISet<int?>? value) => {0}.lock, ifAbsent: () => {3}.lock);
    expect(iMapOfSets.keys, ["a", "c", "z"]);
    expect(iMapOfSets.sets, [
      {40},
      {3},
      {100}
    ]);
  });

  test("updateAll", () {
    // 1) Regular usage
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });
    final IMapOfSets<String, int> newIMapOfSets =
        iMapOfSets.updateAll((String key, ISet<int?>? set) => {int.parse(key)}.lock);

    expect(
        newIMapOfSets,
        IMapOfSets<String, int>({
          "1": {1},
          "2": {2},
          "3": {3},
        }));

    // 2) emptying sets vs ConfigMapOfSets.removeEmptySets
    // All sets are updated to empty sets. But empty sets are removed.
    expect(
        IMapOfSets({
          "1": {1, 2, 3},
          "2": {4},
          "3": {10, 11},
        })
            .withConfig(ConfigMapOfSets(removeEmptySets: true))
            .updateAll((String key, ISet<int?>? set) => <int>{}.lock),
        IMapOfSets.empty<String, int>());

    // All sets are updated to empty sets. But empty sets are kept.
    expect(
        IMapOfSets({
          "1": {1, 2, 3},
          "2": {4},
          "3": {10, 11},
        })
            .withConfig(ConfigMapOfSets(removeEmptySets: false))
            .updateAll((String key, ISet<int?>? set) => <int>{}.lock)
            .unlock,
        {
          "1": <int>{},
          "2": <int>{},
          "3": <int>{},
        });
  });

  test("invertKeysAndValues", () {
    // 1) regular usage
    expect(
        {
          1: {"a"}
        }.lock.invertKeysAndValues().unlock,
        {
          "a": {1}
        });

    IMapOfSets<String, int> iMapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {5, 1},
      "d": {5, 8},
      "e": {12, 5},
    }.lock;

    expect(iMapOfSets.invertKeysAndValues().unlock, {
      1: {"a", "b", "c"},
      2: {"a", "b"},
      3: {"b"},
      5: {"c", "d", "e"},
      8: {"d"},
      12: {"e"},
    });

    // 2) Invert twice return to normal.
    expect(iMapOfSets.invertKeysAndValues().invertKeysAndValues(), iMapOfSets);

    // 3) with empty sets
    iMapOfSets = IMapOfSets.withConfig({"a": {}}, ConfigMapOfSets(removeEmptySets: false));

    expect(iMapOfSets.invertKeysAndValues(), isEmpty);

    iMapOfSets = IMapOfSets.withConfig({
      "a": <int>{},
      "b": <int>{},
      "c": <int>{1},
      "d": <int>{2},
      "e": <int>{1},
    }, ConfigMapOfSets(removeEmptySets: false));

    expect(iMapOfSets.invertKeysAndValues().unlock, {
      1: {"c", "e"},
      2: {"d"},
    });

    // 4) Sorted map of sets
    final IMapOfSets<int?, String> inverted = {
      "a": {2, 3},
      "b": {1, 2, 3},
      "c": {4},
    }.lock.invertKeysAndValues(ConfigMapOfSets(sortKeys: true));
    expect(inverted.keys, [1, 2, 3, 4]);
    expect(inverted.sets, [
      {"b"},
      {"a", "b"},
      {"a", "b"},
      {"c"}
    ]);
  });

  test("invertKeysAndValuesKeepingNullKeys", () {
    // 1) regular usage

    IMapOfSets<String, int> iMapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {5, 1},
      "d": {5, 8},
      "e": {12, 5},
    }.lock;

    expect(iMapOfSets.invertKeysAndValuesKeepingNullKeys().unlock, {
      1: {"a", "b", "c"},
      2: {"a", "b"},
      3: {"b"},
      5: {"c", "d", "e"},
      8: {"d"},
      12: {"e"},
    });

    // 2) Invert twice return to normal.
    expect(iMapOfSets.invertKeysAndValuesKeepingNullKeys().invertKeysAndValuesKeepingNullKeys(),
        iMapOfSets);

    // 3) with empty sets
    iMapOfSets = IMapOfSets.withConfig({"a": {}}, ConfigMapOfSets(removeEmptySets: false));

    expect(iMapOfSets.unlock, {"a": <int>{}});
    expect(iMapOfSets.invertKeysAndValuesKeepingNullKeys().unlock, {
      null: {"a"}
    });

    iMapOfSets = IMapOfSets.withConfig({
      "a": <int>{},
      "b": <int>{},
      "c": <int>{1},
      "d": <int>{2},
      "e": <int>{1},
    }, ConfigMapOfSets(removeEmptySets: false));

    expect(iMapOfSets.invertKeysAndValuesKeepingNullKeys().unlock, {
      null: {"a", "b"},
      1: {"c", "e"},
      2: {"d"},
    });

    // 4) Sorted map of sets
    final IMapOfSets<int?, String> inverted = {
      "a": {2, 3},
      "b": {1, 2, 3},
      "c": {4},
    }.lock.invertKeysAndValuesKeepingNullKeys(ConfigMapOfSets(sortKeys: true));
    expect(inverted.keys, [1, 2, 3, 4]);
    expect(inverted.sets, [
      {"b"},
      {"a", "b"},
      {"a", "b"},
      {"c"}
    ]);
  });

  test("firstValueWhere", () {
    // 1) Regular usage
    IMapOfSets<String, int> mapOfSets = {
      "a": {1, 2},
      "b": {11, 12},
    }.lock;

    expect(mapOfSets.firstValueWhere((int? value) => value! > 10, orElse: () => 1000), 11);

    // 2) orElse
    mapOfSets = {
      "a": {1, 2},
      "b": {11, 12},
    }.lock;

    expect(mapOfSets.firstValueWhere((int? value) => value! > 100, orElse: () => 1000), 1000);

    // 3) if orElse is not specified
    mapOfSets = {
      "a": {1, 2},
      "b": {11, 12},
    }.lock;

    expect(() => mapOfSets.firstValueWhere((int? value) => value! > 100), throwsStateError);
  });

  test("firstValueWhereOrNull", () {
    // 1) Regular usage
    IMapOfSets<String, int> mapOfSets = {
      "a": {1, 2},
      "b": {11, 12},
    }.lock;

    expect(mapOfSets.firstValueWhereOrNull((int? value) => value! > 10, orElse: () => 1000), 11);

    // 2) orElse
    mapOfSets = {
      "a": {1, 2},
      "b": {11, 12},
    }.lock;

    expect(mapOfSets.firstValueWhereOrNull((int? value) => value! > 100, orElse: () => 1000), 1000);

    // 3) if orElse is not specified
    mapOfSets = {
      "a": {1, 2},
      "b": {11, 12},
    }.lock;

    expect(mapOfSets.firstValueWhereOrNull((int? value) => value! > 100), isNull);
  });

  test("asIMap", () {
    final IMapOfSets<String, int> mapOfSets = {
      "a": {1, 2},
      "b": {11, 12},
    }.lock;

    expect(mapOfSets.asIMap(), isA<IMap<String, ISet<int>>>());
    expect(mapOfSets.asIMap().unlock, {
      "a": {1, 2},
      "b": {11, 12},
    });

    var _ = mapOfSets.asIMap().addAll(IMap<String, ISet<int>>({
          "a": {100, 101}.lock
        }));

    expect(mapOfSets.asIMap().unlock, {
      "a": {1, 2},
      "b": {11, 12},
    });
  });

  test("removeValuesFromKeyWhere", () {
    // 1) Regular usage
    final IMapOfSets<String, int> mapOfSets = {
      "a": {1, 2},
      "b": {11, 12, 13},
    }.lock;

    expect(mapOfSets.removeValuesFromKeyWhere("b", (int? value) => value! > 11).unlock, {
      "a": {1, 2},
      "b": {11},
    });

    // 2) removeEmptySets
    final IMapOfSets<String, int> mapOfSets1 = {
      "a": {1, 2},
      "b": {11, 12, 13},
    }.lock;
    final IMapOfSets<String, int> mapOfSets2 = {
      "a": {1, 2},
      "b": {11, 12, 13},
    }.lock.withConfig(ConfigMapOfSets(removeEmptySets: false));

    expect(mapOfSets1.removeValuesFromKeyWhere("b", (int? value) => value! > 10).unlock, {
      "a": {1, 2},
    });
    expect(mapOfSets2.removeValuesFromKeyWhere("b", (int? value) => value! > 10).unlock, {
      "a": {1, 2},
      "b": <int>{}
    });
  });
}

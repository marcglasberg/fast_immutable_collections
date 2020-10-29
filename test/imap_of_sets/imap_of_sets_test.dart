import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Empty Initialization |", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets.empty(),
        iMapOfSetsFromEmpty = IMapOfSets.empty();

    test("Runtime Type", () {
      expect(iMapOfSets, isA<IMapOfSets<String, int>>());
      expect(iMapOfSetsFromEmpty, isA<IMapOfSets<String, int>>());
    });

    test("Emptiness properties", () {
      expect(iMapOfSets.isEmpty, isTrue);
      expect(iMapOfSetsFromEmpty.isEmpty, isTrue);

      expect(iMapOfSets.isNotEmpty, isFalse);
      expect(iMapOfSetsFromEmpty.isNotEmpty, isFalse);
    });
  });

  group("Equals and Other Comparisons |", () {
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

    test("IMapOfSets.== Operator", () {
      expect(iMapOfSets1 == iMapOfSets2, isTrue);
      expect(iMapOfSets1 == iMapOfSets3, isFalse);
      expect(iMapOfSets1 == iMapOfSets4, isTrue);
      expect(iMapOfSets1 == iMapOfSets2.remove("a", 3), isTrue);
    });

    test("IMapOfSets.same method", () {
      expect(iMapOfSets1.same(iMapOfSets2), isFalse);
      expect(iMapOfSets1.same(iMapOfSets3), isFalse);
      expect(iMapOfSets1.same(iMapOfSets4), isFalse);
      expect(iMapOfSets1.same(iMapOfSets1.remove("a", 3)), isTrue);
    });

    test("IMapOfSets.hashCode method", () {
      expect(iMapOfSets1 == iMapOfSets2, isTrue);
      expect(iMapOfSets1 == iMapOfSets3, isFalse);
      expect(iMapOfSets1 == iMapOfSets4, isTrue);
      expect(iMapOfSets1.hashCode, iMapOfSets2.hashCode);
      expect(iMapOfSets1.hashCode, isNot(iMapOfSets3.hashCode));
      expect(iMapOfSets1.hashCode, iMapOfSets4.hashCode);
    });

    test("IMapOfSets.equalItems method", () => fail("Not implemented yet"));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Ensuring Immutability |", () {
    group("IMapOfSets.add method |", () {
      test("Changing the passed mutable map of sets doesn't change the IMapOfSets", () {
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

      test("Changing the IMapOfSets also doesn't change the original map of sets", () {
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

      test("If the item being passed is a variable, a pointer to it shouldn't exist inside ISet",
          () {
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

      group("IMapOfSets.addSet method |", () {
        test("Changing the passed mutable map of sets doesn't change the immutable map of sets",
            () {
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

        test("Changing the passed immutable map of sets doesn't change the IMapOfSets", () {
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
      });
    });

    group("IMapOfSets.remove method |", () {
      test("Changing the passed mutable map of sets doesn't change the IMapOfSets", () {
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

      test("Removing from the original IMapOfSets doesn't change it", () {
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
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Initializations |", () {
    final Map<String, Set<int>> mapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets(mapOfSets);

    test("From a map of sets", () {
      expect(iMapOfSets1["a"], ISet({1, 2}));
      expect(iMapOfSets1["b"], ISet({1, 2, 3}));
    });

    test("From a map of lists", () {
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
      final IMap<String, ISet<int>> iMap = IMap({
        "a": ISet({1, 2}),
        "b": ISet({1, 2, 3}),
      });
      final IMapOfSets<String, int> iMapOfSets3 = IMapOfSets.from(iMap);
      expect(iMapOfSets3["a"], ISet({1, 2}));
      expect(iMapOfSets3["b"], ISet({1, 2, 3}));
      expect(iMapOfSets3, iMapOfSets1);
    });
  });

//////////////////////////////////////////////////////////////////////////////////////////////////

  group("Config |", () {
    final Map<String, Set<int>> mapOfSets = {
      "a": {1, 2},
      "b": {1, 2, 3},
    };
    final IMapOfSets<String, int> iMapOfSets1 = IMapOfSets(mapOfSets);
    final ConfigMapOfSets configMapOfSets =
        ConfigMapOfSets(isDeepEquals: false, autoSortKeys: false, autoSortValues: false);

    test("IMapOfSets.withConfig factory constructor", () {
      final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets.withConfig(mapOfSets, configMapOfSets);

      expect(iMapOfSets2.config.isDeepEquals, isFalse);
      expect(iMapOfSets2.config.autoSortKeys, isFalse);
      expect(iMapOfSets2.config.autoSortValues, isFalse);
    });

    test("IMapOfSets.withConfig method", () {
      expect(iMapOfSets1.config.isDeepEquals, isTrue);
      expect(iMapOfSets1.config.autoSortKeys, isTrue);
      expect(iMapOfSets1.config.autoSortValues, isTrue);

      final IMapOfSets<String, int> iMapOfSets2 = iMapOfSets1.withConfig(configMapOfSets);

      expect(iMapOfSets2.config.isDeepEquals, isFalse);
      expect(iMapOfSets2.config.autoSortKeys, isFalse);
      expect(iMapOfSets2.config.autoSortValues, isFalse);
    });

    test("IMap.isIdentityEquals getter", () {
      expect(iMapOfSets1.isIdentityEquals, isFalse);
      final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets.withConfig(mapOfSets, configMapOfSets);
      expect(iMapOfSets2.isIdentityEquals, isTrue);
    });

    group("Partial Configuration Checking |", () {
      final IMapOfSets<String, int> iMapOfSets2 = IMapOfSets.withConfig(mapOfSets, configMapOfSets);

      test(
          "IMapOfSets.config getter",
          () => expect(
              iMapOfSets2.config,
              const ConfigMapOfSets(
                isDeepEquals: false,
                autoSortKeys: false,
                autoSortValues: false,
              )));

      test("IMapOfSets.configSet getter", () {
        expect(
            iMapOfSets2.configSet,
            const ConfigSet(
              autoSort: false,
              isDeepEquals: false,
            ));
      });

      test(
          "IMapOfSets.configMap getter",
          () => expect(
              iMapOfSets2.configMap,
              const ConfigMap(
                isDeepEquals: false,
                autoSortKeys: false,
                autoSortValues: false,
              )));
    });
  });

//////////////////////////////////////////////////////////////////////////////////////////////////

  group("Basic Operations and Workflow |", () {
    IMapOfSets<String, int> mapOfSets = IMapOfSets.empty();

    test("Runtime Type", () => expect(mapOfSets, isA<IMapOfSets<String, int>>()));

    test("Emptiness properties", () {
      expect(mapOfSets.isEmpty, isTrue);
      expect(mapOfSets.isNotEmpty, isFalse);
    });

    test("Adding an element", () {
      mapOfSets = mapOfSets.add("a", 1);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets["a"], ISet<int>([1]));
    });

    test("Adding a second element with the same key", () {
      mapOfSets = mapOfSets.add("a", 2);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets["a"], ISet<int>([1, 2]));
    });

    test("Adding a third, different element", () {
      mapOfSets = mapOfSets.add("b", 3);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets["a"], ISet<int>([1, 2]));
      expect(mapOfSets["b"], ISet<int>([3]));
    });

    test("Removing an element with an existing key of multiple elements", () {
      mapOfSets = mapOfSets.remove("a", 1);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets["a"], ISet<int>([2]));
    });

    test("Removing an element completely", () {
      mapOfSets = mapOfSets.remove("b", 3);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets["a"], ISet<int>([2]));
      expect(mapOfSets["b"], isNull);
    });
  });

//////////////////////////////////////////////////////////////////////////////////////////////////

  group("Testing the remaining methods |", () {
    IMapOfSets<String, int> iMapOfSets = IMapOfSets.empty();
    iMapOfSets = iMapOfSets.add("a", 1);
    iMapOfSets = iMapOfSets.add("a", 2);
    iMapOfSets = iMapOfSets.add("b", 3);

    test("IMapOfSets [] operator", () {
      expect(iMapOfSets["a"], ISet({1, 2}));
      expect(iMapOfSets["b"], ISet({3}));
    });

    test("IMapOfSets.entries getter", () {
      final ISet<MapEntry<String, ISet<int>>> entries = iMapOfSets.entriesAsSet;
      expect(
          entries,
          ISet([
            MapEntry("a", ISet({1, 2})),
            MapEntry("b", ISet({3})),
          ]).withDeepEquals);
    });

    test("IMapOfSets.keys getter", () {
      expect(iMapOfSets.keys, isA<Iterable<String>>());
      expect(iMapOfSets.keys, ["a", "b"]);
    });

    test("IMapOfSets.sets getter", () {
      expect(iMapOfSets.sets, isA<Iterable<ISet<int>>>());
      expect(iMapOfSets.sets, [
        ISet<int>({1, 2}),
        ISet<int>({3}),
      ]);
    });

    test("IMapOfSets.values getter", () => expect(iMapOfSets.values, ISet<int>({1, 2, 3})));

    test("IMapOfSets.add method", () {
      final IMapOfSets<String, int> newSet = iMapOfSets.add("a", 5);
      expect(newSet["a"], ISet({1, 2, 5}));
    });

    group("IMapOfSets.addValues method |", () {
      test("Adding to an existing key", () {
        final IMapOfSets<String, int> newMapOfSets = iMapOfSets.addValues("a", [2, 3, 4]);
        expect(newMapOfSets["a"], {1, 2, 3, 4});
      });

      test("Adding to an inexistent key", () {
        expect(iMapOfSets["z"], isNull);
        final IMapOfSets<String, int> newMapOfSets = iMapOfSets.addValues("z", [2, 3, 4]);
        expect(newMapOfSets["z"], {2, 3, 4});
      });
    });

    test("IMapOfSets.addAll method", () {
      final IMapOfSets<String, int> newIMapOfSets = iMapOfSets.addAll({
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

    test("IMapOfSets.addEntries method", () {
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

    test("IMapOfSets.remove method", () {
      final IMapOfSets<String, int> newSet = iMapOfSets.add("a", 2);
      expect(newSet["a"], ISet({1, 2}));
    });

    group("IMapOfSets.addSet method |", () {
      test("Adding a new set on a new key", () {
        final IMapOfSets<String, int> newSet = iMapOfSets.replaceSet("z", ISet({2, 3, 4}));
        expect(newSet["z"], ISet({2, 3, 4}));
      });

      test("Adding a new set on an existing key", () {
        final IMapOfSets<String, int> newSet = iMapOfSets.replaceSet("a", ISet({100}));
        expect(newSet["a"], ISet({100}));
      });
    });

    test("IMapOfSets.removeSet method", () {
      final IMapOfSets<String, int> newSet = iMapOfSets.removeSet("a");
      expect(newSet.keys.length, 1);
    });

    // TODO: Marcelo, o nome da função é getOrNull mas ela nunca retorna null?
    //Pelo menos é isso que está escrito na documentação...
    test("IMapOfSets.getOrNull method", () {
      expect(iMapOfSets.getOrNull("a"), ISet<int>({1, 2}));
      expect(iMapOfSets.getOrNull("b"), ISet<int>({3}));
      expect(iMapOfSets.getOrNull("c"), null);
    });

    test("IMapOfSets.get method", () {
      expect(iMapOfSets.get("a"), ISet<int>({1, 2}));
      expect(iMapOfSets.get("b"), ISet<int>({3}));
      expect(iMapOfSets.get("c"), ISet<int>());
    });

    test("IMapOfSets.containsKey method", () {
      expect(iMapOfSets.containsKey("a"), isTrue);
      expect(iMapOfSets.containsKey("b"), isTrue);
      expect(iMapOfSets.containsKey("c"), isFalse);
    });

    test("IMapOfSets.containsValue method", () {
      expect(iMapOfSets.containsValue(1), isTrue);
      expect(iMapOfSets.containsValue(2), isTrue);
      expect(iMapOfSets.containsValue(3), isTrue);
      expect(iMapOfSets.containsValue(4), isFalse);
    });

    test("IMapOfSets.contains method", () {
      expect(iMapOfSets.contains("a", 1), isTrue);
      expect(iMapOfSets.contains("a", 2), isTrue);
      expect(iMapOfSets.contains("b", 3), isTrue);
      expect(iMapOfSets.contains("b", 4), isFalse);
      expect(iMapOfSets.contains("c", 1), isFalse);
    });

    test("IMapOfSets.keyWithValue method", () {
      expect(iMapOfSets.keyWithValue(1), "a");
      expect(iMapOfSets.keyWithValue(2), "a");
      expect(iMapOfSets.keyWithValue(3), "b");
      expect(iMapOfSets.keyWithValue(4), isNull);
    });

    group("IMapOfSets.withValue family |", () {
      final IMapOfSets<String, int> newIMapOfSets = iMapOfSets.add("d", 1);

      test("IMapOfSets.entryWithValue method", () {
        expect(newIMapOfSets.entryWithValue(1).entry, Entry("a", ISet<int>({1, 2})));
        expect(newIMapOfSets.entryWithValue(2).entry, Entry("a", ISet<int>({1, 2})));
        expect(newIMapOfSets.entryWithValue(3).entry, Entry("b", ISet<int>({3})));
        expect(newIMapOfSets.entryWithValue(4), isNull);
      });

      test("IMapOfSets.allEntriesWithValue method", () {
        expect(newIMapOfSets.allEntriesWithValue(1).toString(),
            "{MapEntry(a: {1, 2}), MapEntry(d: {1})}");
        expect(newIMapOfSets.allEntriesWithValue(2).toString(), "{MapEntry(a: {1, 2})}");
        expect(newIMapOfSets.allEntriesWithValue(3).toString(), "{MapEntry(b: {3})}");
      });

      test("IMapOfSets.allKeysWithValue method", () {
        expect(newIMapOfSets.allKeysWithValue(1), {"a", "d"});
        expect(newIMapOfSets.allKeysWithValue(2), {"a"});
        expect(newIMapOfSets.allKeysWithValue(3), {"b"});
      });
    });

    test("IMapOfSets.toString method", () => expect(iMapOfSets.toString(), "{a: {1, 2}, b: {3}}"));
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
      expect(flattenedIMap[i].entry.key, correctFlattenedMap[i].entry.key);
      expect(flattenedIMap[i].entry.value, correctFlattenedMap[i].entry.value);
    }
  });

  group(".as family of methods |", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
      "c": {1, 2},
    });

    test("IMapOfSets.entriesAsSet getter method", () {
      expect(iMapOfSets.entriesAsSet.isDeepEquals, isTrue);
      expect(iMapOfSets.entriesAsSet, isA<ISet<MapEntry<String, ISet<int>>>>());
      expect(iMapOfSets.entriesAsSet.toString(),
          "{MapEntry(a: {1, 2}), MapEntry(b: {1, 2, 3}), MapEntry(c: {1, 2})}");
    });

    test("IMapOfSets.keyAsSet method", () {
      expect(iMapOfSets.keysAsSet.isDeepEquals, isTrue);
      expect(iMapOfSets.keysAsSet, isA<ISet<String>>());
      expect(iMapOfSets.keysAsSet, <String>{"a", "b", "c"});
    });

    test("IMapOfSets.keyAsSet method", () {
      expect(iMapOfSets.setsAsSet.isDeepEquals, isTrue);
      expect(iMapOfSets.setsAsSet, isA<ISet<ISet<int>>>());
      expect(iMapOfSets.setsAsSet, <Set<int>>{
        {1, 2},
        {1, 2, 3},
      });
    });

    test("IMapOfSets.valuesAsSet method", () {
      expect(iMapOfSets.valuesAsSet.isDeepEquals, isTrue);
      expect(iMapOfSets.valuesAsSet, isA<ISet<int>>());
      expect(iMapOfSets.valuesAsSet, <int>{1, 2, 3});
    });

    test("IMapOfSets.keysAsList method", () {
      expect(iMapOfSets.keysAsList.isDeepEquals, isTrue);
      expect(iMapOfSets.keysAsList, isA<IList<String>>());
      expect(iMapOfSets.keysAsList, <String>["a", "b", "c"]);
    });

    test("IMapOfSets.setsAsList method", () {
      expect(iMapOfSets.setsAsList.isDeepEquals, isTrue);
      expect(iMapOfSets.setsAsList, isA<IList<ISet<int>>>());
      expect(iMapOfSets.setsAsList, <Set<int>>[
        {1, 2},
        {1, 2, 3},
        {1, 2},
      ]);
    });

    test("IMapOfSets.cast method", () {
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
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets.toggle method", () {
    //
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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Length |", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });

    test("IMapofSets.length getter", () => expect(iMapOfSets.lengthOfKeys, 2));

    test("IMapofSets.lengthOfValues getter", () => expect(iMapOfSets.lengthOfValues, 5));

    test("IMapofSets.lengthOfNonRepeatingValues getter",
        () => expect(iMapOfSets.lengthOfNonRepeatingValues, 3));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets.unlock getter", () {
    //
    IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "a": {1, 2},
      "b": {1, 2, 3},
    });
    expect(iMapOfSets.unlock, {
      "a": {1, 2},
      "b": {1, 2, 3},
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Other Methods |", () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets({
      "1": {1, 2, 3},
      "2": {4},
      "3": {10, 11},
    });

    test("IMapOfSets.clear method", () {
      final IMapOfSets<String, int> iMapOfSetsCleared = iMapOfSets.clear();

      // TODO: Marcelo, Ao que parece `.empty` leva a uma chamada sobre em `IMapOfSets.from` com
      // `mapOfSets` como `null`. Para resolver isso, eu adicionei um `?.` no `mapOfSets.map`.
      expect(iMapOfSetsCleared, IMapOfSets.empty<String, int>());
      expect(iMapOfSetsCleared.unlock, <String, Set<int>>{});
    });

    test("IMapOfSets.forEach method",
        () => iMapOfSets.forEach((String key, ISet<int> set) => expect(iMapOfSets[key], set)));

    test("IMapOfSets.map method", () {
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

    test("IMapOfSets.removeWhere method", () {
      final IMapOfSets<String, int> newIMapOfSets =
          iMapOfSets.removeWhere((String key, ISet<int> set) => set.contains(10));

      expect(
          newIMapOfSets,
          IMapOfSets<String, int>({
            "1": {1, 2, 3},
            "2": {4},
          }));
    });

    group("IMapOfSets.update method |", () {
      test("Updating an existing key", () {
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

      test("Updating an inexistent key", () {
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

      test(
          "Updating an inexistent key without ifAbsent yields an error",
          () => expect(
              () => iMapOfSets.update("4", (ISet<int> set) => {100}.lock), throwsUnsupportedError));
    });

    test("IMapOfSets.updateAll method", () {
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
  });
}

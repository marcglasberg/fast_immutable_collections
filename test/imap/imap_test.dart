import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Creating immutable maps |", () {
    final IMap iMap1 = IMap(), iMap2 = IMap({});
    final iMap3 = IMap<String, int>({});
    final iMap4 = IMap({"a": 1});
    final iMap5 = IMap.empty<String, int>();

    test("Runtime Type", () {
      expect(iMap1, isA<IMap>());
      expect(iMap2, isA<IMap>());
      expect(iMap3, isA<IMap<String, int>>());
      expect(iMap4, isA<IMap<String, int>>());
      expect(iMap5, isA<IMap<String, int>>());
    });

    test("Emptiness Properties", () {
      expect(iMap1.isEmpty, isTrue);
      expect(iMap2.isEmpty, isTrue);
      expect(iMap3.isEmpty, isTrue);
      expect(iMap4.isEmpty, isFalse);
      expect(iMap5.isEmpty, isTrue);

      expect(iMap1.isNotEmpty, isFalse);
      expect(iMap2.isNotEmpty, isFalse);
      expect(iMap3.isNotEmpty, isFalse);
      expect(iMap4.isNotEmpty, isTrue);
      expect(iMap5.isNotEmpty, isFalse);
    });

    test("IMap.unlock getter", () {
      final Map<String, int> map = {'a': 1, 'b': 2};
      final IMap<String, int> iMap = IMap(map);
      expect(iMap.unlock, map);
      expect(identical(iMap.unlock, map), isFalse);
    });

    test("IMap.fromEntries factory contructor", () {
      const List<MapEntry<String, int>> entries = [
        MapEntry<String, int>('a', 1),
        MapEntry<String, int>('b', 2),
      ];
      final IMap<String, int> fromEntries = IMap.fromEntries(entries);

      expect(fromEntries['a'], 1);
      expect(fromEntries['b'], 2);
    });

    test("IMap.fromKeys factory constructor", () {
      const List<String> keys = ['a', 'b'];
      final IMap<String, int> fromKeys =
          IMap.fromKeys(keys: keys, valueMapper: (String key) => key.hashCode);

      expect(fromKeys['a'], 'a'.hashCode);
      expect(fromKeys['b'], 'b'.hashCode);
    });

    test("IMap.fromValues factory constructor", () {
      const List<int> values = [1, 2];
      final IMap<String, int> fromKeys =
          IMap.fromValues(values: values, keyMapper: (int value) => value.toString());

      expect(fromKeys['1'], 1);
      expect(fromKeys['2'], 2);
    });

    test("IMap.fromIterable factory constructor", () {
      const Iterable<int> iterable = [1, 2];
      final IMap fromIterable = IMap.fromIterable(iterable,
          keyMapper: (key) => (key + 1).toString(), valueMapper: (value) => value + 2);

      expect(fromIterable['2'], 3);
      expect(fromIterable['3'], 4);
    });

    test("IMap.fromIterables factory constructor", () {
      const Iterable<String> keys = ['a', 'b'];
      const Iterable<int> values = [1, 2];
      final IMap<String, int> fromIterables = IMap.fromIterables(keys, values);

      expect(fromIterables['a'], 1);
      expect(fromIterables['b'], 2);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Equals |", () {
    //

    test(
        "IMap with identity-equals compares the map instance, "
        "not the items.", () {
      var myMap = IMap({"a": 1, "b": 2}).identityEquals;
      expect(myMap == myMap, isTrue);
      expect(myMap == IMap({"a": 1, "b": 2}).identityEquals, isFalse);
      expect(myMap == {"a": 1, "b": 2}.lock.identityEquals, isFalse);
      expect(myMap == IMap({"a": 1, "b": 2, "c": 3}).identityEquals, isFalse);
    });

    test("IMap with deep-equals compares the items, not the map instance.", () {
      var myMap = IMap({"a": 1, "b": 2}).deepEquals;
      expect(myMap == myMap, isTrue);
      expect(myMap == IMap({"a": 1, "b": 2}).deepEquals, isTrue);
      expect(myMap == {"a": 1, "b": 2}.lock.deepEquals, isTrue);
      expect(myMap == IMap({"a": 1, "b": 2, "c": 3}).deepEquals, isFalse);

      myMap = IMap({"a": 1, "b": 2});
      expect(myMap == myMap, isTrue);
      expect(myMap == IMap({"a": 1, "b": 2}), isTrue);
      expect(myMap == IMap({"a": 1, "b": 2, "c": 3}), isFalse);
    });

    test(
        "IMap with deep-equals is always different "
        "from iMap with identity-equals.", () {
      expect(IMap({"a": 1, "b": 2}).deepEquals == IMap({"a": 1, "b": 2}).identityEquals, isFalse);
      expect(IMap({"a": 1, "b": 2}).identityEquals == IMap({"a": 1, "b": 2}).deepEquals, isFalse);
      expect(IMap({"a": 1, "b": 2}).identityEquals == IMap({"a": 1, "b": 2}), isFalse);
      expect(IMap({"a": 1, "b": 2}) == IMap({"a": 1, "b": 2}).identityEquals, isFalse);
    });

    test("IMap.hashCode getter", () {
      final IMap<String, int> iMap = IMap({'a': 1, 'b': 2});

      expect(iMap.hashCode, 815238405);

      final IMap<String, int> iMapWithIdentityEquals = iMap.identityEquals;

      expect(iMapWithIdentityEquals.hashCode, isNot(815238405));
    });

    test("IMap.config method", () {
      final IMap<String, int> iMap = IMap({'a': 1, 'b': 2});

      expect(iMap.compareKey, isNull);
      expect(iMap.compareValue, isNull);
      expect(iMap.isDeepEquals, isTrue);

      final IMap<String, int> iMapWithCompare = iMap.config(
        compareKey: (String key1, String key2) => null,
        compareValue: (int value1, int value2) => null,
      );

      expect(iMapWithCompare.compareKey, isNotNull);
      expect(iMapWithCompare.compareValue, isNotNull);
      expect(iMapWithCompare.isDeepEquals, isTrue);
    });

    // TODO: Marcelo, por favor, revise.
    test("IMap.same method", () {
      final IMap<String, int> iMap1 = IMap({'a': 1, 'b': 2}),
          iMap2 = IMap({'a': 1, 'b': 2}),
          iMap3 = IMap({'a': 1}),
          iMap4 = IMap({'a': 1, 'b': 2}).identityEquals;
      expect(iMap1.same(iMap1), isTrue);
      expect(iMap1.same(iMap2), isFalse);
      expect(iMap1.same(iMap3), isFalse);
      expect(iMap1.same(iMap4), isFalse);
    });

    test("IMap.equals method", () {
      final IMap<String, int> iMap1 = IMap({'a': 1, 'b': 2}),
          iMap2 = IMap({'a': 1, 'b': 2}),
          iMap3 = IMap({'a': 1}),
          iMap4 = IMap({'a': 1, 'b': 2}).identityEquals;
      expect(iMap1.same(iMap1), isTrue);
      expect(iMap1.same(iMap2), isTrue);
      expect(iMap1.same(iMap3), isFalse);
      expect(iMap1.same(iMap4), isFalse);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Creating immutable maps with extensions |", () {
    test("From an empty map", () {
      final IMap iMap = {}.lock;
      expect(iMap, isA<IMap>());
      expect(iMap.isEmpty, isTrue);
      expect(iMap.isNotEmpty, isFalse);
    });

    test("From a map with one item", () {
      final IMap iMap = {"a": 1}.lock;
      expect(iMap, isA<IMap<String, int>>());
      expect(iMap.isEmpty, isFalse);
      expect(iMap.isNotEmpty, isTrue);
    });

    test("From a map with null key, or value, or both", () {
      IMap<String, int> iMap = {null: 1}.lock;
      expect(iMap, isA<IMap<String, int>>());
      expect(iMap.isEmpty, isFalse);
      expect(iMap.isNotEmpty, isTrue);

      iMap = {"a": null}.lock;
      expect(iMap, isA<IMap<String, int>>());
      expect(iMap.isEmpty, isFalse);
      expect(iMap.isNotEmpty, isTrue);

      iMap = {null: null}.lock;
      expect(iMap, isA<IMap<String, int>>());
      expect(iMap.isEmpty, isFalse);
      expect(iMap.isNotEmpty, isTrue);
    });

    test("From an empty map typed with String", () {
      final iMap = <String, int>{}.lock;
      expect(iMap, isA<IMap<String, int>>());
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Creating native mutable maps from immutable maps |", () {
    final Map<String, int> map = {"a": 1, "b": 2, "c": 3};

    test("From the default factory constructor", () {
      final IMap<String, int> imap = IMap(map);

      expect(imap.unlock, map);
      expect(identical(imap.unlock, map), isFalse);
    });

    test("From lock", () {
      final IMap<String, int> iMap = map.lock;

      expect(iMap.unlock, map);
      expect(identical(iMap.unlock, map), isFalse);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("IMap add, addAll and remove methods |", () {
    test("IMap.add and IMap.addAll methods", () {
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

    //////////////////////////////////////////////////////////////////////////////////////////////////

    test("IMap.remove method", () {
      final IMap<String, int> imap1 = {"a": 1, "b": 2, "c": 3}.lock;

      final IMap<String, int> imap2 = imap1.remove("b");
      expect(imap2.unlock, {"a": 1, "c": 3});
      expect(identical(imap1, imap2), isFalse);

      final IMap<String, int> imap3 = imap2.remove("x");
      expect(imap3.unlock, {"a": 1, "c": 3});
      expect(identical(imap2, imap3), isTrue);

      final IMap<String, int> imap4 = imap3.remove("a");
      expect(imap4.unlock, {"c": 3});
      expect(identical(imap3, imap4), isTrue);

      final IMap<String, int> imap5 = imap4.remove("c");
      expect(imap5.unlock, {});
      expect(identical(imap4, imap5), isTrue);

      final IMap<String, int> imap6 = imap5.remove("y");
      expect(imap6.unlock, {});
      expect(identical(imap5, imap6), isTrue);
    });

    group("Making sure adding repeated elements doesn't repeat keys |", () {
      final IMap<String, int> iMap = IMap.empty<String, int>().deepEquals;

      test("Empty equals", () {
        expect(iMap, IMap.empty<String, int>().deepEquals);
      });

      test("Adding the same key overwrites it.", () {
        IMap<String, int> newMap = iMap.add("a", 1);
        newMap = newMap.add("b", 2);
        newMap = newMap.add("a", 3);
        newMap = newMap.add("a", 4);
        expect(newMap, {"a": 4, "b": 2}.lock.deepEquals);
      });
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  // //////////////////////////////////////////////////////////////////////////////////////////////////
  //
  group("IMap methods from Map |", () {
    final IMap<String, int> iMap =
        {"a": 1, "b": 2, "c": 3}.lock.add("d", 4).addAll(IMap({"e": 5, "f": 6}));
    final List<String> keys = ['a', 'b', 'c', 'd', 'e', 'f'];
    final List<int> values = [1, 2, 3, 4, 5, 6];
    final Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6};

    group("Keys, Values and Entries |", () {
      test(
          "IMap.entries getter",
          () => iMap.entries
              .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value)));

      test("IMap.keys getter", () => expect(iMap.keys.toSet(), keys.toSet()));

      test("IMap.values getter", () => expect(iMap.values.toSet(), values.toSet()));

      test("IMap.entryList getter", () {
        expect(iMap.entryList, isA<IList<MapEntry<String, int>>>());
        iMap.entryList
            .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
      });

      test("IMap.entrySet getter", () {
        expect(iMap.entrySet, isA<ISet<MapEntry<String, int>>>());
        iMap.entrySet
            .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
      });

      test("IMap.keyList getter", () {
        expect(iMap.keyList, isA<IList<String>>());
        iMap.keyList.forEach((String key) => expect(keys.contains(key), isTrue));
      });

      test("IMap.keySet getter", () {
        expect(iMap.keySet, isA<ISet<String>>());
        iMap.keySet.forEach((String key) => expect(keys.contains(key), isTrue));
      });

      test("IMap.valueList getter", () {
        expect(iMap.valueList, isA<IList<int>>());
        iMap.valueList.forEach((int value) => expect(values.contains(value), isTrue));
      });

      test("IMap.valueSet getter", () {
        fail("Apparently, not implemented yet.");
      });
    });

    test("IMap.iterator getter", () {
      final Iterator<MapEntry<String, int>> iterator = iMap.iterator;

      expect(iterator.current, isNull);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current.key, 'a');
      expect(iterator.current.value, 1);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current.key, 'b');
      expect(iterator.current.value, 2);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current.key, 'c');
      expect(iterator.current.value, 3);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current.key, 'd');
      expect(iterator.current.value, 4);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current.key, 'e');
      expect(iterator.current.value, 5);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current.key, 'f');
      expect(iterator.current.value, 6);
      expect(iterator.moveNext(), isFalse);
      expect(iterator.current, isNull);
    });

    test("IMap.any method", () {
      expect(iMap.any((String k, int v) => v == 4), isTrue);
      expect(iMap.any((String k, int v) => k == "f"), isTrue);
      expect(iMap.any((String k, int v) => v == 100), isFalse);
      expect(iMap.any((String k, int v) => k == "z"), isFalse);
    });

    test("IMap.anyEntry method", () {
      expect(iMap.anyEntry((MapEntry<String, int> entry) => entry.value == 4), isTrue);
      expect(iMap.anyEntry((MapEntry<String, int> entry) => entry.key == 'f'), isTrue);
      expect(iMap.anyEntry((MapEntry<String, int> entry) => entry.value == 100), isFalse);
      expect(iMap.anyEntry((MapEntry<String, int> entry) => entry.key == 'z'), isFalse);
    });

    test("IMap.cast method", () => expect(iMap.cast<String, num>(), isA<IMap<String, num>>()));

    test("IMap [] operator", () {
      expect(iMap['a'], 1);
      expect(iMap['z'], isNull);
    });

    group("IMap Contains Family |", () {
      test("IMap.contains method", () {
        expect(iMap.contains("a", 1), isTrue);
        expect(iMap.contains("b", 2), isTrue);
        expect(iMap.contains("c", 3), isTrue);
        expect(iMap.contains("z", 100), isFalse);
      });

      test("IMap.containsKey method", () {
        expect(iMap.containsKey('a'), isTrue);
        expect(iMap.containsKey('z'), isFalse);
      });

      test("IMap.containsValue method", () {
        expect(iMap.containsValue(1), isTrue);
        expect(iMap.containsValue(100), isFalse);
      });

      test("IMap.containsEntry method", () {
        expect(iMap.containsEntry(MapEntry<String, int>('a', 1)), isTrue);
        expect(iMap.containsEntry(MapEntry<String, int>('a', 2)), isFalse);
        expect(iMap.containsEntry(MapEntry<String, int>('b', 1)), isFalse);
        expect(iMap.containsEntry(MapEntry<String, int>('z', 100)), isFalse);
      });
    });

    group("IMap to List/Set Family |", () {
      test("IMap.toList method", () {
        expect(iMap.toList(), isA<List<MapEntry<String, int>>>());
        iMap
            .toList()
            .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
      });

      test("IMap.toIList method", () {
        expect(iMap.toIList(), isA<IList<MapEntry<String, int>>>());
        iMap
            .toIList()
            .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
      });

      test("IMap.toISet method", () {
        expect(iMap.toISet(), isA<ISet<MapEntry<String, int>>>());
        iMap
            .toISet()
            .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
      });

      test("IMap.toKeySet method", () {
        expect(iMap.toKeySet(), isA<Set<String>>());
        expect(iMap.toKeySet(), keys.toSet());
      });

      test("IMap.toValueSet method", () {
        expect(iMap.toValueSet(), isA<Set<int>>());
        expect(iMap.toValueSet(), values.toSet());
      });

      test("IMap.toKeyISet method", () {
        expect(iMap.toKeyISet(), isA<ISet<String>>());
        expect(iMap.toKeyISet(), keys.toSet());
      });

      test("IMap.toValueISet method", () {
        expect(iMap.toValueISet(), isA<ISet<int>>());
        expect(iMap.toValueISet(), values.toSet());
      });
    });

    test("IMap.length method", () => expect(iMap.length, 6));

    test("IMap.forEach method", () {
      int result = 100;
      iMap.forEach((String k, int v) => result *= 1 + v);
      expect(result, 504000);
    });

    group("IMap.map method |", () {
      test("Simple Example", () {
        final IMap<String, int> example =
            {"a": 1, "b": 2, "c": 3}.lock.map<String, int>((String k, int v) => MapEntry(k, v + 1));

        expect(example.unlock, <String, int>{"a": 2, "b": 3, "c": 4});
      });

      test("Directly from the IMap above", () {
        expect(iMap.map<String, int>((String k, int v) => MapEntry(k, v + 1)).unlock,
            {"a": 2, "b": 3, "c": 4, "d": 5, "e": 6, "f": 7});
      });
    });

    test("IMap.where method", () {
      expect(iMap.where((String k, int v) => v < 0).unlock, <String, int>{});
      expect(iMap.where((String k, int v) => k == "a" || k == "b").unlock,
          <String, int>{"a": 1, "b": 2});
      expect(iMap.where((String k, int v) => v < 5).unlock,
          <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
      expect(iMap.where((String k, int v) => v < 100).unlock,
          <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6});
    });

    test("toString", () {
      expect(iMap.toString(), "a: 1, b: 2, c: 3, d: 4, e: 5, f: 6");
    });
  });

  // //////////////////////////////////////////////////////////////////////////////////////////////////
}

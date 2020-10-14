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

    test("IMap.fromEntries factory constructor", () {
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

  group("Equals and Other Comparisons |", () {
    group("Equals Operator |", () {
      test(
          "IMap with identity-equals compares the map instance, "
          "not the items.", () {
        var myMap = IMap({"a": 1, "b": 2}).withIdentityEquals;
        expect(myMap == myMap, isTrue);
        expect(myMap == IMap({"a": 1, "b": 2}).withIdentityEquals, isFalse);
        expect(myMap == {"a": 1, "b": 2}.lock.withIdentityEquals, isFalse);
        expect(myMap == IMap({"a": 1, "b": 2, "c": 3}).withIdentityEquals, isFalse);
      });

      test("IMap with deep-equals compares the items, not the map instance.", () {
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
          "IMap with deep-equals is always different "
          "from iMap with identity-equals.", () {
        expect(IMap({"a": 1, "b": 2}).withDeepEquals == IMap({"a": 1, "b": 2}).withIdentityEquals,
            isFalse);
        expect(IMap({"a": 1, "b": 2}).withIdentityEquals == IMap({"a": 1, "b": 2}).withDeepEquals,
            isFalse);
        expect(IMap({"a": 1, "b": 2}).withIdentityEquals == IMap({"a": 1, "b": 2}), isFalse);
        expect(IMap({"a": 1, "b": 2}) == IMap({"a": 1, "b": 2}).withIdentityEquals, isFalse);
      });
    });

    group("Other Comparisons |", () {
      test("IMap.isIdentityEquals and IMap.isDeepEquals properties", () {
        final IMap<String, int> iMap1 = IMap({'a': 1, 'b': 2}),
            iMap2 = IMap({'a': 1, 'b': 2}).withIdentityEquals;

        expect(iMap1.isIdentityEquals, isFalse);
        expect(iMap1.isDeepEquals, isTrue);
        expect(iMap2.isIdentityEquals, isTrue);
        expect(iMap2.isDeepEquals, isFalse);
      });

      group("Same, Equals and the == Operator |", () {
        final IMap<String, int> iMap1 = IMap({'a': 1, 'b': 2}),
            iMap2 = IMap({'a': 1, 'b': 2}),
            iMap3 = IMap({'a': 1}),
            iMap4 = IMap({'b': 2}).add('a', 1),
            iMap5 = IMap({'a': 1, 'b': 2}).withIdentityEquals;

        test("IMap.same method", () {
          expect(iMap1.same(iMap1), isTrue);
          expect(iMap1.same(iMap2), isFalse);
          expect(iMap1.same(iMap3), isFalse);
          expect(iMap1.same(iMap4), isFalse);
          expect(iMap1.same(iMap5), isFalse);
          expect(iMap1.same(iMap1.remove('c')), isTrue);
        });

        test("IMap.equalItemsAndConfig method", () {
          expect(iMap1.equalItemsAndConfig(iMap1), isTrue);
          expect(iMap1.equalItemsAndConfig(iMap2), isTrue);
          expect(iMap1.equalItemsAndConfig(iMap3), isFalse);
          expect(iMap1.equalItemsAndConfig(iMap4), isTrue);
          expect(iMap1.equalItemsAndConfig(iMap5), isFalse);
          expect(iMap1.equalItemsAndConfig(iMap1.remove('c')), isTrue);
        });

        group("IMap.equalItems method |", () {
          test("Not yet done", () => fail('Not implemented yet.'));
        });
      });
    });

    group("IMap.hashCode method", () {
      final IMap<String, int> iMap1 = IMap({'a': 1, 'b': 2}),
        iMap2 = IMap({'a': 1, 'b': 2}),
        iMap3 = IMap({'a': 1, 'b': 2, 'c': 3}),
        iMap4 = IMap({'b': 2}).add('a', 1);
      final IMap<String, int> iMap1WithIdentity = iMap1.withIdentityEquals,
      iMap2WithIdentity = iMap2.withIdentityEquals,
      iMap3WithIdentity = iMap3.withIdentityEquals,
      iMap4WithIdentity = iMap4.withIdentityEquals;

      test("deepEquals vs deepEquals", () {
        expect(iMap1 == iMap2, isTrue);
        expect(iMap1 == iMap3, isFalse);
        expect(iMap1 == iMap4, isTrue);
        expect(iMap1.hashCode, iMap2.hashCode);
        expect(iMap1.hashCode, isNot(iMap3.hashCode));
        expect(iMap1.hashCode, iMap4.hashCode);
      });

      test("identityEquals vs identityEquals", () {
        expect(iMap1WithIdentity == iMap2WithIdentity, isFalse);
        expect(iMap1WithIdentity == iMap3WithIdentity, isFalse);
        expect(iMap1WithIdentity == iMap4WithIdentity, isFalse);
        expect(iMap1WithIdentity.hashCode, isNot(iMap2WithIdentity.hashCode));
        expect(iMap1WithIdentity.hashCode, isNot(iMap3WithIdentity.hashCode));
        expect(iMap1WithIdentity.hashCode, isNot(iMap4WithIdentity.hashCode));
      });

      test("deepEquals vs identityEquals", () {
        expect(iMap1 == iMap1WithIdentity, isFalse);
        expect(iMap2 == iMap2WithIdentity, isFalse);
        expect(iMap3 == iMap3WithIdentity, isFalse);
        expect(iMap4 == iMap4WithIdentity, isFalse);
        expect(iMap1.hashCode, isNot(iMap1WithIdentity.hashCode));
        expect(iMap2.hashCode, isNot(iMap2WithIdentity.hashCode));
        expect(iMap3.hashCode, isNot(iMap3WithIdentity.hashCode));
        expect(iMap4.hashCode, isNot(iMap4WithIdentity.hashCode));
      });
    });

    test("IMap.config method", () {
      final IMap<String, int> iMap = IMap({'a': 1, 'b': 2});

      expect(iMap.isDeepEquals, isTrue);
      expect(iMap.config.autoSortKeys, isTrue);
      expect(iMap.config.autoSortValues, isTrue);

      final IMap<String, int> iMapWithCompare = iMap.withConfig(iMap.config.copyWith(
        autoSortKeys: false,
        autoSortValues: false,
      ));

      expect(iMapWithCompare.isDeepEquals, isTrue);
      expect(iMapWithCompare.config.autoSortKeys, isFalse);
      expect(iMapWithCompare.config.autoSortValues, isFalse);
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
    // TODO: Marcelo, até aqui, somente comparações entre `iMap.unlock` e `map` são válidas, devido
    // à ordem dos elementos. Você gostaria que comparações entre `iMap` e `map` também fossem
    // válidas?
    test("IMap.add method", () {
      final IMap<String, int> iMap = {'a': 1, 'b': 2}.lock;
      final IMap<String, int> newIMap = iMap.add('c', 3);

      expect(newIMap.unlock, {'a': 1, 'b': 2, 'c': 3});
    });

    test("IMap.addEntry method", () {
      final IMap<String, int> iMap = {'a': 1, 'b': 2}.lock;
      final IMap<String, int> newIMap = iMap.addEntry(MapEntry<String, int>('c', 3));

      expect(newIMap.unlock, {'a': 1, 'b': 2, 'c': 3});
    });

    test("IMap.addAll method", () {
      final IMap<String, int> iMap = {'a': 1, 'b': 2}.lock;
      final IMap<String, int> newIMap = iMap.addAll({'c': 3, 'd': 4}.lock);

      expect(newIMap.unlock, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
    });

    test("IMap.addMap method", () {
      final IMap<String, int> iMap = {'a': 1, 'b': 2}.lock;
      final IMap<String, int> newIMap = iMap.addMap({'c': 3, 'd': 4});

      expect(newIMap.unlock, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
    });

    test("IMap.addEntries method", () {
      final IMap<String, int> iMap = {'a': 1, 'b': 2}.lock;
      final IMap<String, int> newIMap =
          iMap.addEntries([MapEntry<String, int>('c', 3), MapEntry<String, int>('d', 4)]);

      expect(newIMap.unlock, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
    });

    test("IMap.remove method", () {
      final IMap<String, int> iMap = {'a': 1, 'b': 2}.lock;
      final IMap<String, int> newIMap = iMap.remove('b');

      expect(newIMap.unlock, {'a': 1});
    });

    test("Chaining IMap.add and IMap.addAll methods", () {
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

    group("Making sure adding repeated elements doesn't repeat keys |", () {
      final IMap<String, int> iMap = IMap.empty<String, int>().withDeepEquals;

      test("Empty equals", () => expect(iMap, IMap.empty<String, int>().withDeepEquals));

      test("IMap.add the same key overwrites it", () {
        IMap<String, int> newMap = iMap.add("a", 1);
        newMap = newMap.add("b", 2);
        newMap = newMap.add("a", 3);
        newMap = newMap.add("a", 4);
        expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
        expect(newMap.unlock, {"a": 4, "b": 2});
      });

      test("IMap.addEntry the same entry overwrites it", () {
        IMap<String, int> newMap = iMap.addEntry(MapEntry<String, int>("a", 1));
        newMap = newMap.addEntry(MapEntry<String, int>("b", 2));
        newMap = newMap.addEntry(MapEntry<String, int>("a", 3));
        newMap = newMap.addEntry(MapEntry<String, int>("a", 4));
        expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
        expect(newMap.unlock, {"a": 4, "b": 2});
      });

      test("IMap.add the same key overwrites it", () {
        IMap<String, int> newMap = iMap.addAll({"a": 1}.lock);
        newMap = newMap.addAll({"b": 2}.lock);
        newMap = newMap.addAll({"a": 3}.lock);
        newMap = newMap.addAll({"a": 4}.lock);
        expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
        expect(newMap.unlock, {"a": 4, "b": 2});
      });

      test("IMap.add the same key overwrites it", () {
        IMap<String, int> newMap = iMap.addMap({"a": 1});
        newMap = newMap.addMap({"b": 2});
        newMap = newMap.addMap({"a": 3});
        newMap = newMap.addMap({"a": 4});
        expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
        expect(newMap.unlock, {"a": 4, "b": 2});
      });

      test("IMap.add the same key overwrites it", () {
        IMap<String, int> newMap = iMap.addEntries([MapEntry<String, int>("a", 1)]);
        newMap = newMap.addEntries([MapEntry<String, int>("b", 2)]);
        newMap = newMap.addEntries([MapEntry<String, int>("a", 3)]);
        newMap = newMap.addEntries([MapEntry<String, int>("a", 4)]);
        expect(newMap, {"a": 4, "b": 2}.lock.withDeepEquals);
        expect(newMap.unlock, {"a": 4, "b": 2});
      });
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Ensuring Immutability |", () {
    group("IMap.add method |", () {
      test("Changing the passed mutable map doesn't change the IMap", () {
        final Map<String, int> original = {'a': 1, 'b': 2};
        final IMap<String, int> iMap = original.lock;

        expect(iMap.unlock, original);

        original.addEntries([MapEntry<String, int>('c', 3)]);
        original.addEntries([MapEntry<String, int>('d', 4)]);

        expect(original, <String, int>{'a': 1, 'b': 2, 'c': 3, 'd': 4});
        expect(iMap.unlock, <String, int>{'a': 1, 'b': 2});
      });

      test("Changing the IMap also doesn't change the original map", () {
        final Map<String, int> original = {'a': 1, 'b': 2};
        final IMap<String, int> iMap = original.lock;

        expect(iMap.unlock, original);

        final IMap<String, int> iMapNew = iMap.add('c', 3);

        expect(original, <String, int>{'a': 1, 'b': 2});
        expect(iMap.unlock, <String, int>{'a': 1, 'b': 2});
        expect(iMapNew.unlock, <String, int>{'a': 1, 'b': 2, 'c': 3});
      });

      test(
          "If the item being passed is a variable, a pointer to it shouldn't exist inside the IMap",
          () {
        final Map<String, int> original = {'a': 1, 'b': 2};
        final IMap<String, int> iMap = original.lock;

        expect(iMap.unlock, original);

        int willChange = 4;
        final IMap<String, int> iMapNew = iMap.add('c', willChange);

        willChange = 5;

        expect(original, <String, int>{'a': 1, 'b': 2});
        expect(iMap.unlock, <String, int>{'a': 1, 'b': 2});
        expect(willChange, 5);
        expect(iMapNew.unlock, <String, int>{'a': 1, 'b': 2, 'c': 4});
      });
    });

    group("IMap.addAll method |", () {
      test("Changing the passed mutable map doesn't change the IMap", () {
        final Map<String, int> original = {'a': 1, 'b': 2};
        final IMap<String, int> iMap = original.lock;

        expect(iMap.unlock, original);

        original.addAll(<String, int>{'c': 3, 'd': 4});

        expect(original, <String, int>{'a': 1, 'b': 2, 'c': 3, 'd': 4});
        expect(iMap.unlock, <String, int>{'a': 1, 'b': 2});
      });

      test("Changing the passed immutable map doesn't change the IMap", () {
        final Map<String, int> original = {'a': 1, 'b': 2};
        final IMap<String, int> iMap = original.lock;

        expect(iMap.unlock, original);

        final IMap<String, int> iMapNew = iMap.addAll(IMap({'c': 3, 'd': 4}));

        expect(original, <String, int>{'a': 1, 'b': 2});
        expect(iMap.unlock, <String, int>{'a': 1, 'b': 2});
        expect(iMapNew.unlock, <String, int>{'a': 1, 'b': 2, 'c': 3, 'd': 4});
      });

      test(
          "If the items being passed are from a variable, "
          "it shouldn't have a pointer to the variable", () {
        final Map<String, int> original = {'a': 1, 'b': 2};
        final IMap<String, int> iMap1 = original.lock;
        final IMap<String, int> iMap2 = original.lock;

        expect(iMap1.unlock, original);
        expect(iMap2.unlock, original);

        final IMap<String, int> iMapNew = iMap1.addAll(iMap2);
        original.addAll(<String, int>{'c': 3, 'd': 4});

        expect(original, <String, int>{'a': 1, 'b': 2, 'c': 3, 'd': 4});
        expect(iMap1.unlock, <String, int>{'a': 1, 'b': 2});
        expect(iMap2.unlock, <String, int>{'a': 1, 'b': 2});
        expect(iMapNew.unlock, <String, int>{'a': 1, 'b': 2});
      });

      group("IMap.remove method |", () {
        test("Changing the passed mutable map doesn't change the IMap", () {
          final Map<String, int> original = {'a': 1, 'b': 2};
          final IMap<String, int> iMap = original.lock;

          expect(iMap.unlock, original);

          original.remove('a');

          expect(original, <String, int>{'b': 2});
          expect(iMap.unlock, <String, int>{'a': 1, 'b': 2});
        });

        test("Removing from the original IMap doesn't change it", () {
          final Map<String, int> original = {'a': 1, 'b': 2};
          final IMap<String, int> iMap = original.lock;

          expect(iMap.unlock, original);

          final IMap<String, int> iMapNew = iMap.remove('a');

          expect(original, <String, int>{'a': 1, 'b': 2});
          expect(iMap.unlock, <String, int>{'a': 1, 'b': 2});
          expect(iMapNew.unlock, <String, int>{'b': 2});
        });
      });
    });
  });

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
        expect(iMap.valueSet, isA<ISet<int>>());
        iMap.valueSet.forEach((int value) => expect(values.contains(value), isTrue));
      });
    });

    test("IMap.iterator getter", () {
      final Iterator<MapEntry<String, int>> iterator = iMap.iterator;

      int count = 0;
      final Map<String, int> result = {};
      while (iterator.moveNext()) {
        count++;
        result[iterator.current.key] = iterator.current.value;
      }
      expect(count, finalMap.length);
      expect(result, finalMap);
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

    test("IMap.get method", () {
      expect(iMap.get('a'), 1);
      expect(iMap.get('z'), isNull);
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
      expect(iMap.toString(), "{c: 3, a: 1, b: 2, d: 4, e: 5, f: 6}");
    });
  });

  // //////////////////////////////////////////////////////////////////////////////////////////////////
}

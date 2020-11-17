import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  group("sameCollection function |", () {
    // TODO: Marcelo, apesar de que a documentação esclarece isso, eu tenho certeza que quem ler
    // esse nome (`sameCollection`) vai certamente pensar que ela checa se ambos os objetos são
    // `IList`, `ISet`, etc. Ainda acho que algo como `sameCollectionInternals` seria mais claro.
    test("If both are null, then true", () => expect(sameCollection(null, null), isTrue));

    test("If one of them is not null, then false", () {
      expect(sameCollection(IList(), null), isFalse);
      expect(sameCollection(null, IList()), isFalse);
    });

    test("If none of them is null, then use .same()", () {
      final IList<int> iList1 = IList([1, 2]), iList2 = IList([1, 2]);
      final IList<int> iList3 = iList1.remove(3);

      expect(sameCollection(iList1, iList2), isFalse);
      expect(sameCollection(iList1, iList3), isTrue);
    });
  });

  group("disallowUnsafeConstructors |", () {
    test("Is initially false",
        () => expect(ImmutableCollection.disallowUnsafeConstructors, isFalse));

    test("Changing the default to true", () {
      expect(ImmutableCollection.disallowUnsafeConstructors, isFalse);
      ImmutableCollection.disallowUnsafeConstructors = true;
      expect(ImmutableCollection.disallowUnsafeConstructors, isTrue);
    });

    test("Changing the lockConfig makes disallowUnsafeConstructors throw an exception", () {
      ImmutableCollection.lockConfig();
      expect(() => ImmutableCollection.disallowUnsafeConstructors = true, throwsStateError);
    });
  });

  group("IteratorExtension |", () {
    const List<int> list = [1, 2, 3];

    test("IteratorExtension.toIterable method/generator", () {
      final Iterable<int> iterable = list.iterator.toIterable();
      expect(iterable, [1, 2, 3]);
    });

    test("IteratorExtension.toList method", () {
      final List<int> mutableList = list.iterator.toList();
      final List<int> unmodifiableList = list.iterator.toList(growable: false);

      mutableList.add(4);
      expect(mutableList, [1, 2, 3, 4]);

      expect(unmodifiableList, [1, 2, 3]);
      expect(() => unmodifiableList.add(4), throwsUnsupportedError);
    });

    test("IteratorExtension.toSet method", () {
      final Set<int> mutableSet = list.iterator.toSet();

      expect(mutableSet, {1, 2, 3});
    });
  });

  group("MapIteratorExtension |", () {
    const List<MapEntry<String, int>> entryList = [
      MapEntry("a", 1),
      MapEntry("b", 2),
      MapEntry("c", 3),
    ];

    test("MapIteratorExtension.toIterable method", () {
      final Iterator<MapEntry<String, int>> iterator = entryList.iterator;
      final Iterable<MapEntry<String, int>> iterable = iterator.toIterable();

      expect(iterable.contains(const MapEntry("a", 1)), isTrue);
      expect(iterable.contains(const MapEntry("b", 2)), isTrue);
      expect(iterable.contains(const MapEntry("c", 3)), isTrue);
      expect(iterable.contains(const MapEntry("d", 4)), isFalse);
    });

    test("MapIteratorExtension.toMap method", () {
      final Iterator<MapEntry<String, int>> iterator = entryList.iterator;
      final Map<String, int> map = iterator.toMap();
      expect(map, {"a": 1, "b": 2, "c": 3});
    });
  });

  group("Item |", () {
    Output<int> item;

    setUp(() => item = Output());

    test("Item.value is initially null", () => expect(item.value, isNull));

    test("Item.value won't change after it's set", () {
      expect(item.value, isNull);

      item.set(10);

      expect(item.value, 10);
      expect(() => item.set(1), throwsStateError);
    });

    test("Item.toString", () {
      expect(item.toString(), "null");
      item.set(10);
      expect(item.toString(), "10");
    });

    group("Equals and Hash |", () {
      final Output<int> item1 = Output();
      final Output<int> item2 = Output();
      final Output<int> item3 = Output();
      item1.set(10);
      item2.set(10);
      item3.set(1);

      test("Item.== operator", () {
        expect(item1 == item1, isTrue);
        expect(item1 == item2, isTrue);
        expect(item2 == item1, isTrue);
        expect(item1 == item3, isFalse);
      });

      test(
          "Item.hashCode getter",
          () =>
              expect(item1.hashCode, allOf(item1.hashCode, item2.hashCode, isNot(item3.hashCode))));
    });
  });

  group("IterableToImmutableExtension |", () {
    test("IterableToImmutableExtension.lockAsList", () {
      const List<int> list = [1, 2, 3, 3];
      final IList<int> iList = list.lockAsList;
      final ISet<int> iSet = list.lockAsSet;

      expect(iList, [1, 2, 3, 3]);
      expect(iSet, {1, 2, 3});
    });

    test("IterableToImmutableExtension.lockAsSet", () {
      final Set<int> set = {1, 2, 3};
      final IList<int> iList = set.lockAsList;
      final ISet<int> iSet = set.lockAsSet;

      expect(iList, [1, 2, 3]);
      expect(iSet, [1, 2, 3]);
    });
  });
}

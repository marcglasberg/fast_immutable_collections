import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

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
    test("Is initially false", () => expect(disallowUnsafeConstructors, isFalse));

    test("Changing the default to true", () {
      expect(disallowUnsafeConstructors, isFalse);
      disallowUnsafeConstructors = true;
      expect(disallowUnsafeConstructors, isTrue);
    });

    test("Changing the lockConfig makes disallowUnsafeConstructors throw an exception", () {
      lockConfig();
      expect(() => disallowUnsafeConstructors = true, throwsStateError);
    });
  });

  group("IteratorExtension |", () {
    const List<int> list = [1, 2, 3];
    final Iterator<int> iterator = list.iterator;

    test("IteratorExtension.toIterable method/generator", () {
      final Iterable<int> iterable = iterator.toIterable();

      expect(iterable.contains(1), isTrue);
      expect(iterable.contains(2), isTrue);
      expect(iterable.contains(3), isTrue);
      expect(iterable.contains(4), isFalse);
    });

    test("IteratorExtension.toList method", () {
      final List<int> mutableList = iterator.toList(),
          unmodifiableList = iterator.toList(growable: false);

      // TODO: Marcelo, aparentemente, o gerador do `toIterable` não está gerando todos os valores
      // na transição para a lista.
      mutableList.add(4);
      expect(mutableList, [1, 2, 3, 4]);

      expect(unmodifiableList, [1, 2, 3]);
      expect(() => unmodifiableList.add(4), throwsUnsupportedError);
    });

    test("IteratorExtension.toSet method", () {
      final Set<int> mutableSet = iterator.toSet();

      expect(mutableSet, {1, 2, 3});
    });
  });

  group("MapIteratorExtension |", () {
    const List<MapEntry<String, int>> entryList = [
      MapEntry('a', 1),
      MapEntry('b', 2),
      MapEntry('c', 3),
    ];
    final Iterator<MapEntry<String, int>> iterator = entryList.iterator;

    test("MapIteratorExtension.toIterable method", () {
      final Iterable<MapEntry<String, int>> iterable = iterator.toIterable();

      expect(iterable.contains(const MapEntry('a', 1)), isTrue);
      expect(iterable.contains(const MapEntry('b', 2)), isTrue);
      expect(iterable.contains(const MapEntry('c', 3)), isTrue);
      expect(iterable.contains(const MapEntry('d', 4)), isFalse);
    });

    test("MapIteratorExtension.toMap method", () {
      final Map<String, int> map = iterator.toMap();

      expect(map, {"a": 1, "b": 2, "c": 3});
    });
  });
}

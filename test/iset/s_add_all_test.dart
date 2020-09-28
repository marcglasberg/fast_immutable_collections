import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/iset/s_add_all.dart';
import 'package:fast_immutable_collections/src/iset/s_add.dart';
import 'package:fast_immutable_collections/src/iset/s_flat.dart';

void main() {
  final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});

  group('Basic Usage Tests and Checks |', () {
    test('Runtime Type', () => expect(sAddAll, isA<SAddAll<int>>()));

    test('Emptiness Properties', () {
      expect(sAddAll.isEmpty, isFalse);
      expect(sAddAll.isNotEmpty, isTrue);
    });

    test('Length', () => expect(sAddAll.length, 5));

    test('Iterating on the underlying iterator', () {
      final Iterator<int> iter = sAddAll.iterator;

      expect(iter.current, isNull);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 1);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 2);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 3);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 4);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 5);
      expect(iter.moveNext(), isFalse);
      expect(iter.current, isNull);
    });

    test('Unlocking', () => expect(sAddAll.unlock, [1, 2, 3, 4, 5]));
  });

  group('Combining various `SAddAll`s and `SAdd`s', () {
    final sAddAll = SAddAll(
        SAddAll(
            SAddAll(SAdd(SAddAll(SFlat.unsafe({1, 2}), {3, 4}), 5), {6, 7}), <int>{}),
        {8});

    test('Runtime Type', () => expect(sAddAll, isA<SAddAll<int>>()));

    test('Emptiness Properties', () {
      expect(sAddAll.isEmpty, isFalse);
      expect(sAddAll.isNotEmpty, isTrue);
    });

    test('Length', () => expect(sAddAll.length, 8));

    test('Iterating on the underlying iterator', () {
      final Iterator<int> iter = sAddAll.iterator;

      expect(iter.current, isNull);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 1);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 2);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 3);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 4);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 5);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 6);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 7);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 8);
      expect(iter.moveNext(), isFalse);
      expect(iter.current, isNull);
    });

    test('Unlocking', () => expect(sAddAll.unlock, [1, 2, 3, 4, 5, 6, 7, 8]));
  });
}

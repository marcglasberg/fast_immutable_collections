import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/ilist/l_add.dart';
import 'package:fast_immutable_collections/src/ilist/l_add_all.dart';
import 'package:fast_immutable_collections/src/ilist/l_flat.dart';

void main() {
  group('Basic Usage Tests and Checks |', () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);

    test('Runtime Type', () => expect(lAddAll, isA<LAddAll<int>>()));

    test('`unlock`', () {
      expect(lAddAll.unlock, <int>[1, 2, 3, 4, 5]);
      expect(lAddAll.unlock, isA<List<int>>());
    });

    test('Emptiness Properties', () {
      expect(lAddAll.isEmpty, isFalse);
      expect(lAddAll.isNotEmpty, isTrue);
    });

    test('Length', () => expect(lAddAll.length, 5));

    group('Index Access |', () {
      test('`LAddAll[index]`', () {
        expect(lAddAll[0], 1);
        expect(lAddAll[1], 2);
        expect(lAddAll[2], 3);
        expect(lAddAll[3], 4);
        expect(lAddAll[4], 5);
      });

      test('Range Errors', () {
        expect(() => lAddAll[5], throwsA(isA<RangeError>()));
        expect(() => lAddAll[-1], throwsA(isA<RangeError>()));
      });
    });

    test('`contains`', () {
      expect(lAddAll.contains(1), isTrue);
      expect(lAddAll.contains(6), isFalse);
    });

    group('IteratorLAddAll |', () {
      test('Iterating on the underlying iterator', () {
        final Iterator<int> iter = lAddAll.iterator;

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
    });
  });

  group('Combining various `LAddAll`s, `LAdd`s, `LFlat`s and `List`s |', () {
    final lAddAll =
        LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);

    test('Runtime Type', () => expect(lAddAll, isA<LAddAll<int>>()));

    test('`unlock`', () {
      expect(lAddAll.unlock, <int>[1, 2, 3, 4, 5, 6, 7, 8]);
      expect(lAddAll.unlock, isA<List<int>>());
    });

    test('Emptiness Properties', () {
      expect(lAddAll.isEmpty, isFalse);
      expect(lAddAll.isNotEmpty, isTrue);
    });

    test('Length', () => expect(lAddAll.length, 8));

    group('Index Access |', () {
      final LAddAll<int> lAddAll = LAddAll(LFlat([1, 2, 3]), [4, 5, 6, 7]);

      test('`LAdd[index]`', () {
        expect(lAddAll[0], 1);
        expect(lAddAll[1], 2);
        expect(lAddAll[2], 3);
        expect(lAddAll[3], 4);
        expect(lAddAll[4], 5);
        expect(lAddAll[5], 6);
        expect(lAddAll[6], 7);
      });

      test('Range Errors', () {
        expect(() => lAddAll[7], throwsA(isA<RangeError>()));
        expect(() => lAddAll[-1], throwsA(isA<RangeError>()));
      });
    });

    test('`contains`', () {
      expect(lAddAll.contains(1), isTrue);
      expect(lAddAll.contains(8), isTrue);
    });

    group('`IteratorLAddAll` |', () {
      test('Iterating on the underlying iterator', () {
        final Iterator<int> iter = lAddAll.iterator;

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
    });
  });

  // TODO: completar
  group('Ensuring Immutability |', () {
    group('`add` |', () {});
  });
}

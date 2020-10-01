import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/ilist/l_add.dart';
import 'package:fast_immutable_collections/src/ilist/l_flat.dart';

void main() {
  final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);

  test('Runtime Type', () => expect(lAdd, isA<LAdd<int>>()));

  test('`unlock`', () {
    expect(lAdd.unlock, <int>[1, 2, 3, 4]);
    expect(lAdd.unlock, isA<List<int>>());
  });

  test('Emptiness Properties', () {
    expect(lAdd.isEmpty, isFalse);
    expect(lAdd.isNotEmpty, isTrue);
  });

  test('Length', () => expect(lAdd.length, 4));

  group('Index Access |', () {
    test('`LAdd[index]`', () {
      expect(lAdd[0], 1);
      expect(lAdd[1], 2);
      expect(lAdd[2], 3);
      expect(lAdd[3], 4);
    });

    test('Range Errors', () {
      expect(() => lAdd[4], throwsA(isA<RangeError>()));
      expect(() => lAdd[-1], throwsA(isA<RangeError>()));
    });
  });

  test('`contains`', () {
    expect(lAdd.contains(1), isTrue);
    expect(lAdd.contains(5), isFalse);
  });

  group('`IteratorLAdd` |', () {
    test('Iterating on the underlying iterator', () {
      final Iterator<int> iter = lAdd.iterator;

      expect(iter.current, isNull);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 1);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 2);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 3);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 4);
      expect(iter.moveNext(), isFalse);
      expect(iter.current, isNull);
    });
  });

  // TODO: completar: `add`, `addAll` e `remove`.
  group('Ensuring Immutability |', () {
    group('`add` |', () {
      test('Changing the passed mutable list doesn\'t change the `LAdd`', () {
        final List<int> original = [1, 2];
        final LFlat<int> lFlat = LFlat(original);
        final LAdd<int> lAdd = LAdd(lFlat, 3);

        expect(lAdd.unlock, <int>[1, 2, 3]);

        original.add(3);
        original.add(4);

        expect(original, <int>[1, 2, 3, 4]);
        expect(lAdd.unlock, <int>[1, 2, 3]);
      });

      test('Changing the passed mutable list doesn\'t change the `LAdd`', () {
        final List<int> original = [1, 2];
        final LFlat<int> lFlat = LFlat(original);
        final LAdd<int> lAdd = LAdd<int>(lFlat, 3);

        expect(lAdd.unlock, <int>[1, 2, 3]);

        final L<int> l = lAdd.add(4);

        expect(original, <int>[1, 2]);
        expect(l.unlock, <int>[1, 2, 3, 4]);
      });
    });

    group('`addAll |', () {
      test('Changing the passed mutable list doesn\'t change the `LAdd`', () {
        final List<int> original = [1, 2];
        final LFlat<int> lFlat = LFlat(original);
        final LAdd<int> lAdd = LAdd(lFlat, 3);

        expect(lAdd.unlock, <int>[1, 2, 3]);

        original.addAll(<int>[3, 4]);

        expect(original, <int>[1, 2, 3, 4]);
        expect(lAdd.unlock, <int>[1, 2, 3]);
      });

      test('Changing the passed mutable list doesn\'t change the `LAdd`', () {
        final List<int> original = [1, 2];
        final LFlat<int> lFlat = LFlat(original);
        final LAdd<int> lAdd = LAdd<int>(lFlat, 3);

        expect(lAdd.unlock, <int>[1, 2, 3]);

        final L<int> l = lAdd.addAll([4, 5]);

        expect(original, <int>[1, 2]);
        expect(l.unlock, <int>[1, 2, 3, 4, 5]);
      });
    });
  });
}

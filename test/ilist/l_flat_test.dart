import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/ilist/l_flat.dart';

void main() {
  final List<int> original = [1, 2, 3];
  final LFlat<int> lFlat = LFlat<int>(original);

  test('Runtime Type', () => expect(lFlat, isA<LFlat<int>>()));

  test('Emptiness Properties', () {
    expect(lFlat.isEmpty, isFalse);
    expect(lFlat.isNotEmpty, isTrue);
  });

  test('Length', () => expect(lFlat.length, 3));

  test('Index', () {
    expect(lFlat[0], 1);
    expect(lFlat[1], 2);
    expect(lFlat[2], 3);
  });

  test('Range Errors', () => expect(() => lFlat[-1], throwsA(isA<RangeError>())));

  group('`Iterator` |', () {
    test('Iterating on the underlying iterator', () {
      final Iterator<int> iter = lFlat.iterator;

      expect(iter.current, isNull);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 1);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 2);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 3);
      expect(iter.moveNext(), isFalse);
      expect(iter.current, isNull);
    });
  });

  test('`empty`', () {
    final L<int> empty = LFlat.empty();

    expect(empty.unlock, <int>[]);
    expect(empty.isEmpty, isTrue);
  });

  group('Hash Code and Equals |', () {
    test('`deepListHashCode`',
        () => expect(lFlat.deepListHashcode(), ListEquality().hash(original)));

    test('`deepListEquals`', () {
      expect(lFlat.deepListEquals(null), isFalse);
      expect(lFlat.deepListEquals(LFlat<int>([])), isFalse);
      expect(lFlat.deepListEquals(LFlat<int>(original)), isTrue);
      expect(lFlat.deepListEquals(LFlat<int>([1, 2, 3, 4])), isFalse);
    });
  });

  group('Ensuring Immutability |', () {
    // This code is not as DRY as one would like, but, in these immutability tests, I prefer to
    // repeat everything so all the variables are `final` within their context.
    test('Adding to the original list', () {
      final List<int> original = [1, 2, 3];
      final LFlat<int> lFlat = LFlat<int>(original);

      expect(lFlat.unlock, original);

      original.add(4);

      expect(original, [1, 2, 3, 4]);
      expect(lFlat.unlock, [1, 2, 3]);
    });

    test('Adding multiple elements at once', () {
      final List<int> original = [1, 2, 3];
      final LFlat<int> lFlat = LFlat<int>(original);

      expect(lFlat.unlock, original);

      original.addAll([4, 5]);

      expect(original, [1, 2, 3, 4, 5]);
      expect(lFlat.unlock, [1, 2, 3]);
    });

    test('Removing an element', () {
      final List<int> original = [1, 2, 3];
      final LFlat<int> lFlat = LFlat<int>(original);

      expect(lFlat.unlock, original);

      original.remove(3);

      expect(original, [1, 2]);
      expect(lFlat.unlock, [1, 2, 3]);
    });

    test('Initialization through the `unsafe` constructor', () {
      final List<int> original = [1, 2, 3];
      final LFlat<int> lFlat = LFlat.unsafe(original);

      expect(lFlat.unlock, original);

      original.add(4);

      expect(original, [1, 2, 3, 4]);
      expect(lFlat.unlock, [1, 2, 3, 4]);
    });
  });
}

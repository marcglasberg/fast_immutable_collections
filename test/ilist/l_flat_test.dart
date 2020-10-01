import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/ilist/l_flat.dart';

void main() {
  final List<int> original = [1, 2, 3];
  final LFlat<int> lFlat = LFlat<int>(original);

  test('Runtime Type', () => expect(lFlat, isA<LFlat<int>>()));

  test('`unlock`', () {
    expect(lFlat.unlock, <int>[1, 2, 3]);
    expect(lFlat.unlock, isA<List<int>>());
  });

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

  test('Range Errors', () {
    expect(() => lFlat[-1], throwsA(isA<RangeError>()));
    expect(() => lFlat[4], throwsA(isA<RangeError>()));
  });

  test('`cast`', () {
    // When casting a `List`, we get back another `List`. Should our `IList` really give back an
    // `Iterable`?
    final lFlatAsNum = lFlat.cast<num>();

    expect(lFlatAsNum, isA<LFlat<num>>());
  });

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

  // TODO: revisar
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

  group('Other overrides belonging to `L` but also coming from `Iterable` |', () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);

    test('`any`', () {
      expect(lFlat.any((int v) => v == 4), isTrue);
      expect(lFlat.any((int v) => v == 100), isFalse);
    });

    test('`contains`', () {
      expect(lFlat.contains(2), isTrue);
      expect(lFlat.contains(4), isTrue);
      expect(lFlat.contains(5), isTrue);
      expect(lFlat.contains(100), isFalse);
    });

    group('`elementAt |', () {
      test('Regular element access', () {
        expect(lFlat.elementAt(0), 1);
        expect(lFlat.elementAt(1), 2);
        expect(lFlat.elementAt(2), 3);
        expect(lFlat.elementAt(3), 4);
        expect(lFlat.elementAt(4), 5);
        expect(lFlat.elementAt(5), 6);
      });

      test('Range exceptions', () {
        expect(() => lFlat.elementAt(6), throwsRangeError);
        expect(() => lFlat.elementAt(-1), throwsRangeError);
      });
    });

    test('`every`', () {
      expect(lFlat.every((int v) => v > 0), isTrue);
      expect(lFlat.every((int v) => v < 0), isFalse);
      expect(lFlat.every((int v) => v != 4), isFalse);
    });

    test('`expand`', () {
      expect(lFlat.expand((int v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
      expect(lFlat.expand((int v) => []), []);
    });

    test('`first`', () => expect(lFlat.first, 1));

    test('`last`', () => expect(lFlat.last, 6));

    group('`single` |', () {
      test('State exception', () => expect(() => lFlat.single, throwsStateError));

      test('Access', () => expect([10].lock.single, 10));
    });

    test('`firstWhere`', () {
      expect(lFlat.firstWhere((int v) => v > 1, orElse: () => 100), 2);
      expect(lFlat.firstWhere((int v) => v > 4, orElse: () => 100), 5);
      expect(lFlat.firstWhere((int v) => v > 5, orElse: () => 100), 6);
      expect(lFlat.firstWhere((int v) => v > 6, orElse: () => 100), 100);
    });

    test('`fold`', () => expect(lFlat.fold(100, (int p, int e) => p * (1 + e)), 504000));

    test('`followedBy`', () {
      expect(lFlat.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
      expect(lFlat.followedBy([7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });

    test('`forEach`', () {
      int result = 100;
      lFlat.forEach((int v) => result *= 1 + v);
      expect(result, 504000);
    });

    test('`join`', () {
      expect(lFlat.join(','), '1,2,3,4,5,6');
      expect(LFlat(<int>[]).join(','), '');
      expect(LFlat.empty().join(','), '');
    });

    test('`lastWhere`', () {
      expect(lFlat.lastWhere((int v) => v < 2, orElse: () => 100), 1);
      expect(lFlat.lastWhere((int v) => v < 5, orElse: () => 100), 4);
      expect(lFlat.lastWhere((int v) => v < 6, orElse: () => 100), 5);
      expect(lFlat.lastWhere((int v) => v < 7, orElse: () => 100), 6);
      expect(lFlat.lastWhere((int v) => v < 50, orElse: () => 100), 6);
      expect(lFlat.lastWhere((int v) => v < 1, orElse: () => 100), 100);
    });

    test('`map`', () {
      expect(LFlat([1, 2, 3]).map((int v) => v + 1), [2, 3, 4]);
      expect(lFlat.map((int v) => v + 1), [2, 3, 4, 5, 6, 7]);
    });

    group('`reduce` |', () {
      test('Regular usage', () {
        expect(lFlat.reduce((int p, int e) => p * (1 + e)), 2520);
        expect(LFlat([5]).reduce((int p, int e) => p * (1 + e)), 5);
      });

      test(
          'State exception',
          () => expect(() => IList().reduce((dynamic p, dynamic e) => p * (1 + (e as num))),
              throwsStateError));
    });

    group('`singleWhere` |', () {
      test('Regular usage', () {
        expect(lFlat.singleWhere((int v) => v == 4, orElse: () => 100), 4);
        expect(lFlat.singleWhere((int v) => v == 50, orElse: () => 100), 100);
      });

      test(
          'State exception',
          () => expect(
              () => lFlat.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError));
    });

    test('`skip`', () {
      expect(lFlat.skip(1), [2, 3, 4, 5, 6]);
      expect(lFlat.skip(3), [4, 5, 6]);
      expect(lFlat.skip(5), [6]);
      expect(lFlat.skip(10), []);
    });

    test('`skipWhile`', () {
      expect(lFlat.skipWhile((int v) => v < 3), [3, 4, 5, 6]);
      expect(lFlat.skipWhile((int v) => v < 5), [5, 6]);
      expect(lFlat.skipWhile((int v) => v < 6), [6]);
      expect(lFlat.skipWhile((int v) => v < 100), []);
    });

    test('`take`', () {
      expect(lFlat.take(0), []);
      expect(lFlat.take(1), [1]);
      expect(lFlat.take(3), [1, 2, 3]);
      expect(lFlat.take(5), [1, 2, 3, 4, 5]);
      expect(lFlat.take(10), [1, 2, 3, 4, 5, 6]);
    });

    test('`takeWhile`', () {
      expect(lFlat.takeWhile((int v) => v < 3), [1, 2]);
      expect(lFlat.takeWhile((int v) => v < 5), [1, 2, 3, 4]);
      expect(lFlat.takeWhile((int v) => v < 6), [1, 2, 3, 4, 5]);
      expect(lFlat.takeWhile((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
    });

    group('`toList` |', () {
      test('Regular usage', () {
        expect(lFlat.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
        expect(lFlat.unlock, [1, 2, 3, 4, 5, 6]);
      });

      test('Unsupported exception',
          () => expect(() => lFlat.toList(growable: false)..add(7), throwsUnsupportedError));
    });

    test('`toSet`', () {
      expect(lFlat.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
      expect(
          lFlat
            ..add(6)
            ..toSet(),
          {1, 2, 3, 4, 5, 6});
      expect(lFlat.unlock, [1, 2, 3, 4, 5, 6]);
    });

    test('`where`', () {
      expect(lFlat.where((int v) => v < 0), []);
      expect(lFlat.where((int v) => v < 3), [1, 2]);
      expect(lFlat.where((int v) => v < 5), [1, 2, 3, 4]);
      expect(lFlat.where((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
    });

    test('`whereType`', () => expect((LFlat(<num>[1, 2, 1.5]).whereType<double>()), [1.5]));
  });
}

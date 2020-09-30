import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/ilist/l_add.dart';
import 'package:fast_immutable_collections/src/ilist/l_flat.dart';

void main() {
  final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);

  test('Runtime Type', () => expect(lAdd, isA<LAdd<int>>()));

  test('Emptiness Properties', () {
    expect(lAdd.isEmpty, isFalse);
    expect(lAdd.isNotEmpty, isTrue);
  });

  test('Length', () => expect(lAdd.length, 4));

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

  // TODO: completar
  group('Ensuring Immutability |', () {
    test('', () {
      
    });
  });
}

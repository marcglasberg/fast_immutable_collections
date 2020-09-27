import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/iset/s_add.dart';
import 'package:fast_immutable_collections/src/iset/s_flat.dart';

void main() {
  // Note that adding repeated members won't work as the expected behavior for
  // regular sets, because that behavior is implemented elsewhere.
  final SAdd<int> sAdd = SAdd<int>(SFlat<int>.unsafe({1, 2, 3}), 4);

  test('Runtime Type', () => expect(sAdd, isA<SAdd<int>>()));

  test('Emptiness Properties', () {
    expect(sAdd.isEmpty, isFalse);
    expect(sAdd.isNotEmpty, isTrue);
  });

  test('Length', () => expect(sAdd.length, 4));

  test('Iterating on the underlying iterator', () {
    final Iterator<int> iter = sAdd.iterator;

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
}

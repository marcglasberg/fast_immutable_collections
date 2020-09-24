import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/iset/s_add.dart';
import 'package:fast_immutable_collections/src/iset/s_flat.dart';

void main() {
  final SAdd<int> sAdd = SAdd<int>(SFlat<int>({1, 2, 3, 4}), 4);

  test('Runtime Type', () => expect(sAdd, isA<SAdd<int>>()));

  test('Emptiness Properties', () {
    expect(sAdd.isEmpty, isFalse);
    expect(sAdd.isNotEmpty, isTrue);
  });

  test('Length', () => expect(sAdd.length, 4));
}

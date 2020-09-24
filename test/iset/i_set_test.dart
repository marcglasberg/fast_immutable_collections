import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  test('`add`', () {
    final ISet<int> iSet = ISet<int>([1]);

    iSet.add(2);

    expect(iSet.unlock, <int>{1, 2});
  });
}
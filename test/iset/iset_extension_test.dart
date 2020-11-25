import "package:flutter_test/flutter_test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("ISetExtension.lock", () => expect({1, 2, 3}.lock, allOf(isA<ISet<int>>(), {1, 2, 3})));

  test("ISetExtension.lockUnsafe", () {
    final Set<int> set = {1, 2, 3};
    final ISet<int> iSet = set.lockUnsafe;

    expect(set, iSet);

    set.add(4);

    expect(set, iSet);
  });
}

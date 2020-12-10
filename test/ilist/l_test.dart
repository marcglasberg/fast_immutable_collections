import "package:meta/meta.dart";
import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("isEmpty | isNotEmpty", () {
    expect(LExample([]).isEmpty, isTrue);
    expect(LExample([]).isNotEmpty, isFalse);

    expect(LExample([1, 2, 3]).isEmpty, isFalse);
    expect(LExample([1, 2, 3]).isNotEmpty, isTrue);
  });
}

@visibleForTesting
class LExample extends L<int> {
  final IList<int> _ilist;

  LExample(Iterable<int> iterable) : _ilist = IList(iterable);

  @override
  Iterator<int> get iterator => _ilist.iterator;
}

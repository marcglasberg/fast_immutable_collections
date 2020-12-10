import "package:flutter_test/flutter_test.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// These tests are mainly for coverage purposes, it tests methods inside the [S] class which were
/// not reached by its implementations.
void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("isEmpty | isNotEmpty", () {
    expect(SExample().isEmpty, isTrue);
    expect(SExample({}).isEmpty, isTrue);
    expect(SExample<String>({}).isEmpty, isTrue);
    expect(SExample([1]).isEmpty, isFalse);

    expect(SExample().isNotEmpty, isFalse);
    expect(SExample({}).isNotEmpty, isFalse);
    expect(SExample<String>({}).isNotEmpty, isFalse);
    expect(SExample([1]).isNotEmpty, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("length", () {
    expect(SExample({1, 2, 3}).length, 3);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("whereType", () {
    expect((SExample(<num>{1, 2, 1.5}).whereType<double>()), {1.5});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("elementAt", () {
    final SExample<int> sExample = SExample({1, 2, 3});
    expect(() => sExample.elementAt(0), throwsUnsupportedError);
  });

  //////////////////////////////////////////////////////////////////////////////
}

//////////////////////////////////////////////////////////////////////////////

@visibleForTesting
class SExample<T> extends S<T> {
  final ISet<T> _iset;

  SExample([Iterable<T> iterable]) : _iset = ISet(iterable);

  @override
  Iterator<T> get iterator => _iset.iterator;

  @override
  bool contains(covariant Object element) => _iset.contains(element);

  @override
  T get anyItem => _iset.anyItem;
}

//////////////////////////////////////////////////////////////////////////////

import "package:test/test.dart";
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

  test("length, first, last, single", () {
    expect(SExample({1, 2, 3}).length, 3);
    expect(SExample({1, 3}).first, 1);
    expect(SExample({1, 3}).last, 3);
    expect(SExample({3}).single, 3);
    expect(() => SExample({3}).add(1).single, throwsStateError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("whereType", () {
    expect((SExample(<num>{1, 2, 1.5}).whereType<double>()), {1.5});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("elementAt", () {
    final SExample<int> iset = SExample({1, 20, 3});

    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 20);
    expect(iset.elementAt(2), 3);
    expect(() => iset.elementAt(-1), throwsRangeError);
    expect(() => iset.elementAt(3), throwsRangeError);

    expect(iset[0], 1);
    expect(iset[1], 20);
    expect(iset[2], 3);
    expect(() => iset[-1], throwsRangeError);
    expect(() => iset[3], throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////
}

//////////////////////////////////////////////////////////////////////////////

@visibleForTesting
class SExample<T> extends S<T> {
  final ISet<T> _iset;

  SExample([Iterable<T> iterable]) : _iset = ISet(iterable);

  @override
  Iterable<T> get iter => _iset;

  @override
  Iterator<T> get iterator => _iset.iterator;

  @override
  bool contains(covariant T element) => _iset.contains(element);

  @override
  bool containsAll(Iterable<T> other) => _iset.containsAll(other);

  @override
  T get anyItem => _iset.anyItem;

  @override
  T operator [](int index) => _iset[index];

  @override
  Set<T> difference(Set<T> other) => _iset.difference(other).unlockLazy;

  @override
  Set<T> intersection(Set<T> other) => _iset.intersection(other).unlockLazy;

  @override
  Set<T> union(Set<T> other) => _iset.union(other).unlockLazy;

  @override
  T lookup(T element) => _iset.lookup(element);
}

//////////////////////////////////////////////////////////////////////////////

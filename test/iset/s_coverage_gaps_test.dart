// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/iset/iset.dart";
import "package:fast_immutable_collections/src/iset/s_add.dart";
import "package:fast_immutable_collections/src/iset/s_add_all.dart";
import "package:fast_immutable_collections/src/iset/s_flat.dart";
import "package:meta/meta.dart";
import "package:test/test.dart";

/// These tests are mainly for coverage purposes. They test methods of the [S] class
/// (and its subclasses) which were not reached by other tests.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  test("fillBefore | uses the default fillOwnItemsBefore", () {
    final SCoverageExample<int> s = SCoverageExample({1, 2, 3});
    expect(s.below, isNull);

    // Fills the end of the list.
    final List<Object?> target = List<Object?>.filled(5, null);
    expect(s.fillBefore(target, 5), 2);
    expect(target, [null, null, 1, 2, 3]);

    // Fills the beginning of the list.
    final List<Object?> target2 = List<Object?>.filled(4, 0);
    expect(s.fillOwnItemsBefore(target2, 3), 0);
    expect(target2, [1, 2, 3, 0]);

    // Empty.
    final List<Object?> target3 = [7, 8];
    expect(SCoverageExample<int>({}).fillBefore(target3, 1), 1);
    expect(target3, [7, 8]);
  });

  test("unlock | a deep chain of nodes on top of a custom S", () {
    // More than 2 nodes below the top one, so that the items are copied with
    // fillBefore, which reaches the default fillOwnItemsBefore of the custom S.
    final S<int> s = SCoverageExample({1, 2}).add(3).add(4).addAll({5, 6}).add(7);
    expect(s, isA<SAdd<int>>());
    expect(s.length, 7);
    expect(s.unlock, allOf(isA<Set<int>>(), [1, 2, 3, 4, 5, 6, 7]));
    expect(s.getFlushed(ConfigSet()), [1, 2, 3, 4, 5, 6, 7]);

    // Sorted.
    final S<int> s2 = SCoverageExample({20, 10}).add(3).add(40).add(1);
    expect(s2.getFlushed(ConfigSet(sort: true)), [1, 3, 10, 20, 40]);

    // Removing an item uses unlock.
    expect(s.remove(4), [1, 2, 3, 5, 6, 7]);
  });

  test("unlock | a shallow chain doesn't need fillBefore", () {
    final S<int> s = SCoverageExample({1, 2}).add(3);
    expect(s.unlock, [1, 2, 3]);
    expect(SCoverageExample({1, 2}).unlock, [1, 2]);
  });

  test("SAddAll.lookup | when the items are an S", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), SFlat<int>.unsafe({3, 4}));

    // Found in the S below.
    expect(sAddAll.lookup(1), 1);

    // Not found in the S below, so looks into the added S.
    expect(sAddAll.lookup(3), 3);
    expect(sAddAll.lookup(4), 4);
    expect(sAddAll.lookup(10), isNull);

    // Added S which is itself a chain.
    final SAddAll<int> sAddAll2 =
        SAddAll(SFlat<int>.unsafe({1}), SAdd(SFlat<int>.unsafe({5}), 6));
    expect(sAddAll2.lookup(6), 6);
    expect(sAddAll2.lookup(5), 5);
    expect(sAddAll2.lookup(7), isNull);
    expect(sAddAll2, [1, 5, 6]);
  });

  test("SAddAll.lookup | returns the instance that is in the added S", () {
    final _Item a1 = _Item(1, "a");
    final _Item a2 = _Item(2, "a");
    final _Item b2 = _Item(2, "b");

    final SAddAll<_Item> sAddAll =
        SAddAll(SFlat<_Item>.unsafe({a1}), SFlat<_Item>.unsafe({a2}));

    expect(identical(sAddAll.lookup(b2), a2), isTrue);
    expect(identical(sAddAll.lookup(_Item(1, "b")), a1), isTrue);
    expect(sAddAll.lookup(_Item(3, "b")), isNull);
  });
}

/// An object whose equality depends only on [id].
class _Item {
  final int id;
  final String tag;

  _Item(this.id, this.tag);

  @override
  bool operator ==(Object other) => other is _Item && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// A custom [S] that does NOT override [fillOwnItemsBefore] nor [below].
@visibleForTesting
class SCoverageExample<T> extends S<T> {
  final ISet<T> _iset;

  SCoverageExample([Iterable<T>? iterable]) : _iset = ISet(iterable);

  @override
  Iterable<T> get iter => _iset;

  @override
  Iterator<T> get iterator => _iset.iterator;

  @override
  bool contains(covariant T? element) => _iset.contains(element);

  @override
  bool containsAll(Iterable<T> other) => _iset.containsAll(other);

  @override
  T get anyItem => _iset.anyItem;

  @override
  T operator [](int index) => _iset[index];

  @override
  T? lookup(T element) => _iset.lookup(element);
}

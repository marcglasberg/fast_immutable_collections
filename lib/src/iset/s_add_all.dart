// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/src/iterator/chain_iterator.dart";

import "iset.dart";

/// First we have the items in [_s] and then the items in [_setOrS].
///
/// The [SAddAll] class does not check for duplicate elements. In other words,
/// it's up to the caller (in this case [S]) to make sure [_s] and [_setOrS]
/// do not contain any same elements.
///
class SAddAll<T> extends S<T> {
  final S<T> _s;

  // Will always store this as `Set` or [S].
  final Iterable<T> _setOrS;

  /// **Safe**.
  /// Note: If you need to pass an [ISet], pass its [S] instead.
  SAddAll(this._s, Iterable<T> items)
      : assert(items is! ISet),
        _setOrS = (items is S) ? items : Set.of(items);

  /// **Unsafe**.
  SAddAll.unsafe(this._s, Set<T> items) : _setOrS = items;

  @override
  bool get isEmpty => chainItems.isEmpty;

  @override
  S<T> get below => _s;

  @override
  int fillOwnItemsBefore(List<Object?> target, int end) {
    final Iterable<T> items = _setOrS;
    if (items is S<T>) return items.fillBefore(target, end);

    final int start = end - items.length;
    target.setRange(start, end, items);
    return start;
  }

  @override
  int get ownLength => _setOrS.length;

  @override
  void sendOwnItemsTo(ChainItemsReceiver<Object?> receiver) => receiver.receiveIterable(_setOrS);

  // The methods below use [chainItems], which doesn't use recursion,
  // so that they work for chains of any length.

  @override
  Iterator<T> get iterator => chainItems.iterator;

  @override
  Iterable<T> get iter => chainItems;

  @override
  List<T> toList({bool growable = true}) => chainItems.toList(growable: growable);

  @override
  Set<T> toSet() => chainItems.toSet();

  @override
  bool contains(covariant T? element) => chainContains(element);

  @override
  bool ownContains(Object? element) => _setOrS.contains(element);

  @override
  bool containsAll(Iterable<T> other) => chainContainsAll(other);

  @override
  T? lookup(T element) => chainLookup(element);

  @override
  int get length => chainItems.length;

  @override
  T get anyItem => chainItems.anyItem;

  @override
  T get first => chainItems.first;

  @override
  T get last => chainItems.last;

  @override
  T get single => chainItems.single;

  @override
  T operator [](int index) => chainItems.elementAt(index);
}

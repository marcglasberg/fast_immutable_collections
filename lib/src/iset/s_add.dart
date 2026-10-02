// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import '../iterator/chain_iterator.dart';
import "iset.dart";

/// The [SAdd] class does not check for duplicate elements. In other words,
/// it's up to the caller (in this case [S]) to make sure [_s] does not
/// contain [_item].
///
class SAdd<T> extends S<T> {
  final S<T> _s;
  final T _item;

  SAdd(this._s, this._item);

  @override
  bool get isEmpty => false;

  @override
  S<T> get below => _s;

  @override
  int fillOwnItemsBefore(List<Object?> target, int end) {
    target[end - 1] = _item;
    return end - 1;
  }

  @override
  int get ownLength => 1;

  @override
  void sendOwnItemsTo(ChainItemsReceiver<Object?> receiver) => receiver.receiveItem(_item);

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
  bool ownContains(Object? element) => _item == element;

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
  T get last => _item;

  @override
  T get single => chainItems.single;

  @override
  T operator [](int index) => chainItems.elementAt(index);
}

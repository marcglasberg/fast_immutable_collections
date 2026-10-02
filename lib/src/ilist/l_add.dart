// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "../iterator/chain_iterator.dart";
import "ilist.dart";

/// First we have the items in [_l] and then [_item].
class LAdd<T> extends L<T> {
  //
  final L<T> _l;
  final T _item;

  LAdd(this._l, this._item);

  /// Never null, because even if _item is null it's not empty.
  @override
  bool get isEmpty => false;

  @override
  L<T> get below => _l;

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
  bool contains(covariant T? element) => chainItems.contains(element);

  @override
  T operator [](int index) => chainItems.elementAt(index);

  @override
  int get length => chainItems.length;

  @override
  T get first => chainItems.first;

  @override
  T get last => _item;

  @override
  T get single => chainItems.single;
}

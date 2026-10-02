// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/src/iterator/chain_iterator.dart";

import "ilist.dart";

/// First we have the items in [_l] and then the items in [_listOrL].
///
class LAddAll<T> extends L<T> {
  //
  final L<T> _l;

  // Will always store this as `List` or [L].
  final Iterable<T> _listOrL;

  /// **Safe**.
  /// Note: If you need to pass an [IList], pass its [L] instead.
  LAddAll(this._l, Iterable<T> items)
      : assert(items is! IList),
        _listOrL = (items is L<T>) ? items : List<T>.of(items, growable: false);

  @override
  bool get isEmpty => chainItems.isEmpty;

  @override
  L<T> get below => _l;

  @override
  int fillOwnItemsBefore(List<Object?> target, int end) {
    final Iterable<T> items = _listOrL;
    if (items is L<T>) return items.fillBefore(target, end);

    final int start = end - (items as List<T>).length;
    target.setRange(start, end, items);
    return start;
  }

  @override
  int get ownLength => _listOrL.length;

  @override
  void sendOwnItemsTo(ChainItemsReceiver<Object?> receiver) {
    final Iterable<T> items = _listOrL;
    if (items is List<T>)
      receiver.receiveList(items);
    else
      receiver.receiveIterable(items);
  }

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
  T get last => chainItems.last;

  @override
  T get single => chainItems.single;
}

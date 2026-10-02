// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/src/iterator/chain_iterator.dart";
import 'package:meta/meta.dart';

import "imap.dart";

class MAddAll<K, V> extends M<K, V> {
  final M<K, V> _m, _items;

  MAddAll.unsafe(this._m, this._items);

  @override
  bool get isEmpty => chainKeys.isEmpty;

  // The methods below use the chain members of [M], which don't use
  // recursion, so that they work for chains of any length.

  @override
  Iterable<MapEntry<K, V>> get entries => chainEntries;

  @override
  Iterable<K> get keys => chainKeys;

  @override
  Iterable<V> get values => chainValues;

  @override
  Iterator<MapEntry<K, V>> get iterator => chainEntries.iterator;

  @override
  V? operator [](K key) => chainGet(key);

  /// This may be used to help avoid stack-overflow.
  @protected
  @override
  dynamic getVOrM(K key) => _items[key] ?? _m;

  /// Used by tail-call-optimisation.
  /// Returns type [bool] or [M].
  @protected
  @override
  dynamic containsKeyOrM(K? key) => _items.containsKey(key) ? true : _m;

  @override
  bool contains(K key, V value) => chainContains(key, value);

  @override
  bool containsKey(K? key) => chainContainsKey(key);

  @override
  bool containsValue(V? value) => chainValues.contains(value);

  @override
  int get length => chainKeys.length;

  @override
  M<K, V> get below => _m;

  @override
  int fillOwnEntriesBefore(Map<Object?, Object?> map, List<Object?> keys, int end,
          Map<Object?, Object?> replacements) =>
      _items.fillBefore(map, keys, end, replacements);

  @override
  int get ownLength => _items.length;

  @override
  void sendOwnEntriesTo(ChainItemsReceiver<Object?> receiver) =>
      receiver.receiveIterable(_items.entries);

  @override
  void sendOwnKeysTo(ChainItemsReceiver<Object?> receiver) => receiver.receiveIterable(_items.keys);

  @override
  void sendOwnValuesTo(ChainItemsReceiver<Object?> receiver) =>
      receiver.receiveIterable(_items.values);
}

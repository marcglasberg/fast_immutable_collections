// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import 'package:fast_immutable_collections/src/iterator/chain_iterator.dart';
import 'package:meta/meta.dart';

import "imap.dart";

class MAdd<K, V> extends M<K, V> {
  final M<K, V> _m;
  final K _key;
  final V _value;

  MAdd(this._m, this._key, this._value);

  @override
  bool get isEmpty => false;

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

  /// This may be used to help avoid stack-overflow.
  @protected
  @override
  dynamic getVOrM(K key) => (key == _key) ? _value : _m;

  /// Used by tail-call-optimisation.
  /// Returns type [bool] or [M].
  @protected
  @override
  dynamic containsKeyOrM(K? key) => (key == _key) ? true : _m;

  /// Implicitly uniting the maps.
  @override
  V? operator [](K key) {
    // This is the tail-call-optimisation for:
    // `V? operator [](K key) => (key == _key) ? _value : _m[key];`
    if ((key == _key)) {
      return _value;
    } else {
      dynamic vOrM = _m;
      while (vOrM is M) {
        vOrM = vOrM.getVOrM(key);
      }
      return vOrM as V?;
    }
  }

  @override
  bool containsKey(K? key) {
    // This is the tail-call-optimisation for:
    // `bool containsKey(K? key) => (key == _key) || _m.containsKey(key);`
    if ((key == _key))
      return true;
    else {
      dynamic vOrM = _m;
      while (vOrM is M) {
        vOrM = vOrM.containsKeyOrM(key);
        if (vOrM is bool) return vOrM;
      }
      return vOrM as bool;
    }
  }

  @override
  bool contains(K key, V value) => chainContains(key, value);

  @override
  bool containsValue(V? value) => chainValues.contains(value);

  @override
  int get length => chainKeys.length;

  @override
  M<K, V> get below => _m;

  @override
  int fillOwnEntriesBefore(
      Map<Object?, Object?> map, List<Object?> keys, int end, Map<Object?, Object?> replacements) {
    map[_key] = _value;
    keys[end - 1] = _key;
    return end - 1;
  }

  @override
  int get ownLength => 1;

  @override
  void sendOwnEntriesTo(ChainItemsReceiver<Object?> receiver) =>
      receiver.receiveItem(MapEntry<K, V>(_key, _value));

  @override
  void sendOwnKeysTo(ChainItemsReceiver<Object?> receiver) => receiver.receiveItem(_key);

  @override
  void sendOwnValuesTo(ChainItemsReceiver<Object?> receiver) => receiver.receiveItem(_value);
}

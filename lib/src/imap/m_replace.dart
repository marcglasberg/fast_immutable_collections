// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import 'dart:collection';

import 'package:fast_immutable_collections/src/iterator/chain_iterator.dart';
import 'package:meta/meta.dart';

import "imap.dart";

/// The [_m] already contains the [_key]. But the [_value] should be the new one.
class MReplace<K, V> extends M<K, V> {
  final M<K, V> _m;
  final K _key;
  final V _value;

  MReplace(this._m, this._key, this._value);

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

  /// Doesn't add any entries. It only replaces the value of an entry below it.
  @override
  int fillOwnEntriesBefore(
      Map<Object?, Object?> map, List<Object?> keys, int end, Map<Object?, Object?> replacements) {
    replacements.putIfAbsent(_key, () => _value);
    return end;
  }

  @override
  Iterator<MapEntry<K, V>> get iterator => chainEntries.iterator;

  /// Has no entries of its own. It only replaces the value of an entry below it.
  @override
  int get ownLength => 0;

  @override
  void sendOwnEntriesTo(ChainItemsReceiver<Object?> receiver) {}

  @override
  void sendOwnKeysTo(ChainItemsReceiver<Object?> receiver) {}

  @override
  void sendOwnValuesTo(ChainItemsReceiver<Object?> receiver) {}

  @override
  Map<Object?, Object?>? addReplacementTo(Map<Object?, Object?>? replacements) =>
      (replacements ?? HashMap<Object?, Object?>())..putIfAbsent(_key, () => _value);
}

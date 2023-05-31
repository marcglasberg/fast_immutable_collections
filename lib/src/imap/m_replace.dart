// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

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

  @override
  Iterable<MapEntry<K, V>> get entries =>
      _m.entries.map((entry) => (entry.key == _key) ? MapEntry(_key, _value) : entry);

  @override
  Iterable<K> get keys => _m.keys;

  @override
  Iterable<V> get values => entries.map((entry) => entry.value);

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
  bool contains(K key, V value) => (key == _key) //
      ? value == _value
      : _m.contains(key, value);

  @override
  bool containsValue(V? value) => entries.any((entry) => entry.value == value);

  @override
  int get length => _m.length;

  @override
  Iterator<MapEntry<K, V>> get iterator => entries.iterator;
}

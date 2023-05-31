// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import 'package:fast_immutable_collections/src/iterator/iterator_add.dart';
import 'package:meta/meta.dart';

import "imap.dart";

class MAdd<K, V> extends M<K, V> {
  final M<K, V> _m;
  final K _key;
  final V _value;

  MAdd(this._m, this._key, this._value);

  @override
  bool get isEmpty => false;

  @override
  Iterable<MapEntry<K, V>> get entries => _m.entries.followedBy([MapEntry<K, V>(_key, _value)]);

  @override
  Iterable<K> get keys => _m.keys.followedBy(<K>[_key]);

  @override
  Iterable<V> get values => _m.values.followedBy(<V>[_value]);

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
  bool contains(K key, V value) => (key == _key && value == _value) || _m.contains(key, value);

  @override
  bool containsValue(V? value) => (value == _value) || _m.containsValue(value);

  @override
  int get length => _m.length + 1;

  @override
  Iterator<MapEntry<K, V>> get iterator => IteratorAdd(_m.iterator, MapEntry(_key, _value));
}

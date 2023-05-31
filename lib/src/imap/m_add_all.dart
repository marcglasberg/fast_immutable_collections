// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/src/iterator/iterator_add_all.dart";
import 'package:meta/meta.dart';

import "imap.dart";

class MAddAll<K, V> extends M<K, V> {
  final M<K, V> _m, _items;

  MAddAll.unsafe(this._m, this._items);

  @override
  bool get isEmpty => _m.isEmpty && _items.isEmpty;

  @override
  Iterable<MapEntry<K, V>> get entries => _m.entries.followedBy(_items.entries);

  @override
  Iterable<K> get keys => _m.keys.followedBy(_items.keys);

  @override
  Iterable<V> get values => _m.values.followedBy(_items.values);

  @override
  V? operator [](K key) => _items[key] ?? _m[key];

  /// This may be used to help avoid stack-overflow.
  @protected
  @override
  dynamic getVOrM(K key) => _items[key] ?? _m;

  /// Used by tail-call-optimisation.
  /// Returns type [bool] or [M].
  @protected
  @override
  dynamic containsKeyOrM(K? key) => _items.containsKey(key) || _m.containsKey(key);

  @override
  bool contains(K key, V value) {
    final V? _value = _items[key] ?? _m[key];
    return value == _value;
  }

  @override
  bool containsKey(K? key) => _items.containsKey(key) || _m.containsKey(key);

  @override
  bool containsValue(V? value) => _items.containsValue(value) || _m.containsValue(value);

  @override
  int get length => _m.length + _items.length;

  @override
  Iterator<MapEntry<K, V>> get iterator => IteratorAddAll(_m.iterator, _items.iterator);
}

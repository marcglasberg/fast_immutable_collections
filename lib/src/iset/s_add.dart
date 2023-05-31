// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import '../iterator/iterator_add.dart';
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
  Iterator<T> get iterator => IteratorAdd(_s.iterator, _item);

  @override
  Iterable<T> get iter => _s.followedBy([_item]);

  @override
  bool contains(covariant T? element) => _s.contains(element) || _item == element;

  @override
  bool containsAll(Iterable<T> other) {
    for (final o in other) {
      if ((_item != o) && (!_s.contains(o))) return false;
    }
    return true;
  }

  @override
  T? lookup(T element) {
    T? result = _s.lookup(element);
    result ??= (_item == element) ? _item : null;
    return result;
  }

  @override
  Set<T> difference(Set<T> other) {
    if (other.contains(_item)) {
      return _s.difference(other);
    } else {
      return _s.difference(other)..add(_item);
    }
  }

  @override
  Set<T> intersection(Set<T> other) {
    final containsItem = other.contains(_item);
    final result = _s.intersection(other);
    if (containsItem) result.add(_item);
    return result;
  }

  @override
  Set<T> union(Set<T> other) => _s.union({_item})..addAll(other);

  @override
  int get length => _s.length + 1;

  @override
  T get anyItem => _item;

  @override
  T get first => _s.isEmpty ? _item : _s.first;

  @override
  T get last => _item;

  @override
  T get single => _s.isEmpty ? _item : throw StateError("Too many elements");

  @override
  T operator [](int index) {
    final sLength = _s.length;
    if (index < 0 || index >= sLength + 1) throw RangeError.range(index, 0, sLength + 1, "index");
    return (index < sLength) ? _s[index] : _item;
  }
}

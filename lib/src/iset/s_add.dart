import "iset.dart";

// /////////////////////////////////////////////////////////////////////////////

/// The [SAdd] class does not check for duplicate elements. In other words,
/// it's up to the caller (in this case [S]) to make sure [_s] does not
/// contain [_item].
///
class SAdd<T> extends S<T> {
  final S<T> _s;
  final T _item;

  SAdd(this._s, this._item) : assert(_s != null);

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorSAdd(_s.iterator, _item);

  @override
  Iterable<T> get iter => _s.followedBy([_item]);

  @override
  bool contains(covariant T element) => _s.contains(element) ? true : _item == element;

  @override
  bool containsAll(Iterable<T> other) {
    for (var o in other) {
      if ((_item != o) && (!_s.contains(o))) return false;
    }
    return true;
  }

  @override
  Set<T> difference(covariant Set<T> other) =>
      _s.difference(other)
        ..remove(_item);

  @override
  Set<T> intersection(covariant Set<T> other) {
    var containsItem = other.contains(_item);
    var result = _s.intersection(other);
    if (containsItem) result.add(_item);
    return result;
  }

  @override
  Set<T> union(covariant Set<T> other) =>
      _s.union({_item})
        ..addAll(other);

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
    var sLength = _s.length;
    if (index < 0 || index >= sLength + 1) throw RangeError.range(index, 0, sLength + 1, "index");
    return (index < sLength) ? _s[index] : _item;
  }
}

// /////////////////////////////////////////////////////////////////////////////

class IteratorSAdd<T> implements Iterator<T> {
  Iterator<T> iterator;
  T item, _current;
  int extraMove;

  IteratorSAdd(this.iterator, this.item)
      : _current = iterator.current,
        extraMove = 0;

  @override
  T get current => _current;

  @override
  bool moveNext() {
    final bool isMoving = iterator.moveNext();
    if (isMoving) {
      _current = iterator.current;
    } else {
      extraMove++;
      _current = extraMove == 1 ? item : null;
    }
    return extraMove <= 1;
  }
}

// /////////////////////////////////////////////////////////////////////////////

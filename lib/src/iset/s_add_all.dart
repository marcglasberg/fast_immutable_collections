import "iset.dart";

// /////////////////////////////////////////////////////////////////////////////

/// Note that adding repeated members won't work as the expected behavior for regular [Set]s,
/// because that behavior is implemented elsewhere ([S]).
class SAddAll<T> extends S<T> {
  final S<T> _s;

  // Will always store this as `Set` or [S].
  final Iterable<T> _setOrS;

  /// **Safe**.
  /// Note: If you need to pass an [ISet], pass its [S] instead.
  SAddAll(this._s, Iterable<T> items)
      : assert(_s != null),
        assert(items != null),
        assert(items is! ISet),
        _setOrS = (items is S) ? items : Set.of(items);

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorSAddAll(_s.iterator, _setOrS);

  @override
  bool contains(Object element) {
    // Check the real set first (It's faster).
    if (_setOrS.contains(element)) return true;
    return _s.contains(element);
  }

  @override
  int get length => _s.length + _setOrS.length;
}

// /////////////////////////////////////////////////////////////////////////////

class IteratorSAddAll<T> implements Iterator<T> {
  Iterator<T> iterator, iteratorItems;
  Iterable<T> items;
  T _current;
  int extraMove;

  IteratorSAddAll(this.iterator, this.items)
      : _current = iterator.current,
        extraMove = 0;

  @override
  T get current => _current;

  @override
  bool moveNext() {
    bool isMoving = iterator.moveNext();
    if (isMoving) {
      _current = iterator.current;
    } else {
      iteratorItems ??= items.iterator;
      isMoving = iteratorItems.moveNext();
      if (isMoving) {
        _current = iteratorItems.current;
      } else {
        _current = null;
      }
    }
    return isMoving;
  }
}

// /////////////////////////////////////////////////////////////////////////////

import 'iset.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class SAddAll<T> extends S<T> {
  final S<T> _s;
  final Set<T> _items;

  SAddAll.unsafe(this._s, this._items)
      : assert(_s != null),
        assert(_items != null);

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorSAddAll(_s.iterator, _items);

  @override
  // Check the real set first (it's faster).
  bool contains(Object element) => _items.contains(element) ? true : _s.contains(element);

  @override
  int get length => _s.length + _items.length;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

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

// /////////////////////////////////////////////////////////////////////////////////////////////////

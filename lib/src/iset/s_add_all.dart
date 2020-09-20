import 'package:fast_immutable_collections/fast_immutable_collections.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class SAddAll<T> extends S<T> {
  final S<T> _l;
  final Iterable<T> _items;

  SAddAll(this._l, this._items)
      : assert(_l != null),
        assert(_items != null);

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorSAddAll(_l.iterator, _items);

  @override
  bool contains(Object element) {
    if (_l.contains(element)) return true;
    return _items.contains(element);
  }

  @override
  int get length => _l.length + _items.length;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IteratorSAddAll<T> implements Iterator<T> {
  Iterator<T> iterator;

  Iterable<T> items;
  Iterator<T> iteratorItems;

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
    if (isMoving)
      _current = iterator.current;
    else {
      iteratorItems ??= items.iterator;
      isMoving = iteratorItems.moveNext();
      if (isMoving)
        _current = iteratorItems.current;
      else
        _current = null;
    }
    return isMoving;
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

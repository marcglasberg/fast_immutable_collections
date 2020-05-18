import '../fast_immutable_collections.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class L3<T> extends L<T> {
  L<T> l;
  Iterable<T> items;

  L3(this.l, this.items);

  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorL3(l.iterator, items);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IteratorL3<T> implements Iterator<T> {
  Iterator<T> iterator;

  Iterable<T> items;
  Iterator<T> iteratorItems;

  T _current;
  int extraMove;

  IteratorL3(this.iterator, this.items)
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
      if (iteratorItems == null) iteratorItems = items.iterator;
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

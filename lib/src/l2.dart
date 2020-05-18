import '../fast_immutable_collections.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class L2<T> extends L<T> {
  L<T> l;
  T item;

  L2(this.l, this.item);

  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorL2(l.iterator, item);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IteratorL2<T> implements Iterator<T> {
  Iterator<T> iterator;
  T item;
  T _current;
  int extraMove;

  IteratorL2(this.iterator, this.item)
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
      extraMove++;
      _current = (extraMove == 1) ? item : null;
    }
    return extraMove <= 1;
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

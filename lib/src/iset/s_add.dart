import 'iset.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class SAdd<T> extends S<T> {
  final S<T> _s;
  final T _item;

  SAdd(this._s, this._item)
      : assert(_s != null),
        assert(_item != null);

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorSAdd(_s.iterator, _item);

  @override
  bool contains(Object element) {
    if (_item == element) return true;
    return _s.contains(element);
  }

  @override
  int get length => _s.length + 1;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IteratorSAdd<T> implements Iterator<T> {
  Iterator<T> iterator;
  T item;
  T _current;
  int extraMove;

  IteratorSAdd(this.iterator, this.item)
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

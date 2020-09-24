import 'ilist.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class LAddAll<T> extends L<T> {
  final L<T> _l;
  final Iterable<T> _items;

  LAddAll(this._l, this._items)
      : assert(_l != null),
        assert(_items != null);

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorLAddAll(_l.iterator, _items);

  @override
  T operator [](int index) {
    if (index < 0 || index >= length)
      throw RangeError.range(index, 0, length - 1, 'index');

    /// FALTA FAZER DE FORMA EFICIENTE:
    /// FALTA FAZER DE FORMA EFICIENTE:
    /// FALTA FAZER DE FORMA EFICIENTE:
    /// FALTA FAZER DE FORMA EFICIENTE:
    return super[index];
  }

  @override
  int get length => _l.length + _items.length;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IteratorLAddAll<T> implements Iterator<T> {
  Iterator<T> iterator;

  Iterable<T> items;
  Iterator<T> iteratorItems;

  T _current;
  int extraMove;

  IteratorLAddAll(this.iterator, this.items)
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

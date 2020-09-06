import 'package:fast_immutable_collections/fast_immutable_collections.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class L3<T> extends L<T> {
  final L<T> _l;
  final Iterable<T> _items;

  L3(this._l, this._items)
      : assert(_l != null),
        assert(_items != null);

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorL3(_l.iterator, _items);

  @override
  T operator [](int index) {
    if (index < 0 || index >= length) throw RangeError.range(index, 0, length - 1, "index");

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

import "ilist.dart";

// /////////////////////////////////////////////////////////////////////////////////////////////////

class LAdd<T> extends L<T> {
  final L<T> _l;
  final T _item;

  LAdd(this._l, this._item)
      : assert(_l != null),
        assert(_item != null);

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorLAdd(_l.iterator, _item);

  /// Implicitly uniting the lists.
  @override
  T operator [](int index) => index < 0 || index >= length
      ? throw RangeError.range(index, 0, length - 1, "index")
      : index == length - 1
          ? _item
          : _l[index];

  @override
  bool contains(Object element) => _l.contains(element) ? true : _item == element;

  @override
  int get length => _l.length + 1;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IteratorLAdd<T> implements Iterator<T> {
  Iterator<T> iterator;
  T item, _current;
  int extraMove;

  IteratorLAdd(this.iterator, this.item)
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
      _current = (extraMove == 1) ? item : null;
    }
    return extraMove <= 1;
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

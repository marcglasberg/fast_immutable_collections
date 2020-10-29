import "iset.dart";

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// Note that adding repeated members won"t work as the expected behavior for regular `Set`s,
/// because that behavior is implemented elsewhere ([S]).
class SAdd<T> extends S<T> {
  final S<T> _s;
  final T _item;

  SAdd(this._s, this._item)
      : assert(_s != null),
        assert(_item != null);

  @override
  bool contains(Object element) => _item == element ? true : _s.contains(element);

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorSAdd(_s.iterator, _item);

  @override
  int get length => _s.length + 1;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

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

// /////////////////////////////////////////////////////////////////////////////////////////////////

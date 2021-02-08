import "ilist.dart";

// /////////////////////////////////////////////////////////////////////////////

/// First we have the items in [_l] and then [_item].
class LAdd<T> extends L<T> {
  final L<T> _l;
  final T _item;

  LAdd(this._l, this._item) : assert(_l != null);

  /// Never null, because even if _item is null it's not empty.
  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorLAdd(_l.iterator, _item);

  @override
  Iterable<T> get iter => _l.followedBy([_item]);

  @override
  bool contains(covariant T element) => _l.contains(element) ? true : _item == element;

  /// Implicitly uniting the list and the item.
  @override
  T operator [](int index) => index < 0 || index >= length
      ? throw RangeError.range(index, 0, length - 1, "index")
      : index == length - 1
          ? _item
          : _l[index];

  @override
  int get length => _l.length + 1;

  @override
  T get first => _l.isEmpty ? _item : _l.first;

  @override
  T get last => _item;

  @override
  T get single => _l.isEmpty ? _item : throw StateError("Too many elements");
}

// /////////////////////////////////////////////////////////////////////////////

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

// /////////////////////////////////////////////////////////////////////////////

import 'ilist.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class LAddAll<T> extends L<T> {
  final L<T> _l;

  // Will always store this as List or L.
  final Iterable<T> _items;

  /// Safe.
  /// Note: If you need to pass an IList, pass its [L] instead.
  LAddAll(this._l, Iterable<T> items)
      : assert(_l != null),
        assert(items != null),
        assert(items is! IList),
        _items = (items is L) ? items : List.of(items, growable: false);

  @override
  bool get isEmpty => _l.isEmpty && _items.isEmpty;

  @override
  Iterator<T> get iterator => IteratorLAddAll(_l.iterator, _items);

  /// TODO: FALTA FAZER DE FORMA EFICIENTE:
  @override
  T operator [](int index) => index < 0 || index >= length
      ? throw RangeError.range(index, 0, length - 1, 'index')
      : super[index];

  @override
  int get length => _l.length + _items.length;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IteratorLAddAll<T> implements Iterator<T> {
  Iterator<T> iterator, iteratorItems;
  Iterable<T> items;
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

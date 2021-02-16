class IteratorAddAll<T> implements Iterator<T> {
  Iterator<T> iterator, iteratorItems;
  Iterable<T> items;
  T _current;
  int extraMove;

  IteratorAddAll(this.iterator, this.items)
      : _current = iterator.current,
        extraMove = 0,
        iteratorItems = items.iterator;

  @override
  T get current => _current;

  @override
  bool moveNext() {
    if (iterator.moveNext()) {
      _current = iterator.current;
      return true;
    } else {
      if (iteratorItems.moveNext()) {
        _current = iteratorItems.current;
        return true;
      } else
        return false;
    }
  }
}

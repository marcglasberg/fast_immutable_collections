class IteratorAddAll<T> implements Iterator<T> {
  Iterator<T> iterator, iteratorItems;

  T _current;
  int extraMove;

  IteratorAddAll(this.iterator, this.iteratorItems)
      : _current = iterator.current,
        extraMove = 0;

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

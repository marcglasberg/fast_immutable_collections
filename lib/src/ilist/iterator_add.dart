class IteratorAdd<T> implements Iterator<T> {
  Iterator<T> iterator;
  T item, _current;
  bool extraMove;

  IteratorAdd(this.iterator, this.item)
      : _current = iterator.current,
        extraMove = false;

  @override
  T get current => _current;

  @override
  bool moveNext() {
    if (iterator.moveNext()) {
      _current = iterator.current;
      return true;
    } else {
      if (extraMove)
        return false;
      else {
        extraMove = true;
        _current = item;
        return true;
      }
    }
  }
}

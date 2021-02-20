class IteratorAdd<T> implements Iterator<T> {
  Iterator<T> iterator;
  T item;
  T? _current;
  bool extraMove, _pre;

  IteratorAdd(this.iterator, this.item)
      : _pre = true,
        _current = null,
        extraMove = false;

  @override
  T get current {
    if (_pre) throw StateError("No current value available. Call moveNext() first.");
    return _current!;
  }

  @override
  bool moveNext() {
    _pre = false;
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

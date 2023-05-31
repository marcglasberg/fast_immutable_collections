// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

class IteratorAddAll<T> implements Iterator<T> {
  Iterator<T> iterator, iteratorItems;
  late T _current;
  bool extraMove, _pre, _hasCurrent;

  IteratorAddAll(this.iterator, this.iteratorItems)
      : _pre = true,
        _hasCurrent = true,
        extraMove = false;

  @override
  T get current {
    if (_pre) throw StateError("No current value available. Call moveNext() first.");
    if (!_hasCurrent) throw StateError("No move values available.");
    return _current;
  }

  @override
  bool moveNext() {
    _pre = false;
    if (iterator.moveNext()) {
      _current = iterator.current;
      return true;
    } else {
      if (iteratorItems.moveNext()) {
        _current = iteratorItems.current;
        return true;
      } else
        return _hasCurrent = false;
    }
  }
}

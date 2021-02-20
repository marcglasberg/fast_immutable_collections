import "../ilist/iterator_add_all.dart";
import "iset.dart";

/// First we have the items in [_s] and then the items in [_setOrS].
///
/// The [SAddAll] class does not check for duplicate elements. In other words,
/// it's up to the caller (in this case [S]) to make sure [_s] and [_setOrS]
/// do not contain any same elements.
///
class SAddAll<T> extends S<T> {
  final S<T> _s;

  // Will always store this as `Set` or [S].
  final Iterable<T> _setOrS;

  /// **Safe**.
  /// Note: If you need to pass an [ISet], pass its [S] instead.
  SAddAll(this._s, Iterable<T> items)
      : assert(items is! ISet),
        _setOrS = (items is S) ? items : Set.of(items);

  /// **Unsafe**.
  SAddAll.unsafe(this._s, Set<T> items) : _setOrS = items;

  @override
  bool get isEmpty => false;

  @override
  Iterator<T> get iterator => IteratorAddAll(_s.iterator, _setOrS.iterator);

  @override
  Iterable<T> get iter => _s.followedBy(_setOrS);

  @override
  bool contains(covariant T element) {
    // Check the real set first (It's probably faster).
    return _setOrS.contains(element) || _s.contains(element);
  }

  @override
  bool containsAll(Iterable<T> other) {
    for (var o in other) {
      if ((!_setOrS.contains(o)) && (!_s.contains(o))) return false;
    }
    return true;
  }

  @override
  T? lookup(T element) {
    T? result = _s.lookup(element);

    if (result != null)
      return result;
    else if (_setOrS is S)
      return (_setOrS as S<T>).lookup(element);
    else if (_setOrS is Set)
      return (_setOrS as Set<T>).lookup(element);
    else
      throw AssertionError();
  }

  @override
  Set<T> difference(Set<T> other) => _s.difference(other)..removeAll(_setOrS);

  @override
  Set<T> intersection(Set<T> other) =>
      _s.intersection(other)..addAll(_setOrS.toSet().intersection(other));

  @override
  Set<T> union(Set<T> other) => _s.union(_setOrS.toSet())..addAll(other);

  @override
  int get length => _s.length + _setOrS.length;

  @override
  T get anyItem => _s.first;

  @override
  T get first => _s.isNotEmpty ? _s.first : _setOrS.first;

  @override
  T get last => _setOrS.isNotEmpty ? _setOrS.last : _s.last;

  @override
  T get single => _s.isNotEmpty ? _s.single : _setOrS.single;

  @override
  T operator [](int index) {
    var sLength = _s.length;
    return (index < sLength) ? _s[index] : _setOrS.elementAt(index - sLength);
  }
}

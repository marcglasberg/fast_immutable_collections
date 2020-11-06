import "dart:collection";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

class ModifiableSetView<T> with SetMixin<T> implements Set<T>, CanBeEmpty {
  ISet<T> _iSet;
  Set<T> _set;

  ModifiableSetView(ISet<T> iSet)
      : _iSet = iSet,
        _set = iSet == null ? {} : null;

  @override
  bool add(T value) {
    _switchToMutableSetIfNecessary();
    return _setAdd(value);
  }

  void _switchToMutableSetIfNecessary() {
    if (_set == null) {
      _set = _iSet.unlock;
      _iSet = null;
    }
  }

  bool _setAdd(T value) {
    if (_set.contains(value)) {
      return false;
    } else {
      _set.add(value);
      return true;
    }
  }

  @override
  bool contains(Object element) => _iSet?.contains(element) ?? _set.contains(element);

  @override
  T lookup(Object element) =>
      _iSet != null && _iSet.contains(element) || _set != null && _set.contains(element)
          ? element as T
          : null;

  @override
  bool remove(Object value) {
    _switchToMutableSetIfNecessary();
    return _setRemove(value);
  }

  bool _setRemove(Object value) {
    if (_set.contains(value)) {
      _set.remove(value);
      return true;
    } else {
      return false;
    }
  }

  @override
  Iterator<T> get iterator => _set?.iterator ?? _iSet.iterator;

  @override
  Set<T> toSet() => _set ?? _iSet.toSet();

  @override
  int get length => _iSet?.length ?? _set.length;

  ISet<T> get lock => _iSet ?? ISet<T>(_set);
}

// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// The [ModifiableSetFromISet] is a safe, modifiable [Set] that is built from an [ISet].
/// The construction of the set is fast at first, since it makes no copies of the
/// [ISet] items, but just uses it directly.
///
/// If and only if you use a method that mutates the set, like [add],
/// it will unlock internally (make a copy of all [ISet] items).
/// This is transparent to you, and will happen at most only once.
/// In other words, it will unlock the [ISet], lazily, only if necessary.
///
/// If you never mutate the set, it will be very fast to lock this set
/// back into an [ISet].
///
/// See also: [UnmodifiableSetFromISet]
///
class ModifiableSetFromISet<T> with SetMixin<T> implements Set<T>, CanBeEmpty {
  ISet<T>? _iSet;
  Set<T>? _set;

  ModifiableSetFromISet(ISet<T>? iset)
      : _iSet = iset,
        _set = iset == null ? {} : null;

  @override
  bool add(T value) {
    _switchToMutableSetIfNecessary();
    return _setAdd(value);
  }

  void _switchToMutableSetIfNecessary() {
    if (_set == null) {
      _set = _iSet!.unlock;
      _iSet = null;
    }
  }

  bool _setAdd(T value) {
    if (_set!.contains(value)) {
      return false;
    } else {
      _set!.add(value);
      return true;
    }
  }

  @override
  bool contains(covariant T? element) => _iSet?.contains(element) ?? _set!.contains(element);

  @override
  T? lookup(covariant T element) => contains(element) ? element : null;

  @override
  bool remove(Object? value) {
    _switchToMutableSetIfNecessary();
    return _setRemove(value);
  }

  bool _setRemove(Object? value) {
    if (_set!.contains(value)) {
      _set!.remove(value);
      return true;
    } else {
      return false;
    }
  }

  @override
  Iterator<T> get iterator => _set?.iterator ?? _iSet!.iterator;

  @override
  Set<T> toSet() => _set ?? _iSet!.toSet();

  @override
  int get length => _iSet?.length ?? _set!.length;

  ISet<T?> get lock => _iSet ?? ISet<T?>(_set);
}

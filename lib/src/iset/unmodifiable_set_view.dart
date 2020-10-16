import 'dart:collection';

import 'package:meta/meta.dart';

import '../immutable_collection.dart';
import '../iset/iset.dart';

@immutable
class UnmodifiableSetView<T> with SetMixin<T> implements Set<T>, CanBeEmpty {
  final ISet<T> _iSet;
  final Set<T> _set;

  UnmodifiableSetView(ISet<T> iSet)
      : _iSet = iSet ?? ISet.empty<T>(),
        _set = null;

  UnmodifiableSetView.fromSet(Set<T> set)
      : _iSet = null,
        _set = set;

  @override
  bool add(T value) => throw UnsupportedError('Set is unmodifiable.');

  @override
  bool contains(Object element) => _iSet?.contains(element) ?? _set.contains(element);

  @override
  T lookup(Object element) =>
      _iSet != null && _iSet.contains(element) || _set != null && _set.contains(element)
          ? element as T
          : null;

  @override
  bool remove(Object value) => throw UnsupportedError('Set is unmodifiable.');

  @override
  Iterator<T> get iterator => _set?.iterator ?? _iSet.iterator;

  @override
  Set<T> toSet() => _set ?? _iSet.toSet();

  @override
  int get length => _iSet?.length ?? _set.length;

  ISet<T> get lock => _iSet ?? _set.lock;
}

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

  UnmodifiableSetView.from(Set<T> set)
      : _iSet = null,
        _set = set;

  @override
  bool add(T value) => throw UnsupportedError('Set is unmodifiable.');

  @override
  bool contains(Object element) => throw UnimplementedError('Not implemented yet.');

  @override
  T lookup(Object element) => throw UnimplementedError('Not implemented yet.');

  @override
  bool remove(Object value) => throw UnsupportedError('Set is unmodifiable.');

  @override
  Iterator<T> get iterator => throw UnimplementedError('Not implemented yet.');

  @override
  Set<T> toSet() => _set ?? _iSet.toSet();

  @override
  int get length => _iSet?.length ?? _set.length;

  ISet<T> get lock => _iSet ?? _set.lock;
}

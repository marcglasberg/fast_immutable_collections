import 'dart:collection';

import 'package:meta/meta.dart';

import '../immutable_collection.dart';
import '../iset/iset.dart';

@immutable
class ModifiableSetView<T> with SetMixin<T> implements Set<T>, CanBeEmpty {
  ISet<T> _iSet;
  Set<T> _set;

  ModifiableSetView(ISet<T> iSet) : _iSet = iSet ?? ISet.empty<T>();

  @override
  bool add(T value) => throw UnimplementedError('Not yet implemented');

  @override
  bool contains(Object element) => throw UnimplementedError('Not yet implemented');

  @override
  T lookup(Object element) => throw UnimplementedError('Not yet implemented');

  @override
  bool remove(Object value) => throw UnimplementedError('Not yet implemented');

  @override
  Iterator<T> get iterator => throw UnimplementedError('Not yet implemented');

  @override
  Set<T> toSet() => throw UnimplementedError('Not yet implemented');

  @override
  int get length => throw UnimplementedError('Not yet implemented');

  ISet<T> get lock => throw UnimplementedError('Not yet implemented');
}

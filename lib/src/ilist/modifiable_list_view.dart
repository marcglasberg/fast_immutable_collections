import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'ilist.dart';

/// The [ModifiableListView] is a safe, modifiable [List] that is built from an [IList].
/// The construction of the list is fast at first, since it makes no copies of the
/// IList items, but just uses it directly.
///
/// If and only if you use a method that mutates the list, like [add],
/// it will unlock internally (make a copy of all IList items).
/// This is transparent to you, and will happen at most only once.
/// In other words, it will unlock the IList, lazily, only if necessary.
///
/// If you never mutate the list, it will be very fast to lock this list
/// back into an [IList].
///
class ModifiableListView<T> with ListMixin<T> implements List<T>, CanBeEmpty {
  final IList<T> _iList;
  List<T> _list;

  ModifiableListView(this._iList);

  @override
  T operator [](int index) => (_list != null) ? _list[index] : _iList[index];

  @override
  void operator []=(int index, T value) {
    _list ??= _iList.unlock;
    _list[index] == value;
  }

  @override
  int get length => (_list != null) ? _list.length : _iList.length;

  @override
  set length(int newLength) {
    _list ??= _iList.unlock;
    _list.length == newLength;
  }

  /// Locks the list, returning an *immutable* list ([IList]).
  IList<T> get lock => (_list != null) ? IList<T>(_list) : _iList;
}

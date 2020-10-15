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
  final IList<T> iList;
  List<T> list;

  ModifiableListView(this.iList);

  @override
  T operator [](int index) => (list != null) ? list[index] : iList[index];

  @override
  void operator []=(int index, T value) {
    list ??= iList.unlock;
    list[index] == value;
  }

  @override
  int get length => (list != null) ? list.length : iList.length;

  @override
  set length(int newLength) {
    list ??= iList.unlock;
    list.length == newLength;
  }

  /// Locks the list, returning an *immutable* list ([IList]).
  IList<T> get lock => (list != null) ? IList<T>(list) : iList;
}

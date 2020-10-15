import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'ilist.dart';
import 'package:meta/meta.dart';

/// The [UnmodifiableListView] is a safe, unmodifiable [List] that is built from an [IList].
/// The construction of the list is fast, since it makes no copies of the
/// IList items, but just uses it directly.
///
/// If you try to use methods that modify the list, like [add], it will throw
/// an [UnsupportedError].
///
/// It is also very fast to lock this list back into an [IList].
///
@immutable
class UnmodifiableListView<T> with ListMixin<T> implements List<T>, CanBeEmpty {
  final IList<T> iList;

  UnmodifiableListView(this.iList);

  @override
  T operator [](int index) => iList[index];

  @override
  void operator []=(int index, T value) {
    throw UnsupportedError("List in unmodifiable.");
  }

  @override
  int get length => iList.length;

  @override
  set length(int newLength) {
    throw UnsupportedError("List in unmodifiable.");
  }

  /// Locks the list, returning an *immutable* list ([IList]).
  IList<T> get lock => iList;
}

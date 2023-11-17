// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";

/// The [UnmodifiableListFromIList] is a relatively safe, unmodifiable [List] view that is built
/// from an [IList] or another [List]. The construction of the [UnmodifiableListFromIList] is very
/// fast, since it makes no copies of the given list items, but just uses it directly.
///
/// If you try to use methods that modify the [UnmodifiableListFromIList], like [add],
/// it will throw an [UnsupportedError].
///
/// If you create it from an [IList], it is also very fast to lock the [UnmodifiableListFromIList]
/// back into an [IList].
///
/// <br>
///
/// ## How does it compare to Dart's native [List.unmodifiable] and [UnmodifiableListView]?
///
/// [List.unmodifiable] is slow, but it's always safe, because *it is not a view*, and
/// actually creates a new list. On the other hand, both [UnmodifiableListFromIList] and
/// [UnmodifiableListView] are fast, but if you create them from a regular [List] and then modify
/// that original [List], you will also be modifying the views. Also note, if you create an
/// [UnmodifiableListFromIList] from an [IList], then it's totally safe because the original [IList]
/// can't be modified.
///
/// The only different between an [UnmodifiableListFromIList] and an [UnmodifiableListView] is that
/// [UnmodifiableListFromIList] accepts both a [List] and an [IList].
///
/// See also: [ModifiableListFromIList]
///
@immutable
class UnmodifiableListFromIList<T> with ListMixin<T> implements List<T>, CanBeEmpty {
  //
  final IList<T>? _iList;
  final List<T>? _list;

  /// Create an unmodifiable [List] view of type [UnmodifiableListFromIList], from an [ilist].
  UnmodifiableListFromIList(IList<T>? ilist)
      : _iList = (ilist != null) ? ilist : IList<T>(),
        _list = null;

  /// Create an unmodifiable [List] view of type [UnmodifiableListFromIList], from another [List].
  UnmodifiableListFromIList.fromList(List<T> list)
      : _iList = null,
        _list = list;

  @override
  T operator [](int index) {
    return (_iList != null) ? _iList[index] : _list![index];
  }

  @override
  void operator []=(int index, T? value) => throw UnsupportedError("List in unmodifiable.");

  @override
  int get length => (_iList != null) ? _iList.length : _list!.length;

  @override
  set length(int newLength) => throw UnsupportedError("List in unmodifiable.");

  @override
  void add(T? value) => throw UnsupportedError("List in unmodifiable.");

  @override
  void addAll(Iterable<T> values) => throw UnsupportedError("List in unmodifiable.");

  /// Locks the list, returning an *immutable* list ([IList]).
  IList<T?>? get lock => (_iList != null) ? _iList : _list!.lock;
}

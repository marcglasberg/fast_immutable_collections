// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// The [ModifiableListFromIList] is a safe, modifiable [List] that is built from an [IList].
/// The construction of the list is fast at first, since it makes no copies of the
/// [IList] items, but just uses it directly.
///
/// If and only if you use a method that mutates the list, like [add],
/// it will unlock internally (make a copy of all [IList] items).
/// This is transparent to you, and will happen at most only once.
/// In other words, it will unlock the [IList], lazily, only if necessary.
///
/// If you never mutate the list, it will be very fast to lock this list
/// back into an [IList].
///
/// See also: [UnmodifiableListFromIList]
///
class ModifiableListFromIList<T> with ListMixin<T> implements List<T>, CanBeEmpty {
  //
  IList<T>? _iList;
  List<T>? _list;

  ModifiableListFromIList(IList<T>? ilist)
      : _iList = ilist,
        _list = (ilist == null) ? [] : null;

  @override
  T operator [](int index) => (_list != null) ? _list![index] : _iList![index];

  @override
  void operator []=(int index, T value) {
    if (_list == null) {
      _list = _iList!.unlock;
      _iList = null; // To allow for garbage-collection.
    }
    _list![index] = value;
  }

  @override
  int get length => (_list != null) ? _list!.length : _iList!.length;

  /// Changes the length of this list (the list is growable).
  /// If [newLength] is greater than current length,
  /// new entries are initialized to `null`,
  /// so [newLength] must not be greater than the current length
  /// if the element type [E] is non-nullable.
  @override
  set length(int newLength) {
    if (_list == null) {
      _list = _iList!.unlock;
      _iList = null; // To allow for garbage-collection.
    }

    _list!.length = newLength;
  }

  @override
  void add(T value) {
    if (_list == null) {
      _list = _iList!.unlock;
      _iList = null; // To allow for garbage-collection.
    }
    _list!.add(value);
  }

  @override
  void addAll(Iterable<T> values) {
    if (_list == null) {
      _list = _iList!.unlock;
      _iList = null; // To allow for garbage-collection.
    }
    _list!.addAll(values);
  }

  /// Locks the list, returning an *immutable* list ([IList]).
  IList<T> get lock => (_list != null) ? IList<T>(_list) : _iList!;
}

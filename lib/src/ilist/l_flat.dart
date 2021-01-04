import "package:collection/collection.dart";

import "ilist.dart";

class LFlat<T> extends L<T> {
  final List<T> _list;

  static L<T> empty<T>() => LFlat.unsafe(<T>[]);

  /// **Safe**.
  LFlat(Iterable<T> iterable)
      : assert(iterable != null),
        _list = List.of(iterable, growable: false);

  LFlat.unsafe(this._list) : assert(_list != null);

  @override
  List<T> get getFlushed => _list;

  @override
  Iterator<T> get iterator => _list.iterator;

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  Iterable<T> get iter => _list;

  @override
  bool contains(Object element) => _list.contains(element);

  @override
  T operator [](int index) => _list[index];

  @override
  int get length => _list.length;

  @override
  T get first => _list.first;

  @override
  T get last => _list.last;

  @override
  T get single => _list.single;

  bool deepListEquals(LFlat<T> other) =>
      (other == null) ? false : const ListEquality().equals(_list, other._list);

  int deepListHashcode() => const ListEquality().hash(_list);
}

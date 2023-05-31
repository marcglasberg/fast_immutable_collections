// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:collection/collection.dart";
import "package:fast_immutable_collections/src/iterator/iterator_flat.dart";

import "ilist.dart";

class LFlat<T> extends L<T> {
  //
  final List<T> _list;

  static L<T> empty<T>() => LFlat.unsafe(<T>[]);

  /// **Safe**.
  LFlat(Iterable<T> iterable) : _list = List.of(iterable, growable: false);

  LFlat.unsafe(this._list);

  @override
  List<T> get getFlushed => _list;

  @override
  Iterator<T> get iterator => IteratorFlat(_list.iterator);

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  Iterable<T> get iter => _list;

  @override
  bool contains(covariant T? element) => _list.contains(element);

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

  bool deepListEquals(LFlat? other) =>
      (other != null) && const ListEquality<dynamic>().equals(_list, other._list);

  int deepListHashcode() => const ListEquality<dynamic>().hash(_list);
}

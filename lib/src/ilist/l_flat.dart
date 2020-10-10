import 'package:collection/collection.dart';

import 'ilist.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class LFlat<T> extends L<T> {
  final List<T> _list;

  static L<T> empty<T>() => LFlat.unsafe(<T>[]);

  LFlat(Iterable<T> iterable)
      : assert(iterable != null),
        _list = List.of(iterable, growable: false);

  LFlat.unsafe(this._list) : assert(_list != null);

  @override
  Iterator<T> get iterator => _list.iterator;

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool any(bool Function(T) test) {
    return _list.any(test);
  }

  @override
  Iterable<R> cast<R>() => _list.cast<R>();

  @override
  bool contains(Object element) => _list.contains(element);

  @override
  T operator [](int index) => _list[index];

  @override
  T elementAt(int index) => this[index];

  @override
  bool every(bool Function(T) test) => _list.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => _list.expand(f);

  @override
  int get length => _list.length;

  @override
  T get first => _list.first;

  @override
  T get last => _list.last;

  @override
  T get single => _list.single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _list.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _list.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _list.forEach(f);

  @override
  String join([String separator = '']) => _list.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T e) f) => IList(_list.map(f));

  @override
  T reduce(T Function(T value, T element) combine) => _list.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _list.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _list.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _list.skipWhile(test);

  @override
  Iterable<T> take(int count) => _list.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _list.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<T> toSet() => _list.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => _list.where(test);

  @override
  Iterable<E> whereType<E>() => _list.whereType<E>();

  bool deepListEquals(LFlat<T> other) =>
      (other == null) ? false : const ListEquality().equals(_list, other._list);

  int deepListHashcode() => const ListEquality().hash(_list);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

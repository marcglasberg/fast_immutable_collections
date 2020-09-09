import 'package:fast_immutable_collections/fast_immutable_collections.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class L1<T> extends L<T> {
  final List<T> _list;

  L1(this._list) : assert(_list != null);

  @override
  Iterator<T> get iterator => _list.iterator;

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool any(bool Function(T) test) => _list.any(test);

  @override
  IList<R> cast<R>() => throw UnsupportedError('cast');

//  IList<R> cast<R>() => _list.cast<R>();

  @override
  bool contains(Object element) => _list.contains(element);

  @override
  T operator [](int index) => _list[index];

  @override
  T elementAt(int index) => this[index];

  @override
  bool every(bool Function(T) test) => _list.every(test);

  @override
  IList<E> expand<E>(Iterable<E> Function(T) f) => _list.expand(f);

  @override
  int get length => _list.length;

  @override
  T get first => _list.first;

  @override
  T get last => _list.last;

  @override
  T get single => _list.single;

  @override
  T firstWhere(bool Function(T) test, {Function() orElse}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _list.fold(initialValue, combine);

  @override
  IList<T> followedBy(Iterable<T> other) => _list.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _list.forEach(f);

  @override
  String join([String separator = '']) => _list.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  IList<E> map<E>(E Function(T e) f) => IList(_list.map(f));

  @override
  T reduce(T Function(T value, T element) combine) => _list.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _list.singleWhere(test, orElse: orElse);

  @override
  IList<T> skip(int count) => _list.skip(count);

  @override
  IList<T> skipWhile(bool Function(T value) test) => _list.skipWhile(test);

  @override
  IList<T> take(int count) => _list.take(count);

  @override
  IList<T> takeWhile(bool Function(T value) test) => _list.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<T> toSet() => _list.toSet();

  @override
  IList<T> where(bool Function(T element) test) => _list.where(test);

  @override
  IList<E> whereType<E>() => IList(_list.whereType<E>());
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

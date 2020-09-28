import 'package:fast_immutable_collections/src/ilist/ilist.dart';

/// This [Iterable] mixin implements all [Iterable] members.
/// It is meant to help you wrap an [IList] into another class (composition).
/// You must override the [iList] getter to return the inner [IList].
/// All other methods are efficiently implemented in terms of the [iList].
mixin IterableIListMixin<T> implements Iterable<T> {
  IList<T> get iList;

  @override
  bool any(bool Function(T) test) => iList.any(test);

  @override
  Iterable<R> cast<R>() => throw UnsupportedError('cast');

  @override
  bool contains(Object element) => iList.contains(element);

  T operator [](int index) => iList[index];

  @override
  T elementAt(int index) => iList[index];

  @override
  bool every(bool Function(T) test) => iList.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => iList.expand(f);

  @override
  int get length => iList.length;

  @override
  T get first => iList.first;

  @override
  T get last => iList.last;

  @override
  T get single => iList.single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      iList.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iList.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => iList.followedBy(other);

  @override
  void forEach(void Function(T element) f) => iList.forEach(f);

  @override
  String join([String separator = '']) => iList.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      iList.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T e) f) => iList.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => iList.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      iList.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => iList.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => iList.skipWhile(test);

  @override
  Iterable<T> take(int count) => iList.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => iList.takeWhile(test);

  @override
  Iterable<T> where(bool Function(T element) test) => iList.where(test);

  @override
  Iterable<E> whereType<E>() => iList.whereType<E>();

  @override
  bool get isEmpty => iList.isEmpty;

  @override
  bool get isNotEmpty => iList.isNotEmpty;

  @override
  Iterator<T> get iterator => iList.iterator;

  @override
  List<T> toList({bool growable = true}) => List.of(this, growable: growable);

  @override
  Set<T> toSet() => Set.of(this);
}

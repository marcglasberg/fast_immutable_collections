import 'iset.dart';

abstract class IterableS<T> implements Iterable<T> {
  @override
  bool any(bool Function(T) test);

  @override
  ISet<R> cast<R>();

  @override
  bool contains(Object element);

  @override
  T elementAt(int index);

  @override
  bool every(bool Function(T) test);

  @override
  ISet<E> expand<E>(Iterable<E> Function(T) f);

  @override
  int get length;

  @override
  T get first;

  @override
  T get last;

  @override
  T get single;

  @override
  T firstWhere(bool Function(T) test, {Function() orElse});

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine);

  @override
  ISet<T> followedBy(Iterable<T> other);

  @override
  void forEach(void Function(T element) f);

  @override
  String join([String separator = '']);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse});

  @override
  ISet<E> map<E>(E Function(T e) f);

  @override
  T reduce(T Function(T value, T element) combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse});

  @override
  ISet<T> skip(int count);

  @override
  ISet<T> skipWhile(bool Function(T value) test);

  @override
  ISet<T> take(int count);

  @override
  ISet<T> takeWhile(bool Function(T value) test);

  @override
  List<T> toList({bool growable = true});

  @override
  Set<T> toSet();

  @override
  ISet<T> where(bool Function(T element) test);

  @override
  ISet<E> whereType<E>();
}
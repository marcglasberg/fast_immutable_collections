import 'ilist.dart';

abstract class IterableL<T> implements Iterable<T> {
  @override
  bool any(bool Function(T) test);

  @override
  IList<R> cast<R>();

  @override
  bool contains(Object element);

  @override
  T elementAt(int index);

  @override
  bool every(bool Function(T) test);

  @override
  IList<E> expand<E>(Iterable<E> Function(T) f);

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
  IList<T> followedBy(Iterable<T> other);

  @override
  void forEach(void Function(T element) f);

  @override
  String join([String separator = '']);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse});

  @override
  IList<E> map<E>(E Function(T e) f);

  @override
  T reduce(T Function(T value, T element) combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse});

  @override
  IList<T> skip(int count);

  @override
  IList<T> skipWhile(bool Function(T value) test);

  @override
  IList<T> take(int count);

  @override
  IList<T> takeWhile(bool Function(T value) test);

  @override
  List<T> toList({bool growable = true});

  @override
  Set<T> toSet();

  @override
  IList<T> where(bool Function(T element) test);

  @override
  IList<E> whereType<E>();
}

import 'iset.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class SFlat<T> extends S<T> {
  final Set<T> _set;

  SFlat(this._set) : assert(_set != null);

  @override
  Iterator<T> get iterator => _set.iterator;

  @override
  bool get isEmpty => _set.isEmpty;

  @override
  bool any(bool Function(T) test) => _set.any(test);

  @override
  ISet<R> cast<R>() => throw UnsupportedError('cast');

//  ISet<R> cast<R>() => _set.cast<R>();

  @override
  bool contains(Object element) => _set.contains(element);

  @override
  bool every(bool Function(T) test) => _set.every(test);

  @override
  ISet<E> expand<E>(Iterable<E> Function(T) f) => _set.expand(f);

  @override
  int get length => _set.length;

  @override
  T get first => _set.first;

  @override
  T get last => _set.last;

  @override
  T get single => _set.single;

  @override
  T firstWhere(bool Function(T) test, {Function() orElse}) =>
      _set.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _set.fold(initialValue, combine);

  @override
  ISet<T> followedBy(Iterable<T> other) => _set.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _set.forEach(f);

  @override
  String join([String separator = '']) => _set.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _set.lastWhere(test, orElse: orElse);

  @override
  ISet<E> map<E>(E Function(T e) f) => ISet(_set.map(f));

  @override
  T reduce(T Function(T value, T element) combine) => _set.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _set.singleWhere(test, orElse: orElse);

  @override
  ISet<T> skip(int count) => _set.skip(count);

  @override
  ISet<T> skipWhile(bool Function(T value) test) => _set.skipWhile(test);

  @override
  ISet<T> take(int count) => _set.take(count);

  @override
  ISet<T> takeWhile(bool Function(T value) test) => _set.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _set.toList(growable: growable);

  @override
  Set<T> toSet() => _set.toSet();

  @override
  ISet<T> where(bool Function(T element) test) => _set.where(test);

  @override
  ISet<E> whereType<E>() => ISet(_set.whereType<E>());
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

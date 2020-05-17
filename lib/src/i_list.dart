extension IListExtension<T> on Iterable<T> {
  IList<T> get lock => IList<T>(this);
}

class IList<T> implements Iterable<T> {
  List<T> _list;

  factory IList([Iterable<T> iterable]) =>
      (iterable is IList) ? (iterable as IList) : IList._(iterable);

  IList._([Iterable<T> iterable])
      : _list = (iterable is IList)
            ? (iterable as IList)._list
            : (iterable == null ? const [] : List.of(iterable));

  List<T> get unlock => List.of(_list);

  bool get isEmpty => _list.isEmpty;

  bool get isNotEmpty => !isEmpty;

  @override
  bool any(bool Function(T) test) => _list.any(test);

  @override
  Iterable<R> cast<R>() => _list.cast<R>();

  @override
  bool contains(Object element) => _list.contains(element);

  @override
  elementAt(int index) => _list.elementAt(index);

  @override
  bool every(bool Function(T) test) => _list.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => _list.expand(f);

  @override
  int get length => _list.length;

  @override
  get first => _list.first;

  @override
  T get last => _list.last;

  @override
  T get single => _list.single;

  @override
  firstWhere(bool Function(T) test, {Function() orElse}) => _list.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _list.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _list.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _list.forEach(f);

  @override
  Iterator<T> get iterator => _list.iterator;

  @override
  String join([String separator = ""]) => _list.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T e) f) => _list.map(f);

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
  Iterable<T> whereType<T>() => _list.whereType<T>();
}

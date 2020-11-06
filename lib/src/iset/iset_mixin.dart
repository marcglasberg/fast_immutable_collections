import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// This mixin implements all [ISet] members.
/// It is meant to help you wrap an [ISet] into another class (composition).
/// Note classes which use this mixin are not themselves ISets, but [Iterables].
///
/// To use this mixin, your class must:
/// 1) Override the [iSet] getter to return the inner [ISet].
/// 2) Override the [newInstance] method to return a new instance of the class.
///
/// All other methods are efficiently implemented in terms of the [iSet] and you don't need
/// to worry about them.
///
/// Example:
///
/// ```dart
/// class Students with ISetMixin<Student, Students> {
///   final ISet<Student> _students;
///
///   Students([Iterable<Student> students]) : _students = ISet(students);
///
///   @override
///   Students newInstance(ISet<Student> iSet) => Students(iSet);
///
///   @override
///   ISet<Student> get iSet => _students;
/// }
/// ```
///
/// See also: [IterableISetMixin].
///
mixin ISetMixin<T, I extends ISetMixin<T, I>> implements Iterable<T>, CanBeEmpty {
  //

  // Classes with `ISetMixin` must override this.
  ISet<T> get iSet;

  // Classes with `ISetMixin` must override this.
  I newInstance(ISet<T> iSet);

  @override
  bool any(bool Function(T) test) => iSet.any(test);

  @override
  ISet<R> cast<R>() => iSet.cast<R>();

  @override
  bool contains(Object element) => iSet.contains(element);

  @override
  T elementAt(int index) => throw UnsupportedError("elementAt in ${runtimeType} is not allowed");

  @override
  bool every(bool Function(T) test) => iSet.every(test);

  @override
  ISet<E> expand<E>(Iterable<E> Function(T) f) => iSet.expand(f);

  @override
  int get length => iSet.length;

  @override
  T get first => iSet.first;

  @override
  T get last => iSet.last;

  @override
  T get single => iSet.single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      iSet.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iSet.fold(initialValue, combine);

  @override
  ISet<T> followedBy(Iterable<T> other) => iSet.followedBy(other);

  @override
  void forEach(void Function(T element) f) => iSet.forEach(f);

  @override
  String join([String separator = ""]) => iSet.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      iSet.lastWhere(test, orElse: orElse);

  @override
  ISet<E> map<E>(E Function(T element) f) => iSet.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => iSet.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      iSet.singleWhere(test, orElse: orElse);

  @override
  ISet<T> skip(int count) => iSet.skip(count);

  @override
  ISet<T> skipWhile(bool Function(T value) test) => iSet.skipWhile(test);

  @override
  ISet<T> take(int count) => iSet.take(count);

  @override
  ISet<T> takeWhile(bool Function(T value) test) => iSet.takeWhile(test);

  @override
  ISet<T> where(bool Function(T element) test) => iSet.where(test);

  @override
  ISet<E> whereType<E>() => iSet.whereType<E>();

  @override
  bool get isEmpty => iSet.isEmpty;

  @override
  bool get isNotEmpty => iSet.isNotEmpty;

  @override
  Iterator<T> get iterator => iSet.iterator;

  @override
  List<T> toList({bool growable = true}) => List.of(this, growable: growable);

  @override
  Set<T> toSet() => Set.of(this);

  I operator +(Iterable<T> other) => newInstance(iSet + other);

  I add(T item) => newInstance(iSet.add(item));

  I addAll(Iterable<T> items) => newInstance(iSet.addAll(items));

  void clear() => newInstance(iSet.clear());

  bool equalItems(covariant Iterable<T> other) => iSet.equalItems(other);

  I remove(T item) => newInstance(iSet.remove(item));

  I removeWhere(bool Function(T element) test) => newInstance(iSet.removeWhere(test));

  I retainWhere(bool Function(T element) test) => newInstance(iSet.retainWhere(test));

  I toggle(T element) => newInstance(iSet.toggle(element));

  Set<T> get unlock => iSet.unlock;

  Set<T> get unlockSorted => iSet.unlockSorted;

  Set<T> get unlockView => iSet.unlockView;

  bool same(I other) => iSet.same(other.iSet);

  bool containsAll(Iterable<Object> other) => iSet.containsAll(other);

  ISet<T> difference(Set<Object> other) => iSet.difference(other);

  ISet<T> intersection(Set<Object> other) => iSet.intersection(other);

  T lookup(Object object) => iSet.lookup(object);

  void removeAll(Iterable<Object> elements) => iSet.removeAll(elements);

  void retainAll(Iterable<Object> elements) => iSet.retainAll(elements);

  ISet<T> union(Set<T> other) => iSet.union(other);
}

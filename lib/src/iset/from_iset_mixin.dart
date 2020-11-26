import "../base/immutable_collection.dart";
import "../iset/iset.dart";

/// This mixin implements all [ISet] members (without config),
/// but it does **NOT** implement [Iterable] nor [ISet].
///
/// It is meant to help you wrap an [ISet] into another class (composition).
/// You must override the [iter] getter to return the inner [ISet].
/// All other methods are efficiently implemented in terms of the [iter].
///
/// To use this mixin, your class must:
///
/// 1. Override the [iter] getter to return the inner [ISet].
/// 1. Override the [newInstance] method to return a new instance of the class.
///
/// Example:
///
/// ```dart
/// class Students with FromISetMixin<Student, Students> {
///   final ISet<Student> _students;
///
///   Students([Iterable<Student> students]) : _students = ISet(students);
///
///   @override
///   Students newInstance(ISet<Student> iSet) => Students(iSet);
///
///   @override
///   ISet<Student> get iter => _students;
/// }
/// ```
///
/// See also: [FromIterableISetMixin].
mixin FromISetMixin<T, I extends FromISetMixin<T, I>> implements CanBeEmpty {
  //

  /// Classes `with` [FromISetMixin] must override this.
  ISet<T> get iter;

  /// Classes `with` [FromISetMixin] must override this.
  I newInstance(ISet<T> iSet);

  bool any(bool Function(T) test) => iter.any(test);

  ISet<R> cast<R>() => iter.cast<R>();

  bool contains(Object element) => iter.contains(element);

  T elementAt(int index) => throw UnsupportedError("elementAt in ${runtimeType} is not allowed");

  bool every(bool Function(T) test) => iter.every(test);

  ISet<E> expand<E>(Iterable<E> Function(T) f) => iter.expand(f);

  int get length => iter.length;

  T get first => iter.first;

  T get last => iter.last;

  T get single => iter.single;

  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      iter.firstWhere(test, orElse: orElse);

  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iter.fold(initialValue, combine);

  ISet<T> followedBy(Iterable<T> other) => iter.followedBy(other);

  void forEach(void Function(T element) f) => iter.forEach(f);

  String join([String separator = ""]) => iter.join(separator);

  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      iter.lastWhere(test, orElse: orElse);

  ISet<E> map<E>(E Function(T element) f) => iter.map(f);

  T reduce(T Function(T value, T element) combine) => iter.reduce(combine);

  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      iter.singleWhere(test, orElse: orElse);

  ISet<T> skip(int count) => iter.skip(count);

  ISet<T> skipWhile(bool Function(T value) test) => iter.skipWhile(test);

  ISet<T> take(int count) => iter.take(count);

  ISet<T> takeWhile(bool Function(T value) test) => iter.takeWhile(test);

  ISet<T> where(bool Function(T element) test) => iter.where(test);

  ISet<E> whereType<E>() => iter.whereType<E>();

  @override
  bool get isEmpty => iter.isEmpty;

  @override
  bool get isNotEmpty => iter.isNotEmpty;

  Iterator<T> get iterator => iter.iterator;

  List<T> toList({bool growable = true}) => List.of(iter, growable: growable);

  Set<T> toSet() => Set.of(iter);

  I operator +(Iterable<T> other) => newInstance(iter + other);

  I add(T item) => newInstance(iter.add(item));

  I addAll(Iterable<T> items) => newInstance(iter.addAll(items));

  I clear() => newInstance(iter.clear());

  bool equalItems(covariant Iterable<T> other) => iter.equalItems(other);

  bool same(I other) => iter.same(other.iter);

  I remove(T item) => newInstance(iter.remove(item));

  I removeWhere(bool Function(T element) test) => newInstance(iter.removeWhere(test));

  I retainWhere(bool Function(T element) test) => newInstance(iter.retainWhere(test));

  I toggle(T element) => newInstance(iter.toggle(element));

  Set<T> get unlock => iter.unlock;

  Set<T> get unlockSorted => iter.unlockSorted;

  Set<T> get unlockView => iter.unlockView;

  // TODO: Marcelo, a tipagem dos parâmetros dos próximos métodos não deveria ser mais específica?
  // Algo como `Iterable<T>` ou `ISet<T>` ao invés de `Set<Object>`?
  bool containsAll(Iterable<Object> other) => iter.containsAll(other);

  ISet<T> difference(Set<Object> other) => iter.difference(other);

  ISet<T> intersection(Set<Object> other) => iter.intersection(other);

  T lookup(Object object) => iter.lookup(object);

  ISet<T> removeAll(Iterable<Object> elements) => iter.removeAll(elements);

  ISet<T> retainAll(Iterable<Object> elements) => iter.retainAll(elements);

  ISet<T> union(Set<T> other) => iter.union(other);
}

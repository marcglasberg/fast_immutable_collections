// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/fast_immutable_collections.dart";

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
///   Students newInstance(ISet<Student> iset) => Students(iset);
///
///   ISet<Student> get iter => _students;
/// }
///
/// class Student implements Comparable<Student> {
///   final String name;
///
///   const Student(this.name);
///
///   String toString() => "Student: $name";
///
///   bool operator ==(Object other) =>
///      identical(this, other) ||
///      other is Student &&
///          runtimeType == other.runtimeType &&
///          name == other.name;
///
///   int get hashCode => name.hashCode;
///
///   int compareTo(Student other) => name.compareTo(other.name);
/// }
/// ```
///
/// See also: [FromIterableISetMixin].
mixin FromISetMixin<T, I extends FromISetMixin<T, I>> implements CanBeEmpty {
  //
  /// Classes `with` [FromISetMixin] must override this.
  ISet<T> get iter;

  /// Classes `with` [FromISetMixin] must override this.
  I newInstance(ISet<T> iset);

  bool any(Predicate<T> test) => iter.any(test);

  Iterable<R> cast<R>() => iter.cast<R>();

  bool contains(covariant T? element) => iter.contains(element);

  T elementAt(int index) => throw UnsupportedError("elementAt in $runtimeType is not allowed");

  bool every(Predicate<T> test) => iter.every(test);

  Iterable<E> expand<E>(Iterable<E> Function(T) f) => iter.expand(f);

  int get length => iter.length;

  T get first => iter.first;

  T get last => iter.last;

  T get single => iter.single;

  T firstWhere(Predicate<T> test, {T Function()? orElse}) => iter.firstWhere(test, orElse: orElse);

  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iter.fold(initialValue, combine);

  Iterable<T> followedBy(Iterable<T> other) => iter.followedBy(other);

  void forEach(void Function(T element) f) => iter.forEach(f);

  String join([String separator = ""]) => iter.join(separator);

  T lastWhere(Predicate<T> test, {T Function()? orElse}) => iter.lastWhere(test, orElse: orElse);

  Iterable<E> map<E>(E Function(T element) f) => iter.map(f);

  T reduce(T Function(T value, T element) combine) => iter.reduce(combine);

  T singleWhere(Predicate<T> test, {T Function()? orElse}) =>
      iter.singleWhere(test, orElse: orElse);

  Iterable<T> skip(int count) => iter.skip(count);

  Iterable<T> skipWhile(bool Function(T value) test) => iter.skipWhile(test);

  Iterable<T> take(int count) => iter.take(count);

  Iterable<T> takeWhile(bool Function(T value) test) => iter.takeWhile(test);

  Iterable<T> where(Predicate<T> test) => iter.where(test);

  Iterable<E> whereType<E>() => iter.whereType<E>();

  @override
  bool get isEmpty => iter.isEmpty;

  @override
  bool get isNotEmpty => iter.isNotEmpty;

  Iterator<T> get iterator => iter.iterator;

  List<T> toList({bool growable = true}) => List.of(iter, growable: growable);

  Set<T> toSet() => Set.of(iter);

  I operator +(Iterable<T> other) => newInstance(iter + other);

  /// If we have ISet<Never>, we cast it to ISet<T>.
  ISet<T> get _castIter => (iter is ISet<Never>) ? iter.cast<T>().toISet() : iter;

  I add(T item) => newInstance(_castIter.add(item));

  I addAll(Iterable<T> items) => newInstance(_castIter.addAll(items));

  I clear() => newInstance(iter.clear());

  bool equalItems(covariant Iterable<T> other) => iter.equalItems(other);

  bool same(I other) => iter.same(other.iter);

  I remove(T item) => newInstance(iter.remove(item));

  I removeWhere(Predicate<T> test) => newInstance(iter.removeWhere(test));

  I retainWhere(Predicate<T> test) => newInstance(iter.retainWhere(test));

  I toggle(T element) => newInstance(iter.toggle(element));

  Set<T> get unlock => iter.unlock;

  Set<T> get unlockView => iter.unlockView;

  bool containsAll(Iterable<T> other) => iter.containsAll(other);

  ISet<T> difference(Set<T> other) => iter.difference(other);

  ISet<T> intersection(Set<T> other) => iter.intersection(other);

  T? lookup(T element) => iter.lookup(element);

  ISet<T> removeAll(Iterable<T> elements) => iter.removeAll(elements);

  ISet<T> retainAll(Iterable<T> elements) => iter.retainAll(elements);

  ISet<T> union(Set<T> other) => iter.union(other);

  @override
  String toString() => "$runtimeType$iter";
}

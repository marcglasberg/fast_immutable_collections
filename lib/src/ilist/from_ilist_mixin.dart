import "dart:math";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// This mixin implements all [IList] methods, plus `operator []`,
/// but it does NOT implement [Iterable] nor [IList].
///
/// It is meant to help you wrap an [IList] into another class (composition).
/// You must override the [iter] getter to return the inner [IList].
/// All other methods are efficiently implemented in terms of the [iter].
///
/// To use this mixin, your class must:
/// 1) Override the [iter] getter to return the inner [IList].
/// 2) Override the [newInstance] method to return a new instance of the class.
///
/// Example:
///
/// ```dart
/// class Students with IListMixin<Student, Students> {
///   final IList<Student> _students;
///
///   Students([Iterable<Student> students]) : _students = IList(students);
///
///   @override
///   Students newInstance(IList<Student> iList) => Students(iList);
///
///   @override
///   IList<Student> get iList => _students;
/// }
/// ```
///
/// Note: Why this class does NOT implement [Iterable]? Unfortunately, the [expect]
/// method in tests compares [Iterable]s by comparing its items. So if you
/// create a class that implement [Iterable] and then you want to use the [expect]
/// method, it will just compare its items, completing ignoring its `operator ==`.
///
/// If you need to iterate over this class, you can use the [iter] getter:
///
///     class MyClass with IListMixin<T> { ... }
///     MyClass obj = MyClass([1, 2, 3]);
///     for (int value in obj.iter) print(value);
///
/// Please note, if you really want to make your class [Iterable] or [IList],
/// you can just add the `implements Iterable<T>` or `implements IList<T>`
/// to its declaration. For example:
///
///     class MyClass with IListMixin<T>,
///                   implements Iterable<T> { ... }
///     MyClass obj = MyClass([1, 2, 3]);
///     for (int value in obj) print(value);
///
/// See also: [IterableIListMixin].
///
mixin FromIListMixin<T, I extends FromIListMixin<T, I>> implements CanBeEmpty {
  //

  // Classes with [IListMixin] must override this.
  IList<T> get iter;

  // Classes with [IListMixin] must override this.
  I newInstance(IList<T> iList);

  Iterator<T> get iterator => iter.iterator;

  bool any(bool Function(T) test) => iter.any(test);

  IList<R> cast<R>() => iter.cast<R>();

  bool contains(Object element) => iter.contains(element);

  T operator [](int index) => iter[index];

  T elementAt(int index) => iter[index];

  bool every(bool Function(T) test) => iter.every(test);

  IList<E> expand<E>(Iterable<E> Function(T) f) => iter.expand(f);

  int get length => iter.length;

  T get first => iter.first;

  T get last => iter.last;

  T get single => iter.single;

  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      iter.firstWhere(test, orElse: orElse);

  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iter.fold(initialValue, combine);

  IList<T> followedBy(Iterable<T> other) => iter.followedBy(other);

  void forEach(void Function(T element) f) => iter.forEach(f);

  String join([String separator = ""]) => iter.join(separator);

  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      iter.lastWhere(test, orElse: orElse);

  IList<E> map<E>(E Function(T element) f) => iter.map(f);

  T reduce(T Function(T value, T element) combine) => iter.reduce(combine);

  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      iter.singleWhere(test, orElse: orElse);

  IList<T> skip(int count) => iter.skip(count);

  IList<T> skipWhile(bool Function(T value) test) => iter.skipWhile(test);

  IList<T> take(int count) => iter.take(count);

  IList<T> takeWhile(bool Function(T value) test) => iter.takeWhile(test);

  IList<T> where(bool Function(T element) test) => iter.where(test);

  IList<E> whereType<E>() => iter.whereType<E>();

  @override
  bool get isEmpty => iter.isEmpty;

  @override
  bool get isNotEmpty => iter.isNotEmpty;

  List<T> toList({bool growable = true}) => List.of(iter, growable: growable);

  Set<T> toSet() => Set.of(iter);

  I operator +(Iterable<T> other) => newInstance(iter + other);

  I add(T item) => newInstance(iter.add(item));

  I addAll(Iterable<T> items) => newInstance(iter.addAll(items));

  IMap<int, T> asMap() => iter.asMap();

  void clear() => newInstance(iter.clear());

  bool equalItems(covariant Iterable<T> other) => iter.equalItems(other);

  I fillRange(int start, int end, [T fillValue]) =>
      newInstance(iter.fillRange(start, end, fillValue));

  T firstOr(T orElse) => iter.firstOr(orElse);

  T get firstOrNull => iter.firstOrNull;

  Iterable<T> getRange(int start, int end) => iter.getRange(start, end);

  int indexOf(T element, [int start = 0]) => iter.indexOf(element, start);

  int indexWhere(bool Function(T element) test, [int start = 0]) => iter.indexWhere(test, start);

  I insert(int index, T element) => newInstance(iter.insert(index, element));

  I insertAll(int index, Iterable<T> iterable) => newInstance(iter.insertAll(index, iterable));

  int lastIndexOf(T element, [int start]) => iter.lastIndexOf(element, start);

  int lastIndexWhere(bool Function(T element) test, [int start]) =>
      iter.lastIndexWhere(test, start);

  T lastOr(T orElse) => iter.lastOr(orElse);

  T get lastOrNull => iter.lastOrNull;

  I maxLength(int maxLength) => newInstance(iter.maxLength(maxLength));

  I process(
          {bool Function(IList<T> list, int index, T item) test,
          Iterable<T> Function(IList<T> list, int index, T item) apply}) =>
      newInstance(iter.process(test: test, apply: apply));

  I put(int index, T value) => newInstance(iter.put(index, value));

  I remove(T item) => newInstance(iter.remove(item));

  I removeAt(int index, [Output<T> removedItem]) => newInstance(iter.removeAt(index, removedItem));

  I removeLast([Output<T> removedItem]) => newInstance(iter.removeLast(removedItem));

  I removeRange(int start, int end) => newInstance(iter.removeRange(start, end));

  I removeWhere(bool Function(T element) test) => newInstance(iter.removeWhere(test));

  I replaceAll({T from, T to}) => newInstance(iter.replaceAll(from: from, to: to));

  I replaceAllWhere(bool Function(T element) test, T to) =>
      newInstance(iter.replaceAllWhere(test, to));

  I replaceFirst({T from, T to}) => newInstance(iter.replaceFirst(from: from, to: to));

  I replaceFirstWhere(bool Function(T item) test, T to) =>
      newInstance(iter.replaceFirstWhere(test, to));

  I replaceRange(int start, int end, Iterable<T> replacement) =>
      newInstance(iter.replaceRange(start, end, replacement));

  I retainWhere(bool Function(T element) test) => newInstance(iter.retainWhere(test));

  I get reversed => newInstance(iter.reversed);

  I setAll(int index, Iterable<T> iterable) => newInstance(iter.setAll(index, iterable));

  I setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) =>
      newInstance(iter.setRange(start, end, iterable, skipCount));

  I shuffle([Random random]) => newInstance(iter.shuffle(random));

  T singleOr(T orElse) => iter.singleOr(orElse);

  T get singleOrNull => iter.singleOrNull;

  I sort([int Function(T a, T b) compare]) => newInstance(iter.sort(compare));

  I sublist(int start, [int end]) => newInstance(iter.sublist(start, end));

  I toggle(T element) => newInstance(iter.toggle(element));

  List<T> get unlock => iter.unlock;

  List<T> get unlockView => iter.unlockView;

  bool unorderedEqualItems(covariant Iterable<T> other) => iter.unorderedEqualItems(other);

  bool same(I other) => iter.same(other.iter);
}

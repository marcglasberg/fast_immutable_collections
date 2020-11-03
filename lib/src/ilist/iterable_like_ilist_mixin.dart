import "../utils/immutable_collection.dart";
import "ilist.dart";

/// This mixin implements all [Iterable] members, plus `operator []`,
/// but the class itself does NOT implement [Iterable] nor [IList].
///
/// In other words, this is useful if you want some class to imitate an [Iterable]
/// without itself being an iterable. However, you can get an iterable from it
/// by calling [iter].
///
///     class MyClass extends IterableLikeIListMixin<T> { ... }
///     MyClass obj = MyClass([1, 2, 3]);
///     for (int value in obj.iter) print(value);
///
/// Unfortunately, the [expect] method in tests compares [Iterable]s by comparing its items.
/// So if you create a class that implement [Iterable] and then you want to use the [expect]
/// method, it will just compare its items, completing ignoring its operator ==.
/// For this reason, I suggest that unless some class is meant as a pure collection,
/// it should not implement [Iterable] at all.
///
/// To implement the [IterableLikeIListMixin] you must override the [iList] getter
/// to return the inner [IList]. All other methods are efficiently implemented in
/// terms of the [iList].
///
/// See also: [IterableIListMixin] and [IListMixin].
///
mixin IterableLikeIListMixin<T> implements CanBeEmpty {
  IList<T> get iList;

  Iterable<T> get iter => iList;

  Iterator<T> get iterator => iList.iterator;

  bool any(bool Function(T) test) => iList.any(test);

  Iterable<R> cast<R>() => throw UnsupportedError("cast");

  bool contains(Object element) => iList.contains(element);

  T operator [](int index) => iList[index];

  T elementAt(int index) => iList[index];

  bool every(bool Function(T) test) => iList.every(test);

  Iterable<E> expand<E>(Iterable<E> Function(T) f) => iList.expand(f);

  int get length => iList.length;

  T get first => iList.first;

  T get last => iList.last;

  T get single => iList.single;

  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      iList.firstWhere(test, orElse: orElse);

  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iList.fold(initialValue, combine);

  Iterable<T> followedBy(Iterable<T> other) => iList.followedBy(other);

  void forEach(void Function(T element) f) => iList.forEach(f);

  String join([String separator = ""]) => iList.join(separator);

  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      iList.lastWhere(test, orElse: orElse);

  Iterable<E> map<E>(E Function(T element) f) => iList.map(f);

  T reduce(T Function(T value, T element) combine) => iList.reduce(combine);

  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      iList.singleWhere(test, orElse: orElse);

  Iterable<T> skip(int count) => iList.skip(count);

  Iterable<T> skipWhile(bool Function(T value) test) => iList.skipWhile(test);

  Iterable<T> take(int count) => iList.take(count);

  Iterable<T> takeWhile(bool Function(T value) test) => iList.takeWhile(test);

  IList<T> where(bool Function(T element) test) => iList.where(test);

  Iterable<E> whereType<E>() => iList.whereType<E>();

  @override
  bool get isEmpty => iList.isEmpty;

  @override
  bool get isNotEmpty => iList.isNotEmpty;

  List<T> toList({bool growable = true}) => List.of(iList, growable: growable);

  Set<T> toSet() => Set.of(iList);
}

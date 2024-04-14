// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:collection";
import "dart:math";

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/base/hash.dart";
import "package:meta/meta.dart";

import "l_add.dart";
import "l_add_all.dart";
import "l_flat.dart";

/// This is an [IList] which is always empty.
@immutable
class IListEmpty<T> // ignore: must_be_immutable
    extends IList<T> {
  /// Creates an empty list. In most cases, you should use `const IList.empty()`.
  ///
  /// IMPORTANT: You must always use the `const` keyword.
  /// It's always wrong to use an `IListEmpty()` which is not constant.
  @literal
  const IListEmpty._([this.config = const ConfigList()]) : super._gen();

  @override
  final ConfigList config;

  /// An empty list is always flushed, by definition.
  @override
  bool get isFlushed => true;

  /// Nothing happens when you flush a empty list, by definition.
  @override
  IListEmpty<T> get flush => this;

  /// An empty list is always empty, by definition
  @override
  bool get isEmpty => true;

  /// An empty list is always empty, by definition
  @override
  bool get isNotEmpty => false;

  /// An empty list does not contain anything, by definition
  @override
  bool contains(covariant T? element) => false;

  /// An empty list is always of length `0`, by definition
  @override
  int get length => 0;

  /// An empty list has no first element, by definition
  @override
  Never get first => throw StateError("No element");

  /// An empty list has no last element, by definition
  @override
  Never get last => throw StateError("No element");

  /// An empty list has no single element, by definition
  @override
  Never get single => throw StateError("No element");

  /// An empty list is always the reversed version of itself, by definition
  @override
  IListEmpty<T> get reversed => this;

  /// An empty list is always the cleared version of itself, by definition
  @override
  IListEmpty<T> clear() => this;

  @override
  int get _counter => 0;

  @override
  L<T> get _l => LFlat<T>.unsafe([]);

  /// Hash codes must be the same for objects that are equal to each other
  /// according to operator ==.
  @override
  int? get _hashCode {
    return isDeepEquals
        ? hash2(const ListEquality<dynamic>().hash([]), config.hashCode)
        : hash2(identityHashCode(_l), config.hashCode);
  }

  @override
  set _hashCode(int? value) {}

  @override
  bool same(IList<T>? other) =>
      (other != null) &&
      (other is IListEmpty || (other is IListConst && (other as IListConst)._list.isEmpty)) &&
      (config == other.config);
}

/// This is an [IList] which can be made constant.
/// Note: Don't ever use it without the "const" keyword, because it will be unsafe.
///
@immutable
class IListConst<T> // ignore: must_be_immutable
    extends IList<T> {
  //
  /// To create an empty constant IList: `const IListConst([])`.
  /// To create a constant list with items: `const IListConst([1, 2, 3])`.
  ///
  /// IMPORTANT: You must always use the `const` keyword.
  /// It's always wrong to use an `IListConst` which is not constant.
  ///
  @literal
  const IListConst(this._list,
      // Note: The _list can't be optional. This doesn't work: [this._list = const []]
      // because when you do this _list will be List<Never> which is bad.
      [this.config = const ConfigList()])
      : super._gen();

  final List<T> _list;

  @override
  final ConfigList config;

  /// A constant list is always flushed, by definition.
  @override
  bool get isFlushed => true;

  /// Nothing happens when you flush a constant list, by definition.
  @override
  IListConst<T> get flush => this;

  @override
  int get _counter => 0;

  @override
  L<T> get _l => LFlat<T>.unsafe(_list);

  /// Hash codes must be the same for objects that are equal to each other
  /// according to operator ==.
  @override
  int? get _hashCode {
    return isDeepEquals
        ? hash2(const ListEquality<dynamic>().hash(_list), config.hashCode)
        : hash2(identityHashCode(_l), config.hashCode);
  }

  @override
  set _hashCode(int? value) {}

  @override
  bool same(IList<T>? other) =>
      (other != null) &&
      (((other is IListConst) && identical(_list, (other as IListConst)._list)) ||
          (((other is IListEmpty) && _list.isEmpty))) &&
      (config == other.config);
}

@immutable
class IListImpl<T> // ignore: must_be_immutable
    extends IList<T> {
  //
  /// The list configuration ([ConfigList]).
  @override
  final ConfigList config;

  @override
  late L<T> _l;

  @override
  int _counter = 0;

  @override
  // HashCode cache. Must be null if hashCode is not cached.
  // ignore: use_late_for_private_fields_and_variables
  int? _hashCode;

  /// Flushes the list, if necessary. Chainable getter.
  /// If the list is already flushed, don't do anything.
  @override
  IList<T> get flush {
    if (!isFlushed) {
      // Flushes the original _l because maybe it's used elsewhere.
      // Or maybe it was flushed already, and we can use it as is.
      _l = LFlat<T>.unsafe(_l.getFlushed);
      _counter = 0;
    }
    return this;
  }

  IListImpl.unsafe(List<T> list, {required this.config})
      : _l = LFlat<T>.unsafe(list),
        super._gen() {
    if (ImmutableCollection.disallowUnsafeConstructors)
      throw UnsupportedError("IList.unsafe is disallowed.");
  }

  /// **Unsafe**.
  IListImpl._unsafe(this._l, {required this.config}) : super._gen();

  /// **Unsafe**.
  IListImpl._unsafeFromList(List<T> list, {required this.config})
      : _l = LFlat<T>.unsafe(list),
        super._gen();

  /// Returns an empty [IList], with the given configuration. If a
  /// configuration is not provided, it will use the default configuration.
  ///
  /// Note: If you want to create an empty immutable collection of the same
  /// type and same configuration as a source collection, simply call [clear]
  /// on the source collection.
  static IListImpl<T> empty<T>([ConfigList? config]) =>
      IListImpl._unsafe(LFlat.empty<T>(), config: config ?? IList.defaultConfig);

  /// **Safe**. Fast if the [Iterable] is an [IList].
  IListImpl._(
    Iterable<T>? iterable, {
    required this.config,
  })  : _l = iterable is IList<T> //
            ? iterable._l
            : iterable == null
                ? LFlat.empty<T>()
                : LFlat<T>(iterable),
        super._gen();
}

/// An **immutable** list.
/// Note: The [replace] method is the equivalent of `operator []=` for the [IList].
///
@immutable
abstract class IList<T> // ignore: must_be_immutable
    extends ImmutableCollection<IList<T>> implements Iterable<T> {
  //
  ConfigList get config;

  L<T> get _l;

  set _l(L<T> value) {}

  int get _counter;

  set _counter(int value) {}

  int? get _hashCode;

  set _hashCode(int? value);

  @override
  int get hashCode {
    if (_hashCode != null) return _hashCode!;

    final hashCode = isDeepEquals
        ? hash2((flush._l as LFlat<T>).deepListHashcode(), config.hashCode)
        : hash2(identityHashCode(_l), config.hashCode);

    if (config.cacheHashCode) _hashCode = hashCode;

    return hashCode;
  }

  /// Create an [IList] from an [iterable], with the default configuration.
  /// Fast, if the iterable is another [IList].
  ///
  /// To create an empty [IList] with the default configuration, just omit
  /// the iterable: `IList()`.
  ///
  /// Note: To create an [IList] with a specific configuration, use the `IList.withConfig()`
  /// constructor.
  ///
  /// Note: If you want to create an empty [IList] of the same configuration as a
  /// source [IList], simply call [clear] on the source [IList].
  ///
  factory IList([Iterable<T>? iterable]) => //
      IList.withConfig(iterable ?? const [], defaultConfig);

  /// Create an empty [IList].
  /// Use it with const: `const IList.empty()` (It's always an [IListEmpty]).
  @literal
  const factory IList.empty() = IListEmpty<T>._;

  const IList._gen();

  /// Create an [IList] from any [Iterable] and a [ConfigList].
  /// Fast, if the Iterable is another [IList].
  /// If [iterable] is null, return an empty [IList].
  factory IList.withConfig(
    Iterable<T>? iterable,
    ConfigList config,
  ) {
    return ((iterable is IList<T>) && (iterable.isOfExactGenericType(T)))
        ? (config == iterable.config)
            ? iterable
            : iterable.isEmpty
                ? IListImpl.empty<T>(config)
                : IListImpl<T>._(iterable, config: config)
        : (iterable == null)
            ? IListImpl.empty<T>(config)
            : IListImpl<T>._unsafe(LFlat<T>(iterable), config: config);
  }

  /// Creates a new list with the given [config].
  ///
  /// To copy the config from another [IList]:
  ///
  /// ```dart
  /// list = list.withConfig(other.config);
  /// ```
  ///
  /// To change the current config:
  ///
  /// ```dart
  /// list = list.withConfig(list.config.copyWith(isDeepEquals: isDeepEquals));
  /// ```
  ///
  /// See also: [withIdentityEquals] and [withDeepEquals].
  ///
  @useResult
  IList<T> withConfig(ConfigList config) {
    return (config == this.config) ? this : IList._unsafe(_l, config: config);
  }

  /// Returns a new list with the contents of the present [IList],
  /// but the config of [other].
  @useResult
  IList<T> withConfigFrom(IList<T> other) => withConfig(other.config);

  /// Special [IList] constructor from [ISet].
  ///
  /// If you provide a [compare] function, the resulting list will be sorted with it.
  ///
  factory IList.fromISet(
    ISet<T> iset, {
    int Function(T a, T b)? compare,
    required ConfigList? config,
  }) {
    final List<T> list = iset.toList(growable: false, compare: compare);
    return IList._unsafe(LFlat<T>.unsafe(list), config: config ?? defaultConfig);
  }

  /// **Unsafe constructor. Use this at your own peril.**
  ///
  /// This constructor is fast, since it makes no defensive copies of the list.
  /// However, you should only use this with a new list you've created it yourself,
  /// when you are sure no external copies exist. If the original list is modified,
  /// it will break the [IList] and any other derived lists in unpredictable ways.
  ///
  /// Note you can optionally disallow unsafe constructors ([ImmutableCollection]) in the global
  /// configuration by doing: `ImmutableCollection.disallowUnsafeConstructors = true` (and then
  /// optionally preventing further configuration changes by calling `lockConfig()`).
  factory IList.unsafe(List<T> list, {required ConfigList config}) =>
      IListImpl.unsafe(list, config: config);

  /// If [Iterable] is `null`, return `null`.
  ///
  /// Otherwise, create an [IList] from the [Iterable].
  /// Fast, if the Iterable is another [IList].
  ///
  /// This static factory is useful for implementing a `copyWith` method
  /// that accepts an [Iterable]. For example:
  ///
  /// ```dart
  /// IList<String> names;
  ///
  /// Students copyWith({Iterable<String>? names}) =>
  ///   Students(names: IList.orNull(names) ?? this.names);
  /// ```
  ///
  /// Of course, if your `copyWith` accepts an [IList], this is not necessary:
  ///
  /// ```dart
  /// IList<String> names;
  ///
  /// Students copyWith({IList<String>? names}) =>
  ///   Students(names: names ?? this.names);
  /// ```
  ///
  @useResult
  static IList<T>? orNull<T>(
    Iterable<T>? iterable, [
    ConfigList? config,
  ]) =>
      (iterable == null) ? null : IList.withConfig(iterable, config ?? defaultConfig);

  /// Converts from JSon. Json serialization support for json_serializable with @JsonSerializable.
  factory IList.fromJson(dynamic json, T Function(Object?) fromJsonT) =>
      IList<T>((json as Iterable).map(fromJsonT));

  /// Converts to JSon. Json serialization support for json_serializable with @JsonSerializable.
  Object toJson(Object? Function(T) toJsonT) => map(toJsonT).toList();

  /// See also: [ImmutableCollection], [ImmutableCollection.lockConfig],
  /// [ImmutableCollection.isConfigLocked],[flushFactor], [defaultConfig]
  static void resetAllConfigurations() {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration  of immutable collections.");
    IList.flushFactor = _defaultFlushFactor;
    IList.defaultConfig = _defaultConfig;
  }

  /// Apply Op on previous state of base and return all results
  @useResult
  static IList<U> iterate<U>(U base, int count, Op<U> op) {
    IList<U> iterations() {
      final l = List.filled(count, base, growable: false);
      U acc = base;
      int i = 1;
      l[0] = acc;

      while (i < count) {
        acc = op(acc);
        l[i] = acc;
        i += 1;
      }

      return l.lock;
    }

    return count > 0 ? iterations() : <U>[].lock;
  }

  /// Apply Op on previous state of base while predicate pass then return all results
  @useResult
  static IList<U> iterateWhile<U>(U base, Predicate<U> test, Op<U> op) {
    final l = <U>[];
    U acc = base;
    l.add(acc);

    while (test(acc)) {
      acc = op(l.last);
      l.add(acc);
    }

    return l.lock;
  }

  static Iterable<U> tabulate<U>(int count, U Function(int at) on) =>
      Iterable.generate(count, (idx) => on(idx));

  static Iterable<Iterable<U>> tabulate2<U>(
          int count0, int count1, U Function(int at0, int at1) on) =>
      Iterable.generate(count0, (idx0) => Iterable.generate(count1, (idx1) => on(idx0, idx1)));

  static Iterable<Iterable<Iterable<U>>> tabulate3<U>(
          int count0, int count1, int count2, U Function(int at0, int at1, int at2) on) =>
      Iterable.generate(
          count0,
          (idx0) => Iterable.generate(
                count1,
                (idx1) => Iterable.generate(count2, (idx2) => on(idx0, idx1, idx2)),
              ));

  static Iterable<Iterable<Iterable<Iterable<U>>>> tabulate4<U>(int count0, int count1, int count2,
          int count3, U Function(int at0, int at1, int at2, int at3) on) =>
      Iterable.generate(
          count0,
          (idx0) => Iterable.generate(
                count1,
                (idx1) => Iterable.generate(count2,
                    (idx2) => Iterable.generate(count3, (idx3) => on(idx0, idx1, idx2, idx3))),
              ));

  static Iterable<Iterable<Iterable<Iterable<Iterable<U>>>>> tabulate5<U>(
          int count0,
          int count1,
          int count2,
          int count3,
          int count4,
          U Function(int at0, int at1, int at2, int at3, int at4) on) =>
      Iterable.generate(
          count0,
          (idx0) => Iterable.generate(
                count1,
                (idx1) => Iterable.generate(
                    count2,
                    (idx2) => Iterable.generate(
                        count3,
                        (idx3) =>
                            Iterable.generate(count4, (idx4) => on(idx0, idx1, idx2, idx3, idx4)))),
              ));

  /// Global configuration that specifies if, by default, the [IList]s
  /// use equality or identity for their [operator ==].
  /// By default `isDeepEquals: true` (lists are compared by equality) and `cacheHashCode = true`.
  static ConfigList get defaultConfig => _defaultConfig;

  /// Indicates the number of operations an [IList] may perform
  /// before it is eligible for auto-flush. Must be larger than `0`.
  static int get flushFactor => _flushFactor;

  /// See also: [ConfigList], [ImmutableCollection], [resetAllConfigurations]
  static set defaultConfig(ConfigList config) {
    if (_defaultConfig == config) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _defaultConfig = config;
  }

  /// See also: [ImmutableCollection]
  static set flushFactor(int value) {
    if (_flushFactor == value) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    if (value > 0)
      _flushFactor = value;
    else
      throw StateError("flushFactor can't be $value.");
  }

  static ConfigList _defaultConfig = const ConfigList();

  static const _defaultFlushFactor = 500;

  static int _flushFactor = _defaultFlushFactor;

  /// ## Auto-flush
  ///
  /// Keeps a counter variable which starts at `0` and is incremented each
  /// time collection methods are used. As soon as counter reaches the
  /// refresh-factor, the collection is flushed and `counter` returns to `0`.
  ///
  /// Note: [_count] is called in all methods that change, and some that read.
  /// It's not called in methods which create new [ILists] or flush the list.
  void _count() {
    if (!ImmutableCollection.autoFlush) return;
    if (isFlushed) {
      _counter = 0;
    } else {
      _counter++;
      if (_counter >= _flushFactor) {
        flush;
        _counter = 0;
      }
    }
  }

  /// **Unsafe**.
  factory IList._unsafe(L<T> _l, {required ConfigList config}) =>
      IListImpl._unsafe(_l, config: config);

  /// **Unsafe**.
  factory IList._unsafeFromList(List<T> list, {required ConfigList config}) =>
      IListImpl._unsafeFromList(list, config: config);

  /// Creates a list with `identityEquals` (compares the internals by `identity`).
  @useResult
  IList<T> get withIdentityEquals =>
      config.isDeepEquals ? IList._unsafe(_l, config: config.copyWith(isDeepEquals: false)) : this;

  /// Creates a list with `deepEquals` (compares all list items by equality).
  @useResult
  IList<T> get withDeepEquals =>
      config.isDeepEquals ? this : IList._unsafe(_l, config: config.copyWith(isDeepEquals: true));

  /// See also: [ConfigList]
  bool get isDeepEquals => config.isDeepEquals;

  /// See also: [ConfigList]
  bool get isIdentityEquals => !config.isDeepEquals;

  /// Unlocks the list, returning a regular (mutable, growable) [List]. This
  /// list is "safe", in the sense that is independent from the original [IList].
  List<T> get unlock => _l.unlock;

  /// Unlocks the list, returning a **safe**, unmodifiable (immutable) [List] view.
  /// The word "view" means the list is backed by the original [IList].
  /// Using this is very fast, since it makes no copies of the [IList] items.
  /// However, if you try to use methods that modify the list, like [add],
  /// it will throw an [UnsupportedError].
  /// It is also very fast to lock this list back into an [IList].
  ///
  /// See also: [UnmodifiableListFromIList]
  List<T> get unlockView => UnmodifiableListFromIList(this);

  /// Unlocks the list, returning a **safe**, modifiable (mutable) [List].
  /// Using this is very fast at first, since it makes no copies of the [IList]
  /// items. However, if and only if you use a method that mutates the list,
  /// like [add], it will unlock internally (make a copy of all [IList] items). This is
  /// transparent to you, and will happen at most only once. In other words,
  /// it will unlock the [IList], lazily, only if necessary.
  /// If you never mutate the list, it will be very fast to lock this list
  /// back into an [IList].
  ///
  /// See also: [ModifiableListFromIList]
  List<T> get unlockLazy => ModifiableListFromIList(this);

  /// Returns a new `Iterator` that allows iterating the elements of this [IList].
  @override
  Iterator<T> get iterator => _l.iterator;

  /// Returns `true` if there are no elements in this collection.
  @override
  bool get isEmpty => _l.isEmpty;

  /// Returns `true` if there is at least one element in this collection.
  @override
  bool get isNotEmpty => !isEmpty;

  /// - If [isDeepEquals] configuration is `true`:
  /// Will return `true` only if the list items are equal (and in the same order),
  /// and the list configurations are equal. This may be slow for very
  /// large lists, since it compares each item, one by one.
  ///
  /// - If [isDeepEquals] configuration is `false`:
  /// Will return `true` only if the lists internals are the same instances
  /// (comparing by identity). This will be fast even for very large lists,
  /// since it doesn't compare each item.
  ///
  /// Note: This is not the same as `identical(list1, list2)` since it doesn't
  /// compare the lists themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  ///
  @override
  bool operator ==(Object other) => (other is IList) && isDeepEquals
      ? equalItemsAndConfig(other)
      : (other is IList<T>) && same(other);

  /// Will return `true` only if the [IList] items are equal to the iterable items,
  /// and in the same order. This may be slow for very large lists, since it
  /// compares each item, one by one. You can compare the list with ordered
  /// sets, but unordered sets will throw a `StateError`. To compare the [IList]
  /// with unordered sets, try the [unorderedEqualItems] method.
  @override
  bool equalItems(covariant Iterable? other) {
    if (other == null) return false;
    if (identical(this, other)) return true;

    if (other is IList) {
      if (_isUnequalByHashCode(other)) return false;
      return (flush._l as LFlat).deepListEquals(other.flush._l as LFlat);
    }

    if (other is List<T>)
      return const ListEquality<dynamic>().equals(UnmodifiableListFromIList<T>(this), other);

    if (other is HashSet) throw StateError("Can't compare to HashSet (which is unordered).");

    return const IterableEquality<dynamic>().equals(_l, other);
  }

  /// Will return `true` only if the [IList] and the iterable items have the same number of elements,
  /// and the elements of the [IList] can be paired with the elements of the iterable, so that each
  /// pair is equal. This may be slow for very large lists, since it compares each item,
  /// one by one.
  bool unorderedEqualItems(covariant Iterable? other) {
    if (other == null) return false;
    if (identical(this, other) || (other is IList<T> && same(other))) return true;
    return const UnorderedIterableEquality<dynamic>().equals(_l, other);
  }

  /// Will return `true` only if the list items are equal and in the same order,
  /// and the list configurations are equal. This may be slow for very
  /// large lists, since it compares each item, one by one.
  @override
  bool equalItemsAndConfig(IList? other) {
    if (identical(this, other)) return true;

    // Objects with different hashCodes are not equal.
    if (_isUnequalByHashCode(other)) return false;

    return config == other!.config &&
        (identical(_l, other._l) || (flush._l as LFlat).deepListEquals(other.flush._l as LFlat));
  }

  /// Return `true` if other is `null` or the cached [hashCodes] proves the
  /// collections are **NOT** equal.
  ///
  /// Explanation: Objects with different [hashCode]s are not equal. However,
  /// if the [hashCode]s are the same, then nothing can be said about the equality.
  /// Note: We use the CACHED [hashCode]. If any of the [hashCode] is `null` it
  /// means we don't have this information yet, and we don't calculate it.
  bool _isUnequalByHashCode(IList? other) {
    return (other == null) ||
        (_hashCode != null && other._hashCode != null && _hashCode != other._hashCode);
  }

  /// Will return `true` if the lists internals are the same instances
  /// (comparing by identity). This will be fast even for very large lists,
  /// since it doesn't compare each item.
  ///
  /// May can also return `true` under some other situations where it's very
  /// cheap to determine that the lists are equal even if the lists internals
  /// are NOT the same.
  ///
  /// Note: This is not the same as `identical(list1, list2)` since it doesn't
  /// compare the lists themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  @override
  bool same(IList<T>? other) =>
      (other != null) && identical(_l, other._l) && (config == other.config);

  /// Flushes the list, if necessary. Chainable getter.
  /// If the list is already flushed, don't do anything.
  @override
  IList<T> get flush;

  /// Whether this list is already [flush]ed or not.
  @override
  bool get isFlushed => _l is LFlat;

  /// Return a new list with [item] added to the end of the current list,
  /// (thus extending the [length] by one).
  @useResult
  IList<T> add(T item) {
    final result = IList<T>._unsafe(_l.add(item), config: config);

    // A list created with `add` has a larger counter than its source list.
    // This improves the order in which lists are flushed.
    // If the outer list is used, it will be flushed before the source list.
    // If the source list is not used directly, it will not flush
    // unnecessarily, and also may be garbage collected.
    result._counter = _counter;
    result._count();

    return result;
  }

  /// Returns a new list with all [items] added to the end of the current list,
  /// (thus extending the [length] by the [length] of items).
  @useResult
  IList<T> addAll(Iterable<T> items) {
    if (_l is L<Never>) return IListImpl.unsafe(_l.cast<T>().toList(), config: config);
    final result = IList<T>._unsafe(_l.addAll(items), config: config);

    // A list created with `addAll` has a larger counter than both its source
    // lists. This improves the order in which lists are flushed.
    // If the outer list is used, it will be flushed before the source lists.
    // If the source lists are not used directly, they will not flush
    // unnecessarily, and also may be garbage collected.
    result._counter = max(_counter, ((items is IList<T>) ? (items)._counter : 0));
    result._count();

    return result;
  }

  /// Returns a new list where [newItems] are added or updated, by their [id]
  /// (and the [id] is a function of the item), like so:
  ///
  /// 1) Items with the same [id] will be replaced, in place.
  /// 2) Items with new [id]s will be added go to the end of the list.
  ///
  /// Note: If the original list contains more than one item with the same
  /// [id] as some item in [newItems], the first will be replaced, and the
  /// others will be left untouched. If [newItems] contains more than one
  /// item with the same [id], the last one will be used, and the previous
  /// discarded.
  ///
  @useResult
  IList<T> updateById(
    Iterable<T> newItems,
    dynamic Function(T item) id,
  ) =>
      IList._unsafeFromList(_l.updateById(newItems, id), config: config);

  /// Removes the **first** occurrence of [item] from this [IList].
  ///
  /// ```dart
  /// IList<String> parts = ["head", "shoulders", "knees", "toes"].lock;
  /// parts.remove("head");
  /// parts.join(", ");     // "shoulders, knees, toes"
  /// ```
  ///
  /// The method has no effect if [item] was not in the list.
  ///
  @useResult
  IList<T> remove(T item) {
    final L<T> result = _l.remove(item);
    return identical(result, _l) ? this : IList<T>._unsafe(result, config: config);
  }

  /// Removes all occurrences of all [items] from this list.
  /// Same as calling [removeMany] for each item in [items].
  ///
  /// The method has no effect if [item] was not in the list.
  ///
  @useResult
  IList<T> removeAll(Iterable<T?> items) {
    final L<T> result = _l.removeAll(items);
    return identical(result, _l) ? this : IList<T>._unsafe(result, config: config);
  }

  /// Removes all occurrences of [item] from this list.
  ///
  /// ```dart
  /// IList<String> parts = ["head", "shoulders", "knees", "head", "toes"].lock;
  /// parts.removeMany("head");
  /// parts.join(", ");     // "shoulders, knees, toes"
  /// ```
  ///
  /// The method has no effect if [item] was not in the list.
  ///
  @useResult
  IList<T> removeMany(T item) {
    final L<T> result = _l.removeMany(item);
    return identical(result, _l) ? this : IList<T>._unsafe(result, config: config);
  }

  /// Removes all nulls from this list.
  @useResult
  IList<T> removeNulls() => removeAll([null]);

  /// Removes duplicates (but keeps items which appear only
  /// once, plus the first time other items appear).
  @useResult
  IList<T> removeDuplicates() {
    final LinkedHashSet<T> set = _l.toLinkedHashSet();
    return IList<T>.withConfig(set, config);
  }

  /// Removes duplicates (but keeps items which appear only
  /// once, plus the first time other items appear).
  @useResult
  IList<T> removeNullsAndDuplicates() {
    final LinkedHashSet<T> set = _l.toLinkedHashSet();
    set.remove(null);
    return IList<T>.withConfig(set, config);
  }

  /// Removes the first instance of the element, if it exists in the list.
  /// Otherwise, adds it to the list.
  @useResult
  IList<T> toggle(T element) => contains(element) ? remove(element) : add(element);

  /// Returns the object at the given [index] in the list or throws a [RangeError] if [index] is out
  /// of bounds.
  T operator [](int index) {
    _count();
    return _l[index];
  }

  /// Returns the [index]th element.
  /// This is the same as using the [] operator.
  /// See also: [get] and [getOrNull].
  @override
  T elementAt(int index) {
    _count();
    return _l[index];
  }

  /// Returns the [index]th element.
  /// If that index doesn't exist (negative, or out of range), will return
  /// the result of calling [orElse]. In this case, if [orElse] is not provided,
  /// will throw an error.
  T get(int index, {T Function(int index)? orElse}) {
    if (orElse == null) return _l[index];
    return (index < 0 || index >= _l.length) //
        ? orElse(index)
        : _l[index];
  }

  /// Returns the [index]th element.
  /// If that index doesn't exist (negative or out of range), will return null.
  /// This method will never throw an error.
  T? getOrNull(int index) => (index < 0 || index >= _l.length) //
      ? null
      : _l[index];

  /// Gets the [index]th element, and then apply the [map] function to it, returning the result.
  /// If that index doesn't exist (negative, or out of range), will the [map] method
  /// will be called with `inRange` false and `value` null.
  T getAndMap(
    int index,
    T Function(int index, bool inRange, T? value) map,
  ) {
    final bool inRange = (index >= 0 && index < _l.length);

    final T? value = inRange ? _l[index] : null;
    return map(index, inRange, value);
  }

  /// Checks whether any element of this iterable satisfies [test].
  ///
  /// Checks every element in iteration order, and returns `true` if
  /// any of them make [test] return `true`, otherwise returns `false`.
  @override
  bool any(Predicate<T> test) => _l.any(test);

  /// Returns a list of [R] instances.
  /// If this list contains instances which cannot be cast to [R],
  /// it will throw an error.
  @override
  Iterable<R> cast<R>() => _l.cast<R>();

  /// Returns `true` if the collection contains an element equal to [element], `false` otherwise.
  @override
  bool contains(covariant T? element) {
    _count();
    return _l.contains(element);
  }

  /// Checks whether every element of this iterable satisfies [test].
  @override
  bool every(Predicate<T> test) => _l.every(test);

  /// Expands each element of this [Iterable] into zero or more elements.
  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => _l.expand(f);

  /// The number of objects in this list.
  @override
  int get length {
    final int length = _l.length;

    // Optimization: Flushes the list, if free.
    if (length == 0 && _l is! LFlat) _l = LFlat.empty<T>();

    return length;
  }

  /// Compare with [others] length
  bool lengthCompare(Iterable others) => length == others.length;

  /// Returns `true` if the given [index] is valid (between `0` and `length - 1`).
  bool inRange(int index) => index >= 0 && index < length;

  /// Returns the first element.
  /// Throws a [StateError] if the list is empty.
  @override
  T get first => _l.first;

  /// Returns the last element.
  /// Throws a [StateError] if the list is empty.
  @override
  T get last => _l.last;

  /// Checks that this iterable has only one element, and returns that element.
  /// Throws a [StateError] if the list is empty or has more than one element.
  @override
  T get single => _l.single;

  /// Returns the first element, or `null` if the list is empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element, or `null` if the list is empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Checks that the list has only one element, and returns that element.
  /// Return `null` if the list is empty or has more than one element.
  T? get singleOrNull => length != 1 ? null : single;

  /// Returns the first element, or [orElse] if the list is empty.
  T firstOr(T orElse) => isEmpty ? orElse : first;

  /// Returns the last element, or [orElse] if the list is empty.
  T lastOr(T orElse) => isEmpty ? orElse : last;

  /// Checks if the list has only one element, and returns that element.
  /// Return `null` if the list is empty or has more than one element.
  T singleOr(T orElse) => (length != 1) ? orElse : single;

  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// - If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned.
  /// - If [orElse] is omitted, it defaults to throwing a [StateError].
  @override
  T firstWhere(Predicate<T> test, {T Function()? orElse}) => _l.firstWhere(test, orElse: orElse);

  /// Reduces a collection to a single value by iteratively combining eac element of the collection
  /// with an existing value.
  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _l.fold(initialValue, combine);

  /// Returns the lazy concatenation of this iterable and [other].
  @override
  Iterable<T> followedBy(Iterable<T> other) => _l.followedBy(other);

  /// Applies the function [f] to each element of this collection in iteration order.
  @override
  void forEach(void Function(T element) f) {
    _l.forEach(f);
  }

  /// Returns the first element of this Iterable
  T get head => _l.first;

  /// Converts each element to a [String] and concatenates the strings with the [separator]
  /// in-between each concatenation.
  @override
  String join([String separator = ""]) => _l.join(separator);

  /// Returns the last element that satisfies the given predicate [test].
  @override
  T lastWhere(Predicate<T> test, {T Function()? orElse}) => _l.lastWhere(test, orElse: orElse);

  /// Returns a new lazy [Iterable] with elements that are created by calling [f] on each element of
  /// this [Iterable] in iteration order.
  @override
  Iterable<E> map<E>(E Function(T element) f, {ConfigList? config}) => _l.map(f);

  /// Reduces a collection to a single value by iteratively combining elements of the collection
  /// using the provided function.
  @override
  T reduce(T Function(T value, T element) combine) => _l.reduce(combine);

  /// Returns the single element that satisfies [test].
  @override
  T singleWhere(Predicate<T> test, {T Function()? orElse}) => _l.singleWhere(test, orElse: orElse);

  /// Returns an [Iterable] that provides all but the first [count] elements.
  @override
  Iterable<T> skip(int count) => _l.skip(count);

  /// Returns an [Iterable] that skips leading elements while [test] is satisfied.
  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _l.skipWhile(test);

  /// Returns an [Iterable] that is the original iterable without head, aka first element
  Iterable<T> get tail => _l.skip(1);

  Iterable<Iterable<T>> tails() =>
      IList.iterateWhile(this, (l) => l.isNotEmpty, (l) => l.toIList().tail);

  Iterable<Iterable<T>> inits() =>
      IList.iterateWhile(this, (l) => l.isNotEmpty, (l) => l.toIList().init);

  /// Returns an [Iterable] that is the original iterable without the last element
  Iterable<T> get init => _l.take(_l.length - 1);

  /// Returns an [Iterable] of the [count] first elements of this iterable.
  @override
  Iterable<T> take(int count) => _l.take(count);

  /// Returns an [Iterable] of the leading elements satisfying [test].
  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _l.takeWhile(test);

  /// Returns an [Iterable] with all elements that satisfy the predicate [test].
  @override
  Iterable<T> where(Predicate<T> test) => _l.where(test);

  /// Returns an [Iterable] with all elements that doest NOT satisfy the predicate [test].
  Iterable<T> whereNot(Predicate<T> test) => _l.where((e) => !test(e));

  /// Returns an [Iterable] with all elements that have type [E].
  @override
  Iterable<E> whereType<E>() => _l.whereType<E>();

  /// If the list has more than [maxLength] elements, remove the last elements
  /// so it remains with only [maxLength] elements. If the list has [maxLength]
  /// or less elements, doesn't change anything.
  ///
  /// If you want, you can provide a [priority] comparator, such as the elements to be removed are
  /// the ones that would be in the end of a list sorted with this comparator (the order of the
  /// remaining elements won't change).
  @useResult
  IList<T> maxLength(
    int maxLength, {
    int Function(T a, T b)? priority,
  }) {
    final originalLength = length;
    if (originalLength <= maxLength)
      return this;
    else if (priority == null)
      return IList._unsafe(_l.maxLength(maxLength), config: config);
    else {
      List<T> toBeRemovedFromEnd = unlock..sort(priority);
      toBeRemovedFromEnd = toBeRemovedFromEnd.sublist(maxLength);
      final result = <T>[];
      for (int i = originalLength - 1; i >= 0; i--) {
        final item = this[i];
        if (!toBeRemovedFromEnd.contains(item))
          result.add(item);
        else
          toBeRemovedFromEnd.remove(item);
      }
      return IList(result.reversed);
    }
  }

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// The [compare] function must act as a [Comparator].
  ///
  /// ```dart
  /// IList<String> numbers = ['two', 'three', 'four'].lock;
  /// // Sort from shortest to longest.
  /// numbers = numbers.sort((a, b) => a.length.compareTo(b.length));
  /// print(numbers);  // [two, four, three]
  /// ```
  ///
  /// The default list implementation use [Comparable.compare] if
  /// [compare] is omitted.
  ///
  /// ```dart
  /// IList<int> nums = [13, 2, -11].lock;
  /// nums = nums.sort();
  /// print(nums);  // [-11, 2, 13]
  /// ```
  ///
  /// A [Comparator] may compare objects as equal (return zero), even if they
  /// are distinct objects.
  /// The sort function is **not** guaranteed to be stable, so distinct objects
  /// that compare as equal may occur in any order in the result:
  ///
  /// ```dart
  /// IList<String> numbers = ['one', 'two', 'three', 'four'].lock;
  /// numbers = numbers.sort((a, b) => a.length.compareTo(b.length));
  /// print(numbers);  // [one, two, four, three] OR [two, one, four, three]
  /// ```
  ///
  @useResult
  IList<T> sort([int Function(T a, T b)? compare]) =>
      IList._unsafe(_l.sort(compare), config: config);

  /// Sorts this list in reverse order in relation to the default [sort] method.
  @useResult
  IList<T> sortReversed([int Function(T a, T b)? compare]) {
    return (compare != null)
        ? sort((T a, T b) => compare(b, a))
        : sort((T a, T b) => compareObject(b, a));
  }

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// This is similar to [sort], but uses a [merge sort algorithm](https://en.wikipedia.org/wiki/Merge_sort).
  ///
  /// On contrary to [sort], [sortOrdered] is stable, meaning distinct objects
  /// that compare as equal end up in the same order as they started in.
  ///
  /// ```dart
  /// IList<String> numbers = ['one', 'two', 'three', 'four'].lock;
  /// numbers = numbers.sort((a, b) => a.length.compareTo(b.length));
  /// print(numbers);  // [one, two, four, three]
  /// ```
  @useResult
  IList<T> sortOrdered([int Function(T a, T b)? compare]) =>
      IList._unsafe(_l.sortOrdered(compare), config: config);

  /// Sorts this list according to the order specified by the [ordering] iterable.
  /// Items which don't appear in [ordering] will be included in the end, in no particular order.
  ///
  /// Note: Not very efficient at the moment (will be improved in the future).
  /// Please use for a small number of items.
  ///
  @useResult
  IList<T> sortLike(Iterable<T> ordering) => IList._unsafe(_l.sortLike(ordering), config: config);

  /// Divides the list into two.
  /// The first one contains all items which satisfy the provided [test].
  /// The last one contains all the other items.
  /// The relative order of the items will be maintained.
  ///
  /// See also: [IListOf2]
  @useResult
  IListOf2<IList<T>> divideIn2(bool Function(T item) test) {
    final List<T> first = [];
    final List<T> last = [];
    for (final T item in this) {
      if (test(item))
        first.add(item);
      else
        last.add(item);
    }
    return IListOf2(
      IList._unsafeFromList(first, config: config),
      IList._unsafeFromList(last, config: config),
    );
  }

  /// Return true if length match and all Eq are true.
  bool corresponds<U>(Iterable<U> others, EQ eq) {
    if (length != others.length) return false;
    final iterator = others.iterator;
    for (final T item in this) {
      final next = iterator.moveNext();
      if (!next) return false;
      final U other = iterator.current;
      if (!eq(item, other)) return false;
    }
    return true;
  }

  /// Split the List at specified index
  (Iterable<T>, Iterable<T>) splitAt(int index) => (take(index), skip(index));

  /// Moves all items that satisfy the provided [test] to the end of the list.
  /// Keeps the relative order of the moved items.
  @useResult
  IList<T> whereMoveToTheEnd(bool Function(T item) test) {
    final IListOf2<IList<T>> lists = divideIn2(test);
    return lists.last + lists.first;
  }

  /// Moves all items that satisfy the provided [test] to the start of the list.
  /// Keeps the relative order of the moved items.
  @useResult
  IList<T> whereMoveToTheStart(bool Function(T item) test) {
    final IListOf2<IList<T>> lists = divideIn2(test);
    return lists.first + lists.last;
  }

  /// Creates a [List] containing the elements of this [IList].
  @override
  List<T> toList({bool growable = true}) => _l.toList(growable: growable);

  /// Creates a [Set] containing the same elements as this [IList].
  @override
  Set<T> toSet() => _l.toSet();

  /// Returns a string representation of (some of) the elements of `this`.
  ///
  /// Use either the [prettyPrint] or the [ImmutableCollection.prettyPrint] parameters to get a
  /// prettier print.
  ///
  /// See also: [ImmutableCollection]
  @override
  String toString([bool? prettyPrint]) {
    if (prettyPrint ?? ImmutableCollection.prettyPrint) {
      final int length = _l.length;
      if (length == 0) {
        return "[]";
      } else if (length == 1) {
        return "[${_l.single}]";
      } else {
        return "[\n   ${_l.join(",\n   ")}\n]";
      }
    } else {
      return "[${_l.join(", ")}]";
    }
  }

  /// Returns the concatenation of this list and [other].
  /// Returns a new list containing the elements of this list followed by
  /// the elements of [other].
  @useResult
  IList<T> operator +(Iterable<T> other) => addAll(other);

  /// Returns an [IMap] view of this list.
  /// The map uses the indices of this list as keys and the corresponding objects
  /// as values. The `Map.keys` [Iterable] iterates the indices of this list
  /// in numerical order.
  ///
  /// ```dart
  /// final IList<String> words = ['hel', 'lo', 'there'].lock;
  /// final IMap<int, String> imap = words.asMap();
  /// print(imap[0] + imap[1]); // Prints 'hello';
  /// imap.keys.toList(); // [0, 1, 2, 3]
  /// ```
  @useResult
  IMap<int, T> asMap() => IMap<int, T>(UnmodifiableListFromIList(this).asMap());

  /// Returns an empty list with the same configuration.
  @useResult
  IList<T> clear() => IListImpl.empty<T>(config);

  /// Returns the index of the first [element] in the list.
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object [:o:] is encountered so that [:o == element:],
  /// the index of [:o:] is returned.
  ///
  /// If [start] is not provided, this method searches from the start of the list.
  ///
  /// If [start] is provided and is different than zero, it will throw an ArgumentError
  /// in case it's `< 0` or `>= length`.
  ///
  /// ```dart
  /// final IList<String> notes = ['do', 're', 'mi', 're'].lock;
  /// notes.indexOf('re');    // 1
  /// notes.indexOf('re', 2); // 3
  /// ```
  ///
  /// Returns `-1` if [element] is not found.
  ///
  /// ```dart
  /// notes.indexOf('fa');    // -1
  /// ```
  int indexOf(T element, [int start = 0]) {
    _count();
    final _length = length;
    if (start < 0 || (start > 0 && start >= _length))
      throw ArgumentError.value(start, "index", "Index out of range");
    for (int i = start; i < _length; i++) if (this[i] == element) return i;
    return -1;
  }

  /// This is the equivalent to `void operator []=(int index, T value);` for the [IList].
  /// Sets the value at the given [index] in the list to [value]
  /// or throws a [RangeError] if [index] is out of bounds.
  ///
  /// See also: [replace] (same as [put]) and [replaceBy].
  @useResult
  IList<T> put(int index, T value) {
    _count();
    return replace(index, value);
  }

  /// Finds the first occurrence of [from], and replace it with [to].
  @useResult
  IList<T> replaceFirst({required T from, required T to}) {
    final index = indexOf(from);
    return (index == -1) ? this : put(index, to);
  }

  /// Finds all occurrences of [from], and replace them with [to].
  @useResult
  IList<T> replaceAll({required T from, required T to}) =>
      map((element) => (element == from) ? to : element).toIList(config);

  /// Finds the first item that satisfies the provided [test],
  /// and replace it with the result of [replacement].
  ///
  /// - If [addIfNotFound] is `false`, return the unchanged
  /// list if no item satisfies the [test].
  ///
  /// - If [addIfNotFound] is `true`, add the [replacement]
  /// to the end of the list if no item satisfies the [test].
  ///
  @useResult
  IList<T> replaceFirstWhere(
    bool Function(T item) test,
    T Function(T? item) replacement, {
    bool addIfNotFound = false,
  }) {
    final int index = indexWhere(test);
    return (index != -1)
        ? put(index, replacement(this[index]))
        : addIfNotFound
            ? add(replacement(null))
            : this;
  }

  /// Finds all items that satisfy the provided [test],
  /// and replace it with [to].
  @useResult
  IList<T> replaceAllWhere(Predicate<T> test, T to) =>
      map((element) => test(element) ? to : element).toIList(config);

  /// Allows for complex processing of a list.
  ///
  /// Iterates through each [item]. If the item satisfies the provided [test],
  /// replace it with applying [convert]. Otherwise, keep the item unchanged.
  /// If [test] is not provided, it will apply [convert] to all items.
  ///
  /// Function [convert] can:
  ///
  /// - Keep the [item] unchanged by returning `null`.
  /// - Remove an [item] by returning an empty iterable.
  /// - Convert an [item] to a single item by returning an iterable with an item.
  /// - Convert an [item] to many items, by returning an iterable with multiple
  /// items.
  ///
  /// If no [item]s satisfy the [test], or if [convert] kept items unchanged,
  /// [process] will return the same list instance.
  ///
  @useResult
  IList<T> process({
    bool Function(IList<T> list, int index, T item)? test,
    required Iterable<T>? Function(IList<T> list, int index, T item) convert,
  }) {
    bool any = false;
    final List<T> result = [];
    final int _length = length;
    for (int index = 0; index < _length; index++) {
      final T item = this[index];
      final satisfiesTest = (test == null) || test(this, index, item);
      if (!satisfiesTest)
        result.add(item);
      else {
        final converted = convert(this, index, item);

        // Keep the item unchanged by returning `null`.
        if (converted == null) {
          result.add(item);
        }
        // Remove an item by returning an empty iterable.
        else if (converted.isEmpty) {
          any = true;
        }
        // Convert an item to a single item by returning an iterable with an item.
        else if (converted.length == 1) {
          final newItem = converted.first;
          result.add(newItem);
          if (!identical(item, newItem)) any = true;
        }
        // Convert an item to many items, by returning an iterable with multiple
        else {
          result.addAll(converted);
          any = true;
        }
      }
    }
    return any ? IList._unsafeFromList(result, config: config) : this;
  }

  /// Returns the first index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `obj` is encountered so that `test(obj)` is true,
  /// the index of `obj` is returned.
  ///
  /// ```dart
  /// final IList<String> notes = ['do', 're', 'mi', 're'].lock;
  /// notes.indexWhere((note) => note.startsWith('r'));       // 1
  /// notes.indexWhere((note) => note.startsWith('r'), 2);    // 3
  /// ```
  ///
  /// Returns `-1` if [element] is not found.
  ///
  /// ```dart
  /// notes.indexWhere((note) => note.startsWith('k'));       // -1
  /// ```
  int indexWhere(Predicate<T> test, [int start = 0]) {
    final _length = length;
    if (_length == 0) return -1;
    if (start < 0 || start >= _length)
      throw ArgumentError.value(start, "index", "Index out of range");
    for (int i = start; i <= _length - 1; i++) if (test(this[i])) return i;
    return -1;
  }

  /// Returns the last index of [element] in this list.
  ///
  /// Searches the list backwards from index [start] to `0`.
  ///
  /// The first time an object [:o:] is encountered such that [:o == element:],
  /// the index of [:o:] is returned.
  ///
  /// ```dart
  /// final IList<String> notes = ['do', 're', 'mi', 're'].lock;
  /// notes.lastIndexOf('re', 2); // 1
  /// ```
  ///
  /// If [start] is not provided, this method searches from the end of the list.
  ///
  /// ```dart
  /// notes.lastIndexOf('re');    // 3
  /// ```
  ///
  /// Returns `-1` if [element] is not found.
  ///
  /// ```dart
  /// notes.lastIndexOf('fa');    // -1
  /// ```
  int lastIndexOf(T element, [int? start]) {
    final _length = length;
    start ??= _length;
    if (start < 0) throw ArgumentError.value(start, "index", "Index out of range");
    for (int i = min(start, _length - 1); i >= 0; i--) if (this[i] == element) return i;
    return -1;
  }

  /// Returns the last index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to `0`.
  /// The first time an object `obj` is encountered such that `test(obj)` is `true`,
  /// the index of `obj` is returned.
  /// If [start] is omitted, it defaults to the [length] of the list.
  ///
  /// ```dart
  /// final IList<String> notes = ['do', 're', 'mi', 're'].lock;
  /// notes.lastIndexWhere((note) => note.startsWith('r'));       // 3
  /// notes.lastIndexWhere((note) => note.startsWith('r'), 2);    // 1
  /// ```
  ///
  /// Returns `-1` if [element] is not found.
  ///
  /// ```dart
  /// notes.lastIndexWhere((note) => note.startsWith('k'));       // -1
  /// ```
  int lastIndexWhere(Predicate<T> test, [int? start]) {
    final _length = length;
    start ??= _length;
    if (start < 0) throw ArgumentError.value(start, "index", "Index out of range");
    for (int i = min(start, _length - 1); i >= 0; i--) if (test(this[i])) return i;
    return -1;
  }

  /// Removes the objects in the range [start] inclusive to [end] exclusive
  /// and inserts the contents of [replacement] in its place.
  ///
  /// ```dart
  /// final IList<int> ilist = [1, 2, 3, 4, 5].lock;
  /// ilist.replaceRange(1, 4, [6, 7]).join(', '); // '1, 6, 7, 5'
  /// ```
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` is this list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  /// This method does not work on fixed-length lists, even when [replacement]
  /// has the same number of elements as the replaced range. In that case use
  /// [setRange] instead.
  ///
  @useResult
  IList<T> replaceRange(int start, int end, Iterable<T> replacement) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: true)..replaceRange(start, end, replacement),
        config: config);
  }

  /// Sets the objects in the range [start] inclusive to [end] exclusive
  /// to the given [fillValue].
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` is this list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  /// Example with [List]:
  ///
  /// ```dart
  /// final List<int> list = List(3);
  /// list.fillRange(0, 2, 1);
  /// print(list);  // [1, 1, null]
  /// ```
  ///
  /// Example with [IList]:
  ///
  /// ```dart
  /// final IList<int> ilist = IList();
  /// ilist.fillRange(0, 2, 1);
  /// print(ilist); // [1, 1, null]
  /// ```
  ///
  /// If the element type is not nullable, omitting [fillValue] or passing `null`
  /// as [fillValue] will make the `fillRange` fail.
  ///
  @useResult
  IList<T> fillRange(int start, int end, [T? fillValue]) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: false)..fillRange(start, end, fillValue),
        config: config);
  }

  /// Returns an [Iterable] that iterates over the objects in the range
  /// [start] inclusive to [end] exclusive.
  ///
  /// The provided range, given by [start] and [end], must be valid, which
  /// means `0 <= start <= end <= len`, where `len` is this list's `length`.
  /// The range starts at `start` and has length `end - start`.
  /// An empty range (with `end == start`) is valid.
  ///
  /// The returned [Iterable] behaves like `skip(start).take(end - start)`.
  ///
  /// ```dart
  /// final IList<String> colors = ['red', 'green', 'blue', 'orange', 'pink'].lock;
  /// final Iterable<String> range = colors.getRange(1, 4);
  /// range.join(', ');  // 'green, blue, orange'
  /// ```
  ///
  /// This method exists just to make the `IList` API more similar to that of
  /// the `List`, but to get a range here you should probably use the
  /// `IList.sublist()` method instead.
  ///
  @useResult
  Iterable<T> getRange(int start, int end) {
    // TODO: Still need to implement efficiently.
    return toList(growable: false).getRange(start, end);
  }

  /// Returns a new list containing the elements between [start] and [end].
  ///
  /// The new list is a `List<E>` containing the elements of this list at
  /// positions greater than or equal to [start] and less than [end] in the same
  /// order as they occur in this list.
  ///
  /// ```dart
  /// final IList<String> colors = ["red", "green", "blue", "orange", "pink"].lock;
  /// print(colors.sublist(1, 3)); // [green, blue]
  /// ```
  ///
  /// If [end] is omitted, it defaults to the [length] of this list.
  ///
  /// ```dart
  /// print(colors.sublist(1));    // [green, blue, orange, pink]
  /// ```
  ///
  /// The `start` and `end` positions must satisfy the relations
  /// 0 ≤ `start` ≤ `end` ≤ `this.length`
  /// If `end` is equal to `start`, then the returned list is empty.
  @useResult
  IList<T> sublist(int start, [int? end]) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: false).sublist(start, end), config: config);
  }

  /// This is the equivalent to `void operator []=(int index, T value);` for the [IList].
  /// Sets the value at the given [index] in the list to [value]
  /// or throws a [RangeError] if [index] is out of bounds.
  ///
  /// See also: [put] (same as [replace]) and [replaceBy].
  @useResult
  IList<T> replace(int index, T value) {
    // TODO: Still need to implement efficiently.
    final newList = toList(growable: false);
    newList[index] = value;
    return IList._unsafeFromList(newList, config: config);
  }

  /// Returns a new [IList], replacing the object at position [index] with the result of calling
  /// the function [transform]. This function gets the previous object at position [index] as a
  /// parameter.
  ///
  /// If the index doesn't exist (negative, or out of range), will throw an error.
  ///
  /// See also: [replace].
  @useResult
  IList<T> replaceBy(int index, T Function(T item) transform) {
    final T originalValue = get(index);
    final T transformed = transform(originalValue);
    return replace(index, transformed);
  }

  /// Inserts the object at position [index] in this list and returns a new immutable list.
  ///
  /// This increases the [length] of the list by one and shifts all objects
  /// at or after the index towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  @useResult
  IList<T> insert(int index, T element) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: true)..insert(index, element), config: config);
  }

  /// Inserts all objects of [iterable] at position [index] in this list.
  ///
  /// This increases the [length] of the list by the length of [iterable] and
  /// shifts all later objects towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  @useResult
  IList<T> insertAll(int index, Iterable<T> iterable) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: true)..insertAll(index, iterable),
        config: config);
  }

  /// Removes the object at position [index] from this list.
  ///
  /// This method reduces the length of `this` by one and moves all later objects
  /// down by one position.
  ///
  /// Returns the list without the removed object.
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  ///
  /// If you want to recover the removed item, you can pass a mutable [removedItem].
  @useResult
  IList<T> removeAt(int index, [Output<T>? removedItem]) {
    // TODO: Still need to implement efficiently.
    final list = toList(growable: true);
    final value = list.removeAt(index);
    removedItem?.save(value);
    return IList._unsafeFromList(list, config: config);
  }

  /// Removes the last object from this list.
  /// This method reduces the length of `this` by one.
  ///
  /// The list must not be empty.
  ///
  /// If you want to recover the removed item, you can pass a mutable [removedItem].
  ///
  @useResult
  IList<T> removeLast([Output<T>? removedItem]) => removeAt(length - 1, removedItem);

  /// Removes the objects in the range [start] inclusive to [end] exclusive.
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` is this list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  @useResult
  IList<T> removeRange(int start, int end) {
    // TODO: Still need to implement efficiently.
    final list = toList(growable: true);
    list.removeRange(start, end);
    return IList._unsafeFromList(list, config: config);
  }

  /// Removes all objects from this list that satisfy [test].
  ///
  /// An object [:o:] satisfies [test] if [:test(o):] is `true`.
  ///
  /// ```dart
  /// final IList<String> numbers = ['one', 'two', 'three', 'four'].lock;
  /// final IList<String> newNumbers = numbers.removeWhere((item) => item.length == 3);
  /// newNumbers.join(', '); // 'three, four'
  /// ```
  @useResult
  IList<T> removeWhere(Predicate<T> test) {
    // TODO: Still need to implement efficiently.
    final list = toList(growable: true);
    list.removeWhere(test);
    return IList._unsafeFromList(list, config: config);
  }

  /// Removes all objects from this list that fail to satisfy [test].
  ///
  /// An object [:o:] satisfies [test] if [:test(o):] is true.
  ///
  /// ```dart
  /// final IList<String> numbers = ['one', 'two', 'three', 'four'].lock;
  /// final IList<String> newNumbers = numbers.retainWhere((item) => item.length == 3);
  /// newNumbers.join(', '); // 'one, two'
  /// ```
  @useResult
  IList<T> retainWhere(Predicate<T> test) {
    // TODO: Still need to implement efficiently.
    final list = toList(growable: true);
    list.retainWhere(test);
    return IList._unsafeFromList(list, config: config);
  }

  /// Returns an [Iterable] of the objects in this list in reverse order.
  @useResult
  IList<T> get reversed {
    // TODO: Still need to implement efficiently.
    final Iterable<T> list = UnmodifiableListFromIList(this).reversed;
    return IList.withConfig(list, config);
  }

  /// Overwrites objects of `this` with the objects of [iterable], starting
  /// at position [index] in this list.
  ///
  /// ```dart
  /// final IList<String> ilist = ['a', 'b', 'c'].lock;
  /// ilist.setAll(1, ['bee', 'sea']).join(', '); // 'a, bee, sea'
  /// ```
  ///
  /// This operation does not increase the [length] of `this`.
  ///
  /// The [index] must be non-negative and no greater than [length].
  ///
  /// The [iterable] must not have more elements than what can fit from [index]
  /// to [length].
  ///
  /// If `iterable` is based on this list, its values may change *during* the
  /// `setAll` operation.
  @useResult
  IList<T> setAll(int index, Iterable<T> iterable) {
    // TODO: Still need to implement efficiently.
    final list = toList(growable: true);
    list.setAll(index, iterable);
    return IList._unsafeFromList(list, config: config);
  }

  /// Copies the objects of [iterable], skipping [skipCount] objects first,
  /// into the range [start], inclusive, to [end], exclusive, of the list.
  ///
  /// ```dart
  /// final IList<int> iList1 = [1, 2, 3, 4].lock;
  /// final IList<int> iList2 = [5, 6, 7, 8, 9].lock;
  /// // Copies the 4th and 5th items in iList2 as the 2nd and 3rd items of iList1.
  /// iList1.setRange(1, 3, iList2, 3).join(', '); // '1, 8, 9, 4'
  /// ```
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` is this list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  /// The [iterable] must have enough objects to fill the range from `start`
  /// to `end` after skipping [skipCount] objects.
  ///
  /// If [iterable] is `this` list, the operation copies the elements
  /// originally in the range from `skipCount` to `skipCount + (end - start)` to
  /// the range `start` to `end`, even if the two ranges overlap.
  ///
  /// If [iterable] depends on this list in some other way, no guarantees are
  /// made.
  ///
  @useResult
  IList<T> setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    // TODO: Still need to implement efficiently.
    final list = toList(growable: true);
    list.setRange(start, end, iterable, skipCount);
    return IList._unsafeFromList(list, config: config);
  }

  /// Shuffles the elements of this list randomly.
  @useResult
  IList<T> shuffle([Random? random]) =>
      IList._unsafeFromList(toList()..shuffle(random), config: config);

  /// Positives predicate results count
  int count(Predicate<T> p) => where(p).length;

  /// Split list based on predicate p. (takeWhile p, dropWhile p)
  (Iterable<T>, Iterable<T>) span(Predicate<T> p) {
    final i = indexWhere((e) => !p(e));
    final idx = i < 0 ? length : i;
    return (getRange(0, idx), getRange(idx, length));
  }

  /// Aggregate each element with corresponding index
  Iterable<(int, T)> zipWithIndex() =>
      Iterable.generate(length, (index) => (index, _l[index])).toIList(config);

  /// Aggregate two sources trimming by the shortest source
  Iterable<(T, U)> zip<U>(Iterable<U> otherIterable) {
    final other = otherIterable.toList();
    final minLength = min(length, other.length);
    return Iterable.generate(minLength, (index) => (_l[index], other[index])).toIList(config);
  }

  /// Aggregate two sources based on the longest source.
  /// Missing elements can be completed by passing a [currentFill] and [otherFill] methods or will be at null by default
  Iterable<(T?, U?)> zipAll<U>(
    Iterable<U> otherIterable, {
    T Function(int index)? currentFill,
    U Function(int index)? otherFill,
  }) {
    final other = otherIterable.toList();
    final current = toList(growable: false);
    final maxLength = max(current.length, other.length);

    Object? getOrFill(List l, int index, Function? fill) => index < l.length
        ? l[index]
        : fill != null
            ? fill(index)
            : null;

    return Iterable.generate(
        maxLength,
        (index) => (
              getOrFill(current, index, currentFill) as T?,
              getOrFill(other, index, otherFill) as U?,
            )).toIList(config);
  }
}

abstract class L<T> implements Iterable<T> {
  //

  /// The [L] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  ///
  /// Note these fallback methods need to calculate the flushed list, but
  /// because that's immutable, we cache it.
  List<T>? _flushed;

  /// Returns the flushed list (flushes it only once).
  /// **It is an error to use the flushed list outside of the [L] class**.
  List<T> get getFlushed {
    _flushed ??= unlock;
    return _flushed!;
  }

  /// Returns a regular Dart (*mutable*, `growable`) List.
  List<T> get unlock => List<T>.of(this, growable: true);

  /// Returns a new `Iterator` that allows iterating the items of the [IList].
  @override
  Iterator<T> get iterator;

  @override
  bool get isEmpty => iter.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  Iterable<T> get iter;

  L<T> add(T item) {
    return LAdd<T>(this, item);
  }

  L<T> addAll(Iterable<T> items) => LAddAll<T>(
        this,
        ((items is IList<T>) ? (items)._l : items),
      );

  // TODO: Still need to implement efficiently.
  /// Removes the first occurrence of [element] from this list.
  L<T> remove(T element) => !contains(element) ? this : LFlat<T>.unsafe(unlock..remove(element));

  L<T> removeAll(Iterable<T?> elements) {
    var list = unlock;
    final originalLength = list.length;
    final set = HashSet.of(elements);
    list = unlock..removeWhere((e) => set.contains(e));
    if (list.length == originalLength) return this;
    return LFlat<T>.unsafe(list);
  }

  // TODO: Still need to implement efficiently.
  L<T> removeMany(T element) =>
      !contains(element) ? this : LFlat<T>.unsafe(unlock..removeWhere((e) => e == element));

  // TODO: Still need to implement efficiently.
  /// If the list has more than `maxLength` elements, removes the last elements so it remains
  /// with only `maxLength` elements. If the list has `maxLength` or less elements, doesn't
  /// change anything.
  L<T> maxLength(int maxLength) => maxLength < 0
      ? throw ArgumentError(maxLength)
      : length <= maxLength
          ? this
          : LFlat<T>.unsafe(unlock..length = maxLength);

  /// Sorts this list according to the order specified by the [compare] function.
  /// If [compare] is not provided, it will use the natural ordering of the type [T].
  L<T> sort([int Function(T a, T b)? compare]) {
    // Explicitly sorts MapEntry (since MapEntry is not Comparable).
    if ((compare == null) && (T == MapEntry))
      compare = (T a, T b) => (a as MapEntry).compareKeyAndValue(b as MapEntry);

    return LFlat<T>.unsafe(unlock..sort(compare ?? compareObject));
  }

  L<T> sortOrdered([int Function(T a, T b)? compare]) {
    // Explicitly sorts MapEntry (since MapEntry is not Comparable).
    if ((compare == null) && (T == MapEntry))
      compare = (T a, T b) => (a as MapEntry).compareKeyAndValue(b as MapEntry);

    return LFlat<T>.unsafe(unlock..sortOrdered(compare ?? compareObject));
  }

  /// Sorts this list according to the order specified by the [ordering] iterable.
  /// Items which don't appear in [ordering] will be included in the end, in no particular order.
  ///
  /// Note: Not very efficient at the moment (will be improved in the future).
  /// Please use for a small number of items.
  ///
  L<T> sortLike(Iterable<T> ordering) {
    final Set<T> orderingSet = Set.of(ordering);
    final Set<T> newSet = Set.of(this);
    final Set<T> intersection = orderingSet.intersection(newSet);
    final Set<T> difference = newSet.difference(orderingSet);
    final List<T> result = ordering.where((element) => intersection.contains(element)).toList();
    result.addAll(difference);
    return LFlat<T>.unsafe(result);
  }

  @override
  bool any(Predicate<T> test) => iter.any(test);

  @override
  Iterable<R> cast<R>() => iter.cast<R>();

  @override
  bool contains(covariant T? element) => iter.contains(element);

  T operator [](int index);

  @override
  T elementAt(int index) => this[index];

  @override
  bool every(Predicate<T> test) => iter.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => iter.expand(f);

  @override
  int get length;

  @override
  T get first;

  @override
  T get last;

  @override
  T get single;

  @override
  T firstWhere(Predicate<T> test, {T Function()? orElse}) => iter.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iter.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => iter.followedBy(other);

  @override
  void forEach(void Function(T element) f) => iter.forEach(f);

  @override
  String join([String separator = ""]) => iter.join(separator);

  @override
  T lastWhere(Predicate<T> test, {T Function()? orElse}) => iter.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T element) f) => iter.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => iter.reduce(combine);

  @override
  T singleWhere(Predicate<T> test, {T Function()? orElse}) =>
      iter.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => iter.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => iter.skipWhile(test);

  @override
  Iterable<T> take(int count) => iter.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => iter.takeWhile(test);

  @override
  Iterable<T> where(Predicate<T> test) => iter.where(test);

  @override
  Iterable<E> whereType<E>() => iter.whereType<E>();

  @override
  List<T> toList({bool growable = true}) => List.of(iter, growable: growable);

  /// Ordered set.
  @override
  Set<T> toSet() => Set.of(iter);

  /// Ordered set. Same as [toSet].
  LinkedHashSet<T> toLinkedHashSet() => LinkedHashSet.of(iter);

  /// Ordered set which is also a list.
  /// Returns a [ListSet], which has the same performance and needs
  /// less memory than a [LinkedHashSet], but can't change size.
  ListSet<T> toListSet() => ListSet.of(iter);

  /// Unordered set. Returns a [HashSet], which is faster than [LinkedHashSet]
  /// and consumes less memory.
  HashSet<T> toHashSet() => HashSet.of(iter);
}

/// **Don't use this class**.
@visibleForTesting
class InternalsForTestingPurposesIList {
  IList ilist;

  InternalsForTestingPurposesIList(this.ilist);

  /// To access the private counter, add this to the test file:
  ///
  /// ```dart
  /// extension TestExtension on IList {
  ///   int get counter => InternalsForTestingPurposesIList(this).counter;
  /// }
  /// ```
  int get counter => ilist._counter;
}

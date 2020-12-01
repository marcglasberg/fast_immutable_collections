import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "dart:collection";
import "package:meta/meta.dart";

/// The [UnmodifiableListView] is a relatively safe, unmodifiable [List] that is built from an
/// [IList] or another [List]. The construction of the [UnmodifiableListView] is very fast,
/// since it makes no copies of the given list items, but just uses it directly.
///
/// If you try to use methods that modify the [UnmodifiableListView], like [add],
/// it will throw an [UnsupportedError].
///
/// If you create it from an [IList], it is also very fast to lock the [UnmodifiableListView]
/// back into an [IList].
///
/// <br>
///
/// ## How does it compare to [List.unmodifiable]?
///
/// [List.unmodifiable] is slow, but it's always safe, because *it is not a view*, and
/// actually creates a new list. On the other hand, [UnmodifiableListView] is fast, but if
/// you create it from a regular [List] and then modify that original [List], you will also
/// be modifying the view. Also note, if you create an [UnmodifiableListView] from an [IList],
/// then it's totally safe because the original [IList] can't be modified &mdash; unless of course,
/// again, you've created it from a [IList.unsafe] constructor.
///
/// See also: [ModifiableListView]
@immutable
class UnmodifiableListView<T> with ListMixin<T> implements List<T>, CanBeEmpty {
  final IList<T> _iList;
  final List<T> _list;

  /// Create an unmodifiable [List] view of type [UnmodifiableListView], from an [ilist].
  UnmodifiableListView(IList<T> ilist)
      : _iList = (ilist != null) ? ilist : IList.empty<T>(),
        _list = null;

  /// Create an unmodifiable [List] view of type [UnmodifiableListView], from another [List].
  UnmodifiableListView.fromList(List<T> list)
      : _iList = null,
        _list = list;

  @override
  T operator [](int index) => (_iList != null) ? _iList[index] : _list[index];

  @override
  void operator []=(int index, T value) => throw UnsupportedError("List in unmodifiable.");

  @override
  int get length => (_iList != null) ? _iList.length : _list.length;

  @override
  set length(int newLength) => throw UnsupportedError("List in unmodifiable.");

  @override
  void add(T value) => throw UnsupportedError("List in unmodifiable.");

  @override
  void addAll(Iterable<T> values) => throw UnsupportedError("List in unmodifiable.");

  /// Locks the list, returning an *immutable* list ([IList]).
  IList<T> get lock => (_iList != null) ? _iList : _list.lock;
}

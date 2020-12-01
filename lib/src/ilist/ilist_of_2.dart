import "../base/hash.dart";

// /////////////////////////////////////////////////////////////////////////////

/// An *immutable* list of only 2 items.
class IListOf2<T> {
  final T first, last;

  const IListOf2(this.first, this.last);

  @override
  String toString() => "[$first, $last]";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IListOf2 &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          last == other.last;

  @override
  int get hashCode => hashObj2(first, last);
}

// /////////////////////////////////////////////////////////////////////////////

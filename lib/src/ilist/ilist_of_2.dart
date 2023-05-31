// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import 'package:meta/meta.dart';

import "../base/hash.dart";

/// An *immutable* list of only 2 items.
@immutable
class IListOf2<T> {
  //
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

/// Dedicated Indexation Zip
// TODO required non-function type alias since dart 2.13
// typedef IndexedZip<T> = Zip<int, T>;

abstract class Tuple {
  //
  final int arity;

  const Tuple(this.arity);
}

/// Resulting composition of multiple sources like indexes or other Iterables.
/// Adapted from Tuple package
class Tuple2<T1, T2> extends Tuple {
  //
  /// Returns the first item of the tuple
  final T1 first;

  /// Returns the second item of the tuple
  final T2 second;

  /// Creates a new tuple value with the specified items.
  const Tuple2(this.first, this.second) : super(2);

  /// Operator access
  Object? operator [](int i) {
    if (i == 0)
      return first;
    else if (i == 1)
      return second;
    else
      throw IndexError.withLength(i, 2, indexable: this);
  }

  /// Create a new tuple value with the specified list [items].
  factory Tuple2.fromList(List items) {
    if (items.length != 2) {
      throw ArgumentError('items must have length 2');
    }

    return Tuple2<T1, T2>(items[0] as T1, items[1] as T2);
  }

  /// Returns a tuple with the first item set to the specified value.
  Tuple2<T1, T2> withItem1(T1 v) => Tuple2<T1, T2>(v, second);

  /// Returns a tuple with the second item set to the specified value.
  Tuple2<T1, T2> withItem2(T2 v) => Tuple2<T1, T2>(first, v);

  /// Creates a [List] containing the items of this [Tuple2].
  ///
  /// The elements are in item order. The list is variable-length
  /// if [growable] is true.
  List toList({bool growable = false}) => List.from([first, second], growable: growable);

  @override
  String toString() => '($first, $second)';

  @override
  bool operator ==(Object other) =>
      other is Tuple2 && other.first == first && other.second == second;

  @override
  int get hashCode => hash2(first.hashCode, second.hashCode);
}

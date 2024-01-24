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

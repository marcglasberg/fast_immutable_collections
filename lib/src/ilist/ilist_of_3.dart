// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import 'package:meta/meta.dart';

import "../base/hash.dart";

/// An *immutable* list of only 3 items.
@immutable
class IListOf3<T> {
  //
  final T first, second, third;

  const IListOf3(this.first, this.second, this.third);

  @override
  String toString() => "[$first, $second, $third]";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IListOf3 &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second &&
          third == other.third;

  @override
  int get hashCode => hashObj3(first, second, third);
}

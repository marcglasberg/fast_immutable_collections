import 'package:meta/meta.dart';

import "../base/hash.dart";

/// An *immutable* list of only 3 items.
@immutable
class IListOf4<T> {
  final T first, second, third, fourth;

  const IListOf4(this.first, this.second, this.third, this.fourth);

  @override
  String toString() => "[$first, $second, $third, $fourth]";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IListOf4 &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second &&
          third == other.third &&
          fourth == other.fourth;

  @override
  int get hashCode => hashObj4(first, second, third, fourth);
}



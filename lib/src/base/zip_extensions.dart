import 'package:fast_immutable_collections/fast_immutable_collections.dart';

extension FICZipExtension<U, V> on Iterable<Tuple2<U, V>> {
  /// Iterable Tuple2 as Iterable
  Tuple2<Iterable<U>, Iterable<V>> unzip() => Tuple2(
      Iterable<U>.generate(length, (idx) => elementAt(idx).first),
      Iterable<V>.generate(length, (idx) => elementAt(idx).second));
}

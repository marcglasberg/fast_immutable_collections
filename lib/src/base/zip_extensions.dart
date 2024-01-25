extension FICZipExtension<U, V> on Iterable<(U, V)> {
  /// Iterable Record as Iterable
  (Iterable<U>, Iterable<V>) unzip() => (
        Iterable<U>.generate(length, (idx) => elementAt(idx).$1),
        Iterable<V>.generate(length, (idx) => elementAt(idx).$2)
      );
}

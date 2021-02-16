// The code in this file is copied and adapted from Quiver:
// https://github.com/google/quiver-dart/blob/master/lib/src/core/hash.dart

/// Jenkins's hash code for two objects.
int hashObj2(Object? a, Object? b) => _finish(
      _combine(_combine(0, a.hashCode), b.hashCode),
    );

/// Jenkins's hash code for three objects.
int hashObj3(Object? a, Object? b, Object? c) => _finish(
      _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
    );

/// Jenkins's hash code for four objects.
int hashObj4(Object? a, Object? b, Object? c, Object? d) => _finish(
      _combine(
        _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
        d.hashCode,
      ),
    );

/// Jenkins's hash code for five objects.
int hashObj5(Object a, Object b, Object c, Object d, Object e) => _finish(
      _combine(
        _combine(
          _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
          d.hashCode,
        ),
        e.hashCode,
      ),
    );

/// Jenkins's hash code for two hashes.
int hash2(int a, int b) => _finish(
      _combine(_combine(0, a), b),
    );

/// Jenkins's hash code for three hashes.
int hash3(int a, int b, int c) => _finish(
      _combine(_combine(_combine(0, a), b), c),
    );

/// Jenkins's hash code for four hashes.
int hash4(int a, int b, int c, int d) => _finish(
      _combine(_combine(_combine(_combine(0, a), b), c), d),
    );

/// Jenkins's hash code for five hashes.
int hash5(int a, int b, int c, int d, int e) => _finish(
      _combine(_combine(_combine(_combine(_combine(0, a), b), c), d), e),
    );

int _combine(int hash, int value) {
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}

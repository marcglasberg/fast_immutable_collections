// /////////////////////////////////////////////////////////////////////////////////////////////////

abstract class ImmutableCollection<C> {
  bool equals(C other);

  bool same(C other);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// While `identical(collection1, collection2)` will compare the identity of the collection
/// itself, `same(collection1, collection2)` will compare its internal state by identity.
/// Note `same` is practically as fast as `identical`, but will give less false negatives.
/// So it is almost always recommended to use `same` instead of `identical`.
///
bool sameCollection<C extends ImmutableCollection>(C c1, C c2) {
  if (c1 == null && c2 == null) return true;
  if (c1 == null || c2 == null) return false;
  return c1.same(c2);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// Global configuration that specifies if, by default, the immutable
/// collections use equality or identity for their [operator ==].
/// It should be defined only once during program instantiation.
/// By default [isDeepEquals]==true (collections are compared by equality).
///
set setDefaultIsDeepEquals(bool isDeepEquals) {
  if (_defaultIsDeepEquals) throw StateError("Can't change defaultIsDeepEquals more than once.");
  _defaultIsDeepEquals = isDeepEquals;
}

bool _defaultIsDeepEquals;

bool get defaultIsDeepEquals => _defaultIsDeepEquals ?? true;

// /////////////////////////////////////////////////////////////////////////////////////////////////

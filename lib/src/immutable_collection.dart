// /////////////////////////////////////////////////////////////////////////////////////////////////

abstract class ImmutableCollection<C> {
  bool same(C other) => identical(this, other);

  bool equals(C other);
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

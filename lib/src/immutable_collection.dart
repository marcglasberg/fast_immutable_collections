abstract class ImmutableCollection<C> {
  bool same(C other) => identical(this, other);

  bool equals(C other);
}

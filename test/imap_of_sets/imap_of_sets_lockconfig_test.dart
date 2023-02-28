// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("lockConfig", () {
    ImmutableCollection.lockConfig();
    expect(() => IMapOfSets.defaultConfig = ConfigMapOfSets(isDeepEquals: false), throwsStateError);
  });

  /////////////////////////////////////////////////////////////////////////////
}

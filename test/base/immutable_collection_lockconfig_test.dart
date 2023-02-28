// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("lockConfig", () {
    ImmutableCollection.lockConfig();
    expect(
        () => ImmutableCollection.disallowUnsafeConstructors =
            !ImmutableCollection.disallowUnsafeConstructors,
        throwsStateError);
    expect(() => ImmutableCollection.autoFlush = !ImmutableCollection.autoFlush, throwsStateError);
    expect(
        () => ImmutableCollection.prettyPrint = !ImmutableCollection.prettyPrint, throwsStateError);
    expect(() => ImmutableCollection.resetAllConfigurations(), throwsStateError);
  });

  /////////////////////////////////////////////////////////////////////////////
}

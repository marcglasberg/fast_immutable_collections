import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("lockConfig", () {
    ImmutableCollection.lockConfig();

    expect(() => IList.flushFactor = 1000, throwsStateError);
    expect(() => IList.asyncAutoflush = false, throwsStateError);
    expect(() => IList.resetAllConfigurations(), throwsStateError);
    expect(() => IList.defaultConfig = ConfigList(cacheHashCode: false), throwsStateError);
  });

  /////////////////////////////////////////////////////////////////////////////
}

import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("lockConfig", () {
    ImmutableCollection.lockConfig();

    expect(() => ISet.flushFactor = 1000, throwsStateError);
    expect(() => ISet.resetAllConfigurations(), throwsStateError);
    expect(() => ISet.defaultConfig = ConfigSet(cacheHashCode: false), throwsStateError);
  });

  /////////////////////////////////////////////////////////////////////////////
}

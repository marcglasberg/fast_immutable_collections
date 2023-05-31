// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("lockConfig", () {
    ImmutableCollection.lockConfig();

    expect(() => IMap.flushFactor = 1000, throwsStateError);
    expect(() => IMap.resetAllConfigurations(), throwsStateError);
    expect(() => IMap.defaultConfig = ConfigMap(cacheHashCode: false), throwsStateError);
  });
}

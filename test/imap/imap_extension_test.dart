import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("lock", () {
    // 1) Typical example
    IMap<String, int> imap = {"a": 1, "b": 2}.lock;
    expect(imap, isA<IMap<String, int>>());
    expect(imap.unlock, {"a": 1, "b": 2});
    expect(imap["a"], 1);
    expect(imap["b"], 2);

    // 2) Other Checks
    imap = {"a": 1}.lock;
    expect(imap, isA<IMap<String, int>>());
    expect(imap.isEmpty, isFalse);
    expect(imap.isNotEmpty, isTrue);

    imap = {null: 1}.lock;
    expect(imap, isA<IMap<String, int>>());
    expect(imap.isEmpty, isFalse);
    expect(imap.isNotEmpty, isTrue);

    imap = {"a": null}.lock;
    expect(imap, isA<IMap<String, int>>());
    expect(imap.isEmpty, isFalse);
    expect(imap.isNotEmpty, isTrue);

    imap = {null: null}.lock;
    expect(imap, isA<IMap<String, int>>());
    expect(imap.isEmpty, isFalse);
    expect(imap.isNotEmpty, isTrue);

    imap = <String, int>{}.lock;
    expect(imap, isA<IMap<String, int>>());
  });

  test("lockUnsafe", () {
    final Map<String, int> map = {"a": 1, "b": 2};
    final IMap<String, int> imap = map.lockUnsafe;

    expect(map, imap.unlock);

    map["c"] = 3;
    map["a"] = 10;

    expect(map, imap.unlock);
  });
}

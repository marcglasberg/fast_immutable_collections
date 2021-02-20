import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

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

    IMap<String?, int> imapKeyNullable = {null: 1}.lock;
    expect(imapKeyNullable, isA<IMap<String?, int>>());
    expect(imapKeyNullable.isEmpty, isFalse);
    expect(imapKeyNullable.isNotEmpty, isTrue);

    IMap<String, int?> imapValueNullable = {"a": null}.lock;
    expect(imapValueNullable, isA<IMap<String, int>>());
    expect(imapValueNullable.isEmpty, isFalse);
    expect(imapValueNullable.isNotEmpty, isTrue);

    IMap<String?, int?> imapKeyValueNullable = {null: null}.lock;
    expect(imapKeyValueNullable, isA<IMap<String, int>>());
    expect(imapKeyValueNullable.isEmpty, isFalse);
    expect(imapKeyValueNullable.isNotEmpty, isTrue);

    imap = <String, int>{}.lock;
    expect(imap, isA<IMap<String, int>>());
  });

  //////////////////////////////////////////////////////////////////////////////

  test("lockUnsafe", () {
    final Map<String, int> map = {"a": 1, "b": 2};
    final IMap<String, int> imap = map.lockUnsafe;

    expect(map, imap.unlock);

    map["c"] = 3;
    map["a"] = 10;

    expect(map, imap.unlock);
  });

  //////////////////////////////////////////////////////////////////////////////
}

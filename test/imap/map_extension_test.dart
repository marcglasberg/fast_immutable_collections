// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
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
    expect(imapValueNullable, isA<IMap<String, int?>>());
    expect(imapValueNullable.isEmpty, isFalse);
    expect(imapValueNullable.isNotEmpty, isTrue);

    IMap<String?, int?> imapKeyValueNullable = {null: null}.lock;
    expect(imapKeyValueNullable, isA<IMap<String?, int?>>());
    expect(imapKeyValueNullable.isEmpty, isFalse);
    expect(imapKeyValueNullable.isNotEmpty, isTrue);

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

  test("toIMap", () {
    final Map<String, int> map = {"a": 1, "b": 2};

    // 1) No config
    expect(map.toIMap(), isA<IMap<String, int>>());
    expect(map.toIMap().unlock, {"a": 1, "b": 2});

    // 2) With config
    expect(map.toIMap(ConfigMap(sort: true)), isA<IMap<String, int>>());
    expect(map.toIMap(ConfigMap(sort: true)).unlock, {"a": 1, "b": 2});
    expect(map.toIMap(ConfigMap(sort: true)).config, ConfigMap(sort: true));
  });

  test("mapTo", () {
    Map<String, int> imap = {"x": 1, "b": 2, "c": 3};
    var imap1 = imap.mapTo<String>((String k, int? v) => "$k:$v");
    expect(imap1, ["x:1", "b:2", "c:3"]);
  });
}

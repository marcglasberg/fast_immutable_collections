// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
// ignore_for_file: non_const_call_to_literal_constructor
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("Runtime Type", () {
    expect(const IMapConst({}), isA<IMapConst>());
    expect(const IMapConst({}), isA<IMapConst>());
    expect(const IMapConst<String, int>({}), isA<IMapConst<String, int>>());
    expect(const IMapConst({'a': 1}), isA<IMapConst<String, int>>());
    expect(const IMapConst<String, int>({}), isA<IMapConst<String, int>>());
  });

  test("isEmpty | isNotEmpty", () {
    expect(const IMapConst({}), isEmpty);
    expect(const IMapConst({}).isEmpty, isTrue);
    expect(const IMapConst({}).isNotEmpty, isFalse);

    expect(const IMapConst<String, int>({}).isEmpty, isTrue);
    expect(const IMapConst<String, int>({}).isNotEmpty, isFalse);

    expect(const IMapConst({'a': 1}), isNotEmpty);
    expect(const IMapConst({'a': 1}).isEmpty, isFalse);
    expect(const IMapConst({'a': 1}).isNotEmpty, isTrue);

    expect(const IMapConst<String, int>({}), isEmpty);
    expect(const IMapConst<String, int>({}).isEmpty, isTrue);
    expect(const IMapConst<String, int>({}).isNotEmpty, isFalse);
  });

  test("hashCode", () {
    expect(const IMapConst({}) == const IMapConst({}), isTrue);
    expect(IMap() == IMap(), isTrue);
    expect(const IMapConst({}) == IMap(), isTrue);
    expect(const IMapConst({}) == IMap({}), isTrue);
    expect(IMap() == const IMapConst({}), isTrue);
    expect(IMap({}) == const IMapConst({}), isTrue);

    expect(const IMapConst({'a': 1, 'b': 2}) == const IMapConst({'a': 1, 'b': 2}), isTrue);
    expect(IMap({'a': 1, 'b': 2}) == IMap({'a': 1, 'b': 2}), isTrue);
    expect(const IMapConst({'a': 1, 'b': 2}) == IMap({'a': 1, 'b': 2}), isTrue);
    expect(IMap({'a': 1, 'b': 2}) == const IMapConst({'a': 1, 'b': 2}), isTrue);

    var a = IMap<String, int>(<String, int>{});
    var b = const IMapConst<String, int>(<String, int>{});
    expect(a, b);
    expect(a.hashCode, b.hashCode);

    var x = IMap({'a': 1, 'b': 2, 'c': 3});
    var y = IMap({'a': 1, 'b': 2}).add('c', 3);
    expect(x, y);
    expect(x.hashCode, y.hashCode);
  });

  test("withConfig", () {
    // 1) Regular usage
    const IMap<String, int> imap = IMapConst({'a': 1, 'b': 2});

    expect(imap.isDeepEquals, isTrue);

    IMap<String, int> iMapNewConfig = imap.withConfig(imap.config.copyWith());

    IMap<String, int> iMapNewConfigIdentity =
        imap.withConfig(imap.config.copyWith(isDeepEquals: false));

    expect(iMapNewConfig.isDeepEquals, isTrue);
    expect(iMapNewConfigIdentity.isDeepEquals, isFalse);

    // 2) With empty map and different configs.
    const Map<String, int> emptyMap = <String, int>{};
    expect(const IMapConst(emptyMap, ConfigMap()), <String, int>{}.lock);
    expect(const IMapConst(emptyMap, ConfigMap(cacheHashCode: false)),
        <String, int>{}.lock.withConfig(ConfigMap(cacheHashCode: false)));
    expect(const IMapConst(emptyMap, ConfigMap(cacheHashCode: false)), isNot(<String, int>{}.lock));

    // 3) With non-empty map and different configs.
    const Map<String, int> nonemptyMap = <String, int>{'a': 1, 'b': 2, 'c': 3};
    expect(const IMapConst(nonemptyMap, ConfigMap()), <String, int>{'a': 1, 'b': 2, 'c': 3}.lock);
    expect(const IMapConst(nonemptyMap, ConfigMap(cacheHashCode: false)),
        <String, int>{'a': 1, 'b': 2, 'c': 3}.lock.withConfig(ConfigMap(cacheHashCode: false)));
    expect(const IMapConst(nonemptyMap, ConfigMap(cacheHashCode: false)),
        isNot(<String, int>{'a': 1, 'b': 2, 'c': 3}.lock));
  });

  test("unlock", () {
    const imapConst = IMapConst({'a': 1, 'b': 2, 'c': 3});
    expect(imapConst.unlock, {'a': 1, 'b': 2, 'c': 3});

    Map map = imapConst.unlock;
    expect(map, isA<Map>());
    map['d'] = 4;
    expect(map, {'a': 1, 'b': 2, 'c': 3, 'd': 4});

    expect(imapConst.unlockLazy, {'a': 1, 'b': 2, 'c': 3});
    map = imapConst.unlockLazy;
    expect(map, isA<Map>());
    map['d'] = 4;
    expect(map, {'a': 1, 'b': 2, 'c': 3, 'd': 4});

    expect(imapConst.unlockView, {'a': 1, 'b': 2, 'c': 3});
    expect(() => imapConst.unlockView['d'] = 4, throwsUnsupportedError);
  });

  test("flush", () {
    const imapConst = IMapConst({'a': 1, 'b': 2, 'c': 3});
    expect(imapConst.isFlushed, isTrue);
    imapConst.flush;
    expect(imapConst.isFlushed, isTrue);
    expect(imapConst.unlock, {'a': 1, 'b': 2, 'c': 3});
  });

  test("add/addAll, remove/removeAll", () {
    const imapConst = IMapConst({'a': 1, 'b': 2, 'c': 3});
    expect(imapConst.add('d', 4), {'a': 1, 'b': 2, 'c': 3, 'd': 4}.lock);
    expect(imapConst.addAll({'d': 4, 'e': 5, 'f': 6}.lock),
        {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5, 'f': 6}.lock);
    expect(imapConst.remove('b'), {'a': 1, 'c': 3}.lock);
  });

  test("IMapConst", () {
    //
    // The default constructor will always use the same const {} internals.
    expect(const IMapConst({}).same(const IMapConst({})), isTrue);
    expect(const IMapConst({}).same(IMapConst({})), isFalse);
    expect(const IMapConst({}).same(const IMapConst({})), isTrue);
    expect(IMapConst({}).same(IMapConst({})), isFalse);

    // ---

    // Both IMapConst are const. So they are the same.
    expect(const IMapConst({}).same(const IMapConst({})), isTrue);

    // One of the IMapConst is const, the other is not. So they are NOT the same.
    expect(const IMapConst({}).same(IMapConst({})), isFalse);
    expect(IMapConst({}).same(const IMapConst({})), isFalse);

    // None of the IMapConst are const. So they are NOT the same.
    expect(IMapConst({}).same(IMapConst({})), isFalse);

    // ---

    // Both IMapConst are const. So they are the same.
    expect(
        const IMapConst({'a': 1, 'b': 2, 'c': 3}).same(const IMapConst({'a': 1, 'b': 2, 'c': 3})),
        isTrue);

    // One of the IMapConst is const, the other is not. So they are NOT the same.
    expect(const IMapConst({'a': 1, 'b': 2, 'c': 3}).same(IMapConst({'a': 1, 'b': 2, 'c': 3})),
        isFalse);
    expect(IMapConst({'a': 1, 'b': 2, 'c': 3}).same(const IMapConst({'a': 1, 'b': 2, 'c': 3})),
        isFalse);

    // None of the IMapConst are const. So they are NOT the same.
    expect(IMapConst({'a': 1, 'b': 2, 'c': 3}).same(IMapConst({'a': 1, 'b': 2, 'c': 3})), isFalse);
  });

  test("Interaction between IMap and IMapConst", () {
    //
    // Empty.
    expect(IMapConst({}).same(IMap()), isFalse);
    expect(IMapConst({}).same(IMap()), isFalse);
    expect(IMap().same(IMapConst({})), isFalse);
    expect(IMap().same(IMapConst({})), isFalse);
    expect(IMap().same(IMapConst({})), isFalse);
    expect(IMap().same(IMapConst({})), isFalse);
    expect(const IMapConst({}).same(IMap()), isFalse);
    expect(const IMapConst({}).same(IMap()), isFalse);
    expect(IMap().same(const IMapConst({})), isFalse);
    expect(IMap().same(const IMapConst({})), isFalse);
    expect(IMap().same(const IMapConst({})), isFalse);
    expect(IMap().same(const IMapConst({})), isFalse);

    // Not Empty.
    expect(IMap({'a': 1, 'b': 2}).same(IMapConst({'a': 1, 'b': 2})), isFalse);
    expect(IMapConst({'a': 1, 'b': 2}).same(IMap({'a': 1, 'b': 2})), isFalse);
    expect(IMap({'a': 1, 'b': 2}).same(const IMapConst({'a': 1, 'b': 2})), isFalse);
    expect(const IMapConst({'a': 1, 'b': 2}).same(IMap({'a': 1, 'b': 2})), isFalse);

    // equalItems
    expect(IMap({}).equalItems(IMapConst({}).entries), isTrue);
    expect(IMap({}).equalItems(const IMapConst({}).entries), isTrue);
    expect(IMap().equalItems(const IMapConst({}).entries), isTrue);
    expect(IMap().equalItems(IMapConst({}).entries), isTrue);
    expect(IMap({'a': 1, 'b': 2}).equalItems(IMapConst({'a': 1, 'b': 2}).entries), isTrue);
    expect(IMapConst({'a': 1, 'b': 2}).equalItems(IMap({'a': 1, 'b': 2}).entries), isTrue);
    expect(IMap({'a': 1, 'b': 2}).equalItems(const IMapConst({'a': 1, 'b': 2}).entries), isTrue);
    expect(const IMapConst({'a': 1, 'b': 2}).equalItems(IMap({'a': 1, 'b': 2}).entries), isTrue);

    // equalItemsAndConfig
    expect(IMap({}).equalItemsAndConfig(IMapConst({})), isTrue);
    expect(IMap({}).equalItemsAndConfig(const IMapConst({})), isTrue);
    expect(IMap().equalItemsAndConfig(const IMapConst({})), isTrue);
    expect(IMap().equalItemsAndConfig(IMapConst({})), isTrue);
    expect(IMap({'a': 1, 'b': 2}).equalItemsAndConfig(IMapConst({'a': 1, 'b': 2})), isTrue);
    expect(IMapConst({'a': 1, 'b': 2}).equalItemsAndConfig(IMap({'a': 1, 'b': 2})), isTrue);
    expect(IMap({'a': 1, 'b': 2}).equalItemsAndConfig(const IMapConst({'a': 1, 'b': 2})), isTrue);
    expect(const IMapConst({'a': 1, 'b': 2}).equalItemsAndConfig(IMap({'a': 1, 'b': 2})), isTrue);
  });

  test("Make sure the internal map is Map<String, int>, and not Map<Never>", () {
    var l1 = const IMapConst<String, int>({});
    expect(l1.runtimeType.toString(), 'IMapConst<String, int>');

    var l2 = IMap<String, int>({'a': 1, 'b': 2, 'c': 3});
    expect(l2.runtimeType.toString(), 'IMapImpl<String, int>');

    var l3 = l1.addAll(l2);
    expect(l3.runtimeType.toString(), 'IMapImpl<String, int>');

    var result = l3.where((String key, int value) => value == 2);
    expect(result, {'b': 2}.lock);
  });
}

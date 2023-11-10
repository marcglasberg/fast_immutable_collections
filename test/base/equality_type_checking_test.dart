// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  ImmutableCollection.autoFlush = false;

  Subtype obj1 = Subtype("1");
  Subtype obj2 = Subtype("2");
  Subtype obj3 = Subtype("3");

  test("IList deep equality ignores type parameter.", () {
    //
    IList<Supertype> ilist1 = IList(<Subtype>[obj1, obj2, obj3]);
    IList<Supertype> ilist2 = [obj1, obj2, obj3].lock;

    expect(ilist1.runtimeType.toString(), "IListImpl<Supertype>");
    expect(ilist2.runtimeType.toString(), "IListImpl<Subtype>");

    expect(ilist1 == ilist1, isTrue);
    expect(ilist1 == ilist2, isTrue);
    expect(ilist2 == ilist1, isTrue);

    expect(ilist1.equalItems(ilist1), isTrue);
    expect(ilist1.equalItems(ilist2), isTrue);
    expect(ilist2.equalItems(ilist1), isTrue);

    expect(ilist1.equalItemsAndConfig(ilist1), isTrue);
    expect(ilist1.equalItemsAndConfig(ilist2), isTrue);
    expect(ilist2.equalItemsAndConfig(ilist1), isTrue);

    expect(ilist1.unorderedEqualItems(ilist1), isTrue);
    expect(ilist1.unorderedEqualItems(ilist2), isTrue);
    expect(ilist2.unorderedEqualItems(ilist1), isTrue);
  });

  test("ISet deep equality ignores type parameter.", () {
    //
    ISet<Supertype> iset1 = ISet(<Subtype>[obj1, obj2, obj3]);
    ISet<Supertype> iset2 = {obj1, obj2, obj3}.lock;

    expect(iset1.runtimeType.toString(), "ISetImpl<Supertype>");
    expect(iset2.runtimeType.toString(), "ISetImpl<Subtype>");

    expect(iset1 == iset2, isTrue);
    expect(iset2 == iset1, isTrue);

    expect(iset1.equalItems(iset1), isTrue);
    expect(iset1.equalItems(iset2), isTrue);
    expect(iset2.equalItems(iset1), isTrue);

    expect(iset1.equalItemsAndConfig(iset1), isTrue);
    expect(iset1.equalItemsAndConfig(iset2), isTrue);
    expect(iset2.equalItemsAndConfig(iset1), isTrue);

    expect(iset1.unorderedEqualItems(iset1), isTrue);
    expect(iset1.unorderedEqualItems(iset2), isTrue);
    expect(iset2.unorderedEqualItems(iset1), isTrue);
  });

  test("IMap deep equality ignores type parameter of keys", () {
    //
    IMap<Supertype, String> imap1 = IMap(<Subtype, String>{obj1: "a", obj2: "a", obj3: "a"});
    IMap<Supertype, String> imap2 = {obj1: "a", obj2: "a", obj3: "a"}.lock;

    expect(imap1.runtimeType.toString(), "IMapImpl<Supertype, String>");
    expect(imap2.runtimeType.toString(), "IMapImpl<Subtype, String>");

    expect(imap1 == imap2, isTrue);
    expect(imap2 == imap1, isTrue);

    expect(imap1.equalItems(imap1.entries), isTrue);
    expect(imap1.equalItems(imap2.entries), isTrue);
    expect(imap2.equalItems(imap1.entries), isTrue);

    expect(imap1.equalItemsToIMap(imap1), isTrue);
    expect(imap1.equalItemsToIMap(imap2), isTrue);
    expect(imap2.equalItemsToIMap(imap1), isTrue);

    expect(imap1.equalItemsAndConfig(imap1), isTrue);
    expect(imap1.equalItemsAndConfig(imap2), isTrue);
    expect(imap2.equalItemsAndConfig(imap1), isTrue);
  });

  test("IMap deep equality ignores type parameter of values", () {
    //
    IMap<String, Supertype> imap1 = IMap(<String, Subtype>{"a": obj1, "b": obj2, "c": obj3});
    IMap<String, Supertype> imap2 = {"a": obj1, "b": obj2, "c": obj3}.lock;

    expect(imap1.runtimeType.toString(), "IMapImpl<String, Supertype>");
    expect(imap2.runtimeType.toString(), "IMapImpl<String, Subtype>");

    expect(imap1 == imap2, isTrue);
    expect(imap2 == imap1, isTrue);

    expect(imap1.equalItems(imap1.entries), isTrue);
    expect(imap1.equalItems(imap2.entries), isTrue);
    expect(imap2.equalItems(imap1.entries), isTrue);

    expect(imap1.equalItemsToIMap(imap1), isTrue);
    expect(imap1.equalItemsToIMap(imap2), isTrue);
    expect(imap2.equalItemsToIMap(imap1), isTrue);

    expect(imap1.equalItemsAndConfig(imap1), isTrue);
    expect(imap1.equalItemsAndConfig(imap2), isTrue);
    expect(imap2.equalItemsAndConfig(imap1), isTrue);
  });

  test("IMapOfSets deep equality ignores type parameter of keys", () {
    //
    IMapOfSets<Supertype, String> imapOfSets1 = IMapOfSets(<Subtype, Set<String>>{
      obj1: {"a"},
      obj2: {"b"},
      obj3: {"c"},
    });
    IMapOfSets<Supertype, String> imapOfSets2 = {
      obj1: {"a"},
      obj2: {"b"},
      obj3: {"c"},
    }.lock;

    expect(imapOfSets1.runtimeType.toString(), "IMapOfSets<Supertype, String>");
    expect(imapOfSets2.runtimeType.toString(), "IMapOfSets<Subtype, String>");

    expect(imapOfSets1 == imapOfSets2, isTrue);
    expect(imapOfSets2 == imapOfSets1, isTrue);

    expect(imapOfSets1.equalItems(imapOfSets1.entries), isTrue);
    expect(imapOfSets1.equalItems(imapOfSets2.entries), isTrue);
    expect(imapOfSets2.equalItems(imapOfSets1.entries), isTrue);

    expect(imapOfSets1.equalItemsToIMapOfSets(imapOfSets1), isTrue);
    expect(imapOfSets1.equalItemsToIMapOfSets(imapOfSets2), isTrue);
    expect(imapOfSets2.equalItemsToIMapOfSets(imapOfSets1), isTrue);

    expect(imapOfSets1.equalItemsAndConfig(imapOfSets1), isTrue);
    expect(imapOfSets1.equalItemsAndConfig(imapOfSets2), isTrue);
    expect(imapOfSets2.equalItemsAndConfig(imapOfSets1), isTrue);
  });

  test("IMapOfSets deep equality ignores type parameter of values", () {
    //
    IMapOfSets<String, Supertype> imapOfSets1 = IMapOfSets(<String, Set<Subtype>>{
      "a": {obj1},
      "b": {obj2},
      "c": {obj3}
    });
    IMapOfSets<String, Supertype> imapOfSets2 = {
      "a": {obj1},
      "b": {obj2},
      "c": {obj3}
    }.lock;

    expect(imapOfSets1 == imapOfSets2, isTrue);
    expect(imapOfSets2 == imapOfSets1, isTrue);

    expect(imapOfSets1.equalItems(imapOfSets1.entries), isTrue);
    expect(imapOfSets1.equalItems(imapOfSets2.entries), isTrue);
    expect(imapOfSets2.equalItems(imapOfSets1.entries), isTrue);

    expect(imapOfSets1.equalItemsToIMapOfSets(imapOfSets1), isTrue);
    expect(imapOfSets1.equalItemsToIMapOfSets(imapOfSets2), isTrue);
    expect(imapOfSets2.equalItemsToIMapOfSets(imapOfSets1), isTrue);

    expect(imapOfSets1.equalItemsAndConfig(imapOfSets1), isTrue);
    expect(imapOfSets1.equalItemsAndConfig(imapOfSets2), isTrue);
    expect(imapOfSets2.equalItemsAndConfig(imapOfSets1), isTrue);
  });
}

class Supertype {
  String nome;

  Supertype(this.nome);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Supertype && runtimeType == other.runtimeType && nome == other.nome;

  @override
  int get hashCode => nome.hashCode;
}

class Subtype extends Supertype {
  Subtype(super.nome);
}

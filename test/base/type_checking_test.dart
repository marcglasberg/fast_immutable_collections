import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:flutter_test/flutter_test.dart";

//////////////////////////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////////////////////////////

class Subtype extends Supertype {
  Subtype(String nome) : super(nome);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  ImmutableCollection.autoFlush = false;

  Subtype obj1 = Subtype("1");
  Subtype obj2 = Subtype("2");
  Subtype obj3 = Subtype("3");

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IList runtimeType not working", () {
    //
    IList<Supertype> ilist1 = IList(<Subtype>[obj1, obj2, obj3]);
    IList<Supertype> ilist2 = [obj1, obj2, obj3].lock;

    print("ilist1.runtimeType = ${ilist1.runtimeType}\n\n");
    print("ilist1.runtimeType = ${IList([obj1, obj2, obj3]).runtimeType}\n\n");

    expect(ilist1.runtimeType.toString(), "IList<Supertype>");
    expect(ilist2.runtimeType.toString(), "IList<Subtype>");

    expect(ilist2 == ilist1, isTrue);
    expect(ilist1 == ilist2, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("ISet runtimeType not working", () {
    //
    ISet<Supertype> iset1 = ISet(<Subtype>[obj1, obj2, obj3]);
    ISet<Supertype> iset2 = {obj1, obj2, obj3}.lock;

    print("iset1.runtimeType = ${iset1.runtimeType}\n\n");
    print("iset1.runtimeType = ${ISet([obj1, obj2, obj3]).runtimeType}\n\n");

    expect(iset1.runtimeType.toString(), "ISet<Supertype>");
    expect(iset2.runtimeType.toString(), "ISet<Subtype>");

    expect(iset2 == iset1, isTrue);
    expect(iset1 == iset2, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IMap runtimeType not working | keys", () {
    //
    IMap<Supertype, String> imap1 = IMap(<Subtype, String>{obj1: "a", obj2: "a", obj3: "a"});
    IMap<Supertype, String> imap2 = {obj1: "a", obj2: "a", obj3: "a"}.lock;

    print("imap1.runtimeType = ${imap1.runtimeType}\n\n");
    print("imap1.runtimeType = ${IMap({obj1: "a", obj2: "a", obj3: "a"}).runtimeType}\n\n");

    expect(imap1.runtimeType.toString(), "IMap<Supertype, String>");
    expect(imap2.runtimeType.toString(), "IMap<Subtype, String>");

    expect(imap2 == imap1, isTrue);
    expect(imap1 == imap2, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IMap runtimeType not working | values", () {
    //
    IMap<String, Supertype> imap1 = IMap(<String, Subtype>{"a": obj1, "b": obj2, "c": obj3});
    IMap<String, Supertype> imap2 = {"a": obj1, "b": obj2, "c": obj3}.lock;

    print("imap1.runtimeType = ${imap1.runtimeType}\n\n");
    print("imap1.runtimeType = ${IMap({"a": obj1, "b": obj2, "c": obj3}).runtimeType}\n\n");

    expect(imap1.runtimeType.toString(), "IMap<String, Supertype>");
    expect(imap2.runtimeType.toString(), "IMap<String, Subtype>");

    expect(imap2 == imap1, isTrue);
    expect(imap1 == imap2, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets runtimeType not working | keys", () {
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

    print("imapOfSets1.runtimeType = ${imapOfSets1.runtimeType}\n\n");
    print("imapOfSets1.runtimeType = ${IMapOfSets({
      obj1: {"a"},
      obj2: {"b"},
      obj3: {"c"},
    }).runtimeType}\n\n");

    expect(imapOfSets1.runtimeType.toString(), "IMapOfSets<Supertype, String>");
    expect(imapOfSets2.runtimeType.toString(), "IMapOfSets<Subtype, String>");

    expect(imapOfSets2 == imapOfSets1, isTrue);
    expect(imapOfSets1 == imapOfSets2, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IMapOfSets runtimeType not working | values", () {
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

    print("imapOfSets1.runtimeType = ${imapOfSets1.runtimeType}\n\n");
    print("imapOfSets1.runtimeType = ${IMapOfSets({
      "a": {obj1},
      "b": {obj2},
      "c": {obj3}
    }).runtimeType}\n\n");

    expect(imapOfSets1.runtimeType.toString(), "IMapOfSets<String, Supertype>");
    expect(imapOfSets2.runtimeType.toString(), "IMapOfSets<String, Subtype>");

    expect(imapOfSets2 == imapOfSets1, isTrue);
    expect(imapOfSets1 == imapOfSets2, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}

//////////////////////////////////////////////////////////////////////////////////////////////////

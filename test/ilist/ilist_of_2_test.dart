// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("Simple Initialization", () {
    const IListOf2 iListOf2 = IListOf2(2, 1);

    expect(iListOf2.first, 2);
    expect(iListOf2.last, 1);
  });

  test("toString", () {
    const IListOf2 iListOf2 = IListOf2(2, 1);

    expect(iListOf2.toString(), "[2, 1]");
  });

  test("==", () {
    final IListOf2<int> iListOf2 = IListOf2(2, 1);

    expect(iListOf2 == iListOf2, isTrue);
    expect(iListOf2 == IListOf2<int>(2, 1), isTrue);
    expect(iListOf2 == IListOf2<int>(1, 2), isFalse);
  });

  test("hashCode", () {
    expect(IListOf2(2, 1) == IListOf2(2, 1), isTrue);
    expect(IListOf2(2, 1).hashCode, IListOf2(2, 1).hashCode);

    expect(IListOf2(1, 2) == IListOf2(2, 1), isFalse);
    expect(IListOf2(1, 2).hashCode, isNot(IListOf2(2, 1).hashCode));
  });
}

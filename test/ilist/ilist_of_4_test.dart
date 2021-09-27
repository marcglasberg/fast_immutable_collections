import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("Simple Initialization", () {
    const IListOf4 iListOf4 = IListOf4(2, 1, 3, 4);

    expect(iListOf4.first, 2);
    expect(iListOf4.second, 1);
    expect(iListOf4.third, 3);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toString", () {
    const IListOf4 iListOf4 = IListOf4(2, 1, 3, 4);

    expect(iListOf4.toString(), "[2, 1, 3, 4]");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("==", () {
    final IListOf4<int> iListOf4 = IListOf4(2, 1, 3, 4);

    expect(iListOf4 == iListOf4, isTrue);
    expect(iListOf4 == IListOf4<int>(2, 1, 3, 4), isTrue);
    expect(iListOf4 == IListOf4<int>(1, 2, 3, 4), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("hashCode", () {
    expect(IListOf4(2, 1, 3, 4) == IListOf4(2, 1, 3, 4), isTrue);
    expect(IListOf4(2, 1, 3, 4).hashCode, IListOf4(2, 1, 3, 4).hashCode);

    expect(IListOf4(1, 2, 3, 4) == IListOf4(2, 1, 3, 4), isFalse);
    expect(IListOf4(1, 2, 3, 4).hashCode, isNot(IListOf4(2, 1, 3, 4).hashCode));
  });

  /////////////////////////////////////////////////////////////////////////////
}

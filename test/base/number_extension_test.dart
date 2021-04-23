import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("isInRange/isNotInRange", () {
    //
    expect((-10).isInRange(5, 10), isFalse);
    expect(0.isInRange(5, 10), isFalse);
    expect(4.isInRange(5, 10), isFalse);
    expect(5.isInRange(5, 10), isTrue);
    expect(6.isInRange(5, 10), isTrue);
    expect(9.isInRange(5, 10), isTrue);
    expect(10.isInRange(5, 10), isTrue);
    expect(11.isInRange(5, 10), isFalse);
    expect(100.isInRange(5, 10), isFalse);

    expect((-10).isNotInRange(5, 10), isTrue);
    expect(0.isNotInRange(5, 10), isTrue);
    expect(4.isNotInRange(5, 10), isTrue);
    expect(5.isNotInRange(5, 10), isFalse);
    expect(6.isNotInRange(5, 10), isFalse);
    expect(9.isNotInRange(5, 10), isFalse);
    expect(10.isNotInRange(5, 10), isFalse);
    expect(11.isNotInRange(5, 10), isTrue);
    expect(100.isNotInRange(5, 10), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("inRange", () {
    //
    // 1) FicNumberExtension

    expect((-10).inRange(5, 10), 5);
    expect(0.inRange(5, 10), 5);
    expect(4.inRange(5, 10), 5);
    expect(5.inRange(5, 10), 5);
    expect(6.inRange(5, 10), 6);
    expect(9.inRange(5, 10), 9);
    expect(10.inRange(5, 10), 10);
    expect(11.inRange(5, 10), 10);
    expect(100.inRange(5, 10), 10);

    // 2) FicNumberExtensionNullable

    int? valueNullable;
    expect(valueNullable.inRange(5, 10, orElse: 100), 100);

    valueNullable = 0;
    expect(valueNullable.inRange(5, 10), 5);

    valueNullable = 4;
    expect(valueNullable.inRange(5, 10), 5);

    valueNullable = 5;
    expect(valueNullable.inRange(5, 10), 5);

    valueNullable = 6;
    expect(valueNullable.inRange(5, 10), 6);

    valueNullable = 9;
    expect(valueNullable.inRange(5, 10), 9);

    valueNullable = 10;
    expect(valueNullable.inRange(5, 10), 10);

    valueNullable = 11;
    expect(valueNullable.inRange(5, 10), 10);

    valueNullable = 100;
    expect(valueNullable.inRange(5, 10), 10);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("isNullOrZero", () {
    //
    expect((-10).isNullOrZero, isFalse);
    expect((-1).isNullOrZero, isFalse);
    expect(0.isNullOrZero, isTrue);
    expect(1.isNullOrZero, isFalse);
    expect(10.isNullOrZero, isFalse);

    int? value;
    expect(value.isNullOrZero, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("isNotNullNotZero", () {
    //
    expect((-10).isNotNullNotZero, isTrue);
    expect((-1).isNotNullNotZero, isTrue);
    expect(0.isNotNullNotZero, isFalse);
    expect(1.isNotNullNotZero, isTrue);
    expect(10.isNotNullNotZero, isTrue);

    int? value;
    expect(value.isNotNullNotZero, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////
}

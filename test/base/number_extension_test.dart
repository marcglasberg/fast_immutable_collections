import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  //////////////////////////////////////////////////////////////////////////////

  test("isNullOrZero", () {
    //
    expect((-10).isNullOrZero, false);
    expect((-1).isNullOrZero, false);
    expect(0.isNullOrZero, true);
    expect(1.isNullOrZero, false);
    expect(10.isNullOrZero, false);

    int? value;
    expect(value.isNullOrZero, true);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("isInRange/isNotInRange", () {
    //
    expect((-10).isInRange(5, 10), false);
    expect(0.isInRange(5, 10), false);
    expect(4.isInRange(5, 10), false);
    expect(5.isInRange(5, 10), true);
    expect(6.isInRange(5, 10), true);
    expect(9.isInRange(5, 10), true);
    expect(10.isInRange(5, 10), true);
    expect(11.isInRange(5, 10), false);
    expect(100.isInRange(5, 10), false);

    expect((-10).isNotInRange(5, 10), true);
    expect(0.isNotInRange(5, 10), true);
    expect(4.isNotInRange(5, 10), true);
    expect(5.isNotInRange(5, 10), false);
    expect(6.isNotInRange(5, 10), false);
    expect(9.isNotInRange(5, 10), false);
    expect(10.isNotInRange(5, 10), false);
    expect(11.isNotInRange(5, 10), true);
    expect(100.isNotInRange(5, 10), true);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("inRange", () {
    //
    expect((-10).inRange(5, 10), 5);
    expect(0.inRange(5, 10), 5);
    expect(4.inRange(5, 10), 5);
    expect(5.inRange(5, 10), 5);
    expect(6.inRange(5, 10), 6);
    expect(9.inRange(5, 10), 9);
    expect(10.inRange(5, 10), 10);
    expect(11.inRange(5, 10), 10);
    expect(100.inRange(5, 10), 10);

    int? value;
    expect(value.inRange(5, 10), null);

    value = 0;
    expect(value.inRange(5, 10), 5);

    value = 4;
    expect(value.inRange(5, 10), 5);

    value = 5;
    expect(value.inRange(5, 10), 5);

    value = 6;
    expect(value.inRange(5, 10), 6);

    value = 9;
    expect(value.inRange(5, 10), 9);

    value = 10;
    expect(value.inRange(5, 10), 10);

    value = 11;
    expect(value.inRange(5, 10), 10);

    value = 100;
    expect(value.inRange(5, 10), 10);
  });

  //////////////////////////////////////////////////////////////////////////////
}

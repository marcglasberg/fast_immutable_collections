// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
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

    int value = 0;
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
}

import 'package:fast_immutable_collections/src/l1.dart';
import 'package:fast_immutable_collections/src/l2.dart';
import 'package:fast_immutable_collections/src/l3.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('L2', () {
    var l2 = L2(L1([1, 2, 3]), 4);

    expect(l2.runtimeType.toString(), "L2<int>");
    expect(l2.isEmpty, isFalse);
    expect(l2.isNotEmpty, isTrue);
    expect(l2.length, 4);

    var iter = l2.iterator;
    expect(iter.current, null);
    expect(iter.moveNext(), true);
    expect(iter.current, 1);
    expect(iter.moveNext(), true);
    expect(iter.current, 2);
    expect(iter.moveNext(), true);
    expect(iter.current, 3);
    expect(iter.moveNext(), true);
    expect(iter.current, 4);
    expect(iter.moveNext(), false);
    expect(iter.current, null);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('L2[index]', () {
    var l2 = L2(L1([1, 2, 3]), 4);

    expect(l2[0], 1);
    expect(l2[1], 2);
    expect(l2[2], 3);
    expect(l2[3], 4);

    expect(() => l2[4], throwsA(isA<RangeError>()));
    expect(() => l2[-1], throwsA(isA<RangeError>()));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}

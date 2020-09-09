import 'package:fast_immutable_collections/src/l1.dart';
import 'package:fast_immutable_collections/src/l2.dart';
import 'package:fast_immutable_collections/src/l3.dart';
import 'package:test/test.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('L3', () {
    var l3 = L3(L1([1, 2]), [3, 4, 5]);

    expect(l3.runtimeType.toString(), 'L3<int>');
    expect(l3.isEmpty, isFalse);
    expect(l3.isNotEmpty, isTrue);
    expect(l3.length, 5);

    var iter = l3.iterator;
    expect(iter.current, null);
    expect(iter.moveNext(), true);
    expect(iter.current, 1);
    expect(iter.moveNext(), true);
    expect(iter.current, 2);
    expect(iter.moveNext(), true);
    expect(iter.current, 3);
    expect(iter.moveNext(), true);
    expect(iter.current, 4);
    expect(iter.moveNext(), true);
    expect(iter.current, 5);
    expect(iter.moveNext(), false);
    expect(iter.current, null);

    expect(l3.unlock, [1, 2, 3, 4, 5]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Combining various L3 and L2', () {
    var l = L3(L3(L3(L2(L3(L1([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);

    expect(l.runtimeType.toString(), 'L3<int>');
    expect(l.isEmpty, isFalse);
    expect(l.isNotEmpty, isTrue);
    expect(l.length, 8);

    var iter = l.iterator;
    expect(iter.current, null);
    expect(iter.moveNext(), true);
    expect(iter.current, 1);
    expect(iter.moveNext(), true);
    expect(iter.current, 2);
    expect(iter.moveNext(), true);
    expect(iter.current, 3);
    expect(iter.moveNext(), true);
    expect(iter.current, 4);
    expect(iter.moveNext(), true);
    expect(iter.current, 5);
    expect(iter.moveNext(), true);
    expect(iter.current, 6);
    expect(iter.moveNext(), true);
    expect(iter.current, 7);
    expect(iter.moveNext(), true);
    expect(iter.current, 8);
    expect(iter.moveNext(), false);
    expect(iter.current, null);

    expect(l.unlock, [1, 2, 3, 4, 5, 6, 7, 8]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('L3[index]', () {
    var l3 = L3(L1([1, 2, 3]), [4, 5, 6, 7]);

    expect(l3[0], 1);
    expect(l3[1], 2);
    expect(l3[2], 3);
    expect(l3[3], 4);
    expect(l3[4], 5);
    expect(l3[5], 6);
    expect(l3[6], 7);

    expect(() => l3[7], throwsA(isA<RangeError>()));
    expect(() => l3[-1], throwsA(isA<RangeError>()));
  });
}

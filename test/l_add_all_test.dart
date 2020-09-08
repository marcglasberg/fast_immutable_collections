import 'package:fast_immutable_collections/src/l_flat.dart';
import 'package:fast_immutable_collections/src/l_add.dart';
import 'package:fast_immutable_collections/src/l_add_all.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('LAddAll', () {
    var l = LAddAll(LFlat([1, 2]), [3, 4, 5]);

    expect(l.runtimeType.toString(), "LAddAll<int>");
    expect(l.isEmpty, isFalse);
    expect(l.isNotEmpty, isTrue);
    expect(l.length, 5);

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
    expect(iter.moveNext(), false);
    expect(iter.current, null);

    expect(l.unlock, [1, 2, 3, 4, 5]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Combining various LAddAll and LAdd', () {
    var l =
        LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);

    expect(l.runtimeType.toString(), "LAddAll<int>");
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

  test('LAddAll[index]', () {
    var l = LAddAll(LFlat([1, 2, 3]), [4, 5, 6, 7]);

    expect(l[0], 1);
    expect(l[1], 2);
    expect(l[2], 3);
    expect(l[3], 4);
    expect(l[4], 5);
    expect(l[5], 6);
    expect(l[6], 7);

    expect(() => l[7], throwsA(isA<RangeError>()));
    expect(() => l[-1], throwsA(isA<RangeError>()));
  });
}

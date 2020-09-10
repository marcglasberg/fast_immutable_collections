import 'package:fast_immutable_collections/src/l_flat.dart';
import 'package:fast_immutable_collections/src/l_add.dart';
import 'package:fast_immutable_collections/src/l_add_all.dart';
import 'package:test/test.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('LAdd', () {
    var l = LAdd(LFlat([1, 2, 3]), 4);

    expect(l.runtimeType.toString(), "LAdd<int>");
    expect(l.isEmpty, isFalse);
    expect(l.isNotEmpty, isTrue);
    expect(l.length, 4);

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
    expect(iter.moveNext(), false);
    expect(iter.current, null);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('LAdd[index]', () {
    var l = LAdd(LFlat([1, 2, 3]), 4);

    expect(l[0], 1);
    expect(l[1], 2);
    expect(l[2], 3);
    expect(l[3], 4);

    expect(() => l[4], throwsA(isA<RangeError>()));
    expect(() => l[-1], throwsA(isA<RangeError>()));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}

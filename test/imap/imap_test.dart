import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/imap/imap.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  group('Creating immutable maps |', () {
    final IMap iMap1 = IMap(), iMap2 = IMap({});
    final iMap3 = IMap<String, int>({});
    final iMap4 = IMap({'a': 1});
    final iMap5 = IMap.empty<String, int>();

    test('Runtime Type', () {
      expect(iMap1, isA<IMap>());
      expect(iMap2, isA<IMap>());
      expect(iMap3, isA<IMap<String, int>>());
      expect(iMap4, isA<IMap<String, int>>());
      expect(iMap5, isA<IMap<String, int>>());
    });

    test('Emptiness Properties', () {
      expect(iMap1.isEmpty, isTrue);
      expect(iMap2.isEmpty, isTrue);
      expect(iMap3.isEmpty, isTrue);
      expect(iMap4.isEmpty, isFalse);
      expect(iMap5.isEmpty, isTrue);

      expect(iMap1.isNotEmpty, isFalse);
      expect(iMap2.isNotEmpty, isFalse);
      expect(iMap3.isNotEmpty, isFalse);
      expect(iMap4.isNotEmpty, isTrue);
      expect(iMap5.isNotEmpty, isFalse);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  // group('Equals |', () {
  //   //
  //
  //   test(
  //       'IMap with identity-equals compares the map instance, '
  //       'not the items.', () {
  //     var myMap = IMap([1, 2]);
  //     expect(myMap == myMap, isTrue);
  //     expect(myMap == IMap([1, 2]), isFalse);
  //     expect(myMap == [1, 2].lock, isFalse);
  //     expect(myMap == IMap([1, 2, 3]), isFalse);
  //
  //     myMap = IMap([1, 2]).identityEquals;
  //     expect(myMap == myMap, isTrue);
  //     expect(myMap == IMap([1, 2]).identityEquals, isFalse);
  //     expect(myMap == IMap([1, 2, 3]).identityEquals, isFalse);
  //   });
  //
  //   test(
  //       'IMap with deep-equals compares the items, '
  //       'not the map instance.', () {
  //     var myMap = IMap([1, 2]).deepEquals;
  //     expect(myMap == myMap, isTrue);
  //     expect(myMap == IMap([1, 2]).deepEquals, isTrue);
  //     expect(myMap == [1, 2].deep, isTrue);
  //     expect(myMap == IMap([1, 2, 3]).deepEquals, isFalse);
  //   });
  //
  //   test(
  //       'IMap with deep-equals is always different '
  //       'from iMap with identity-equals.', () {
  //     expect(IMap([1, 2]).deepEquals == IMap([1, 2]).identityEquals, isFalse);
  //     expect(IMap([1, 2]).identityEquals == IMap([1, 2]).deepEquals, isFalse);
  //     expect(IMap([1, 2]).deepEquals == IMap([1, 2]), isFalse);
  //     expect(IMap([1, 2]) == IMap([1, 2]).deepEquals, isFalse);
  //   });
  // });
  //
  // //////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // group('Creating immutable maps with extensions |', () {
  //   test('From an empty map', () {
  //     final IMap iMap = [].lock;
  //
  //     expect(iMap, isA<IMap>());
  //     expect(iMap.isEmpty, isTrue);
  //     expect(iMap.isNotEmpty, isFalse);
  //   });
  //
  //   test('From a map with one `int` item', () {
  //     final IMap iMap = [1].lock;
  //
  //     expect(iMap, isA<IMap<int>>());
  //     expect(iMap.isEmpty, isFalse);
  //     expect(iMap.isNotEmpty, isTrue);
  //   });
  //
  //   test('From a map with one `null` string', () {
  //     final String text = null;
  //     final IMap<String> typedMap = [text].lock;
  //
  //     expect(typedMap, isA<IMap<String>>());
  //   });
  //
  //   test('From an empty map typed with `String`', () {
  //     final typedMap = <String>[].lock;
  //
  //     expect(typedMap, isA<IMap<String>>());
  //   });
  // });
  //
  // //////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // group('Creating native mutable maps from immutable maps |', () {
  //   final Map<int> map = [1, 2, 3];
  //
  //   test('From the default factory constructor', () {
  //     final IMap<int> imap = IMap(map);
  //
  //     expect(imap.unlock, map);
  //     expect(identical(imap.unlock, map), isFalse);
  //   });
  //
  //   test('From `lock`', () {
  //     final IMap<int> iMap = map.lock;
  //
  //     expect(iMap.unlock, map);
  //     expect(identical(iMap.unlock, map), isFalse);
  //   });
  // });
  //
  // //////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // test('`flush`', () {
  //   final IMap<int> imap = [1, 2, 3].lock.add(4).addAll([5, 6]).add(7).addAll([]).addAll([8, 9]);
  //
  //   expect(imap.isFlushed, isFalse);
  //
  //   imap.flush;
  //
  //   expect(imap.isFlushed, isTrue);
  //   expect(imap.unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  // });
  //
  // //////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // test('`add` and `addAll`', () {
  //   final IMap<int> imap1 = [1, 2, 3].lock;
  //   final IMap<int> imap2 = imap1.add(4);
  //   final IMap<int> imap3 = imap2.addAll([5, 6]);
  //
  //   expect(imap1.unlock, [1, 2, 3]);
  //   expect(imap2.unlock, [1, 2, 3, 4]);
  //   expect(imap3.unlock, [1, 2, 3, 4, 5, 6]);
  //
  //   // Methods are chainable.
  //   expect(imap1.add(10).addAll([20, 30]).unlock, [1, 2, 3, 10, 20, 30]);
  // });
  //
  // //////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // test('`remove`', () {
  //   final IMap<int> imap1 = [1, 2, 3].lock;
  //
  //   final IMap<int> imap2 = imap1.remove(2);
  //   expect(imap2.unlock, [1, 3]);
  //
  //   final IMap<int> imap3 = imap2.remove(5);
  //   expect(imap3.unlock, [1, 3]);
  //
  //   final IMap<int> imap4 = imap3.remove(1);
  //   expect(imap4.unlock, [3]);
  //
  //   final IMap<int> imap5 = imap4.remove(3);
  //   expect(imap5.unlock, []);
  //
  //   final IMap<int> imap6 = imap5.remove(7);
  //   expect(imap6.unlock, []);
  //
  //   expect(identical(imap1, imap2), false);
  // });
  //
  // //////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // group('`maxLength` |', () {
  //   final IMap<int> imap1 = [1, 2, 3, 4, 5].lock;
  //
  //   test('Cutting the map off', () {
  //     final IMap<int> imap2 = imap1.maxLength(2);
  //     expect(imap2.unlock, [1, 2]);
  //
  //     final IMap<int> imap3 = imap1.maxLength(3);
  //     expect(imap3.unlock, [1, 2, 3]);
  //
  //     final IMap<int> imap4 = imap1.maxLength(1);
  //     expect(imap4.unlock, [1]);
  //
  //     final IMap<int> imap5 = imap1.maxLength(0);
  //     expect(imap5.unlock, []);
  //   });
  //
  //   test('Invalid argument', () => expect(() => imap1.maxLength(-1), throwsArgumentError));
  // });
  //
  // //////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // group('`IMap` methods from `Iterable` |', () {
  //   final IMap<int> iMap = [1, 2, 3].lock.add(4).addAll([5, 6]);
  //
  //   test('`any`', () {
  //     expect(iMap.any((int v) => v == 4), isTrue);
  //     expect(iMap.any((int v) => v == 100), isFalse);
  //   });
  //
  //   test('`cast`', () => expect(iMap.cast<num>(), isA<IMap<num>>()), skip: true);
  //
  //   test('`contains`', () {
  //     expect(iMap.contains(2), isTrue);
  //     expect(iMap.contains(4), isTrue);
  //     expect(iMap.contains(5), isTrue);
  //     expect(iMap.contains(100), isFalse);
  //   });
  //
  //   group('`elementAt` |', () {
  //     test('Regular element access', () {
  //       expect(iMap.elementAt(0), 1);
  //       expect(iMap.elementAt(1), 2);
  //       expect(iMap.elementAt(2), 3);
  //       expect(iMap.elementAt(3), 4);
  //       expect(iMap.elementAt(4), 5);
  //       expect(iMap.elementAt(5), 6);
  //     });
  //
  //     test('Range exceptions', () {
  //       expect(() => iMap.elementAt(6), throwsRangeError);
  //       expect(() => iMap.elementAt(-1), throwsRangeError);
  //     });
  //   });
  //
  //   test('`every`', () {
  //     expect(iMap.every((int v) => v > 0), isTrue);
  //     expect(iMap.every((int v) => v < 0), isFalse);
  //     expect(iMap.every((int v) => v != 4), isFalse);
  //   });
  //
  //   test('`expand`', () {
  //     expect(iMap.expand((int v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
  //     expect(iMap.expand((int v) => []), []);
  //   });
  //
  //   test('`length`', () => expect(iMap.length, 6));
  //
  //   test('`first`', () => expect(iMap.first, 1));
  //
  //   test('`last`', () => expect(iMap.last, 6));
  //
  //   group('`single` |', () {
  //     test('State exception', () => expect(() => iMap.single, throwsStateError));
  //
  //     test('Access', () => expect([10].lock.single, 10));
  //   });
  //
  //   test('`firstWhere`', () {
  //     expect(iMap.firstWhere((int v) => v > 1, orElse: () => 100), 2);
  //     expect(iMap.firstWhere((int v) => v > 4, orElse: () => 100), 5);
  //     expect(iMap.firstWhere((int v) => v > 5, orElse: () => 100), 6);
  //     expect(iMap.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  //   });
  //
  //   test('`fold`', () => expect(iMap.fold(100, (int p, int e) => p * (1 + e)), 504000));
  //
  //   test('`followedBy`', () {
  //     expect(iMap.followedBy([7, 8]).unlock, [1, 2, 3, 4, 5, 6, 7, 8]);
  //     expect(
  //         iMap.followedBy(<int>[].lock.add(7).addAll([8, 9])).unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  //   });
  //
  //   test('`forEach`', () {
  //     int result = 100;
  //     iMap.forEach((int v) => result *= 1 + v);
  //     expect(result, 504000);
  //   });
  //
  //   test('`join`', () {
  //     expect(iMap.join(','), '1,2,3,4,5,6');
  //     expect([].lock.join(','), '');
  //   });
  //
  //   test('`lastWhere`', () {
  //     expect(iMap.lastWhere((int v) => v < 2, orElse: () => 100), 1);
  //     expect(iMap.lastWhere((int v) => v < 5, orElse: () => 100), 4);
  //     expect(iMap.lastWhere((int v) => v < 6, orElse: () => 100), 5);
  //     expect(iMap.lastWhere((int v) => v < 7, orElse: () => 100), 6);
  //     expect(iMap.lastWhere((int v) => v < 50, orElse: () => 100), 6);
  //     expect(iMap.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  //   });
  //
  //   test('`map`', () {
  //     expect([1, 2, 3].lock.map((int v) => v + 1).unlock, [2, 3, 4]);
  //     expect(iMap.map((int v) => v + 1).unlock, [2, 3, 4, 5, 6, 7]);
  //   });
  //
  //   group('`reduce` |', () {
  //     test('Regular usage', () {
  //       expect(iMap.reduce((int p, int e) => p * (1 + e)), 2520);
  //       expect([5].lock.reduce((int p, int e) => p * (1 + e)), 5);
  //     });
  //
  //     test('State exception',
  //         () => expect(() => [].reduce((dynamic p, dynamic e) => p * (1 + e)), throwsStateError));
  //   });
  //
  //   group('`singleWhere` |', () {
  //     test('Regular usage', () {
  //       expect(iMap.singleWhere((int v) => v == 4, orElse: () => 100), 4);
  //       expect(iMap.singleWhere((int v) => v == 50, orElse: () => 100), 100);
  //     });
  //
  //     test(
  //         'State exception',
  //         () => expect(
  //             () => iMap.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError));
  //   });
  //
  //   test('`skip`', () {
  //     expect(iMap.skip(1).unlock, [2, 3, 4, 5, 6]);
  //     expect(iMap.skip(3).unlock, [4, 5, 6]);
  //     expect(iMap.skip(5).unlock, [6]);
  //     expect(iMap.skip(10).unlock, []);
  //   });
  //
  //   test('`skipWhile`', () {
  //     expect(iMap.skipWhile((int v) => v < 3).unlock, [3, 4, 5, 6]);
  //     expect(iMap.skipWhile((int v) => v < 5).unlock, [5, 6]);
  //     expect(iMap.skipWhile((int v) => v < 6).unlock, [6]);
  //     expect(iMap.skipWhile((int v) => v < 100).unlock, []);
  //   });
  //
  //   test('`take`', () {
  //     expect(iMap.take(0).unlock, []);
  //     expect(iMap.take(1).unlock, [1]);
  //     expect(iMap.take(3).unlock, [1, 2, 3]);
  //     expect(iMap.take(5).unlock, [1, 2, 3, 4, 5]);
  //     expect(iMap.take(10).unlock, [1, 2, 3, 4, 5, 6]);
  //   });
  //
  //   test('`takeWhile`', () {
  //     expect(iMap.takeWhile((int v) => v < 3).unlock, [1, 2]);
  //     expect(iMap.takeWhile((int v) => v < 5).unlock, [1, 2, 3, 4]);
  //     expect(iMap.takeWhile((int v) => v < 6).unlock, [1, 2, 3, 4, 5]);
  //     expect(iMap.takeWhile((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
  //   });
  //
  //   group('`toMap` |', () {
  //     test('Regular usage', () {
  //       expect(iMap.toMap()..add(7), [1, 2, 3, 4, 5, 6, 7]);
  //       expect(iMap.unlock, [1, 2, 3, 4, 5, 6]);
  //     });
  //
  //     test('Unsupported exception',
  //         () => expect(() => iMap.toMap(growable: false)..add(7), throwsUnsupportedError));
  //   });
  //
  //   test('`toSet`', () {
  //     expect(iMap.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
  //     expect(iMap.unlock, [1, 2, 3, 4, 5, 6]);
  //   });
  //
  //   test('`where`', () {
  //     expect(iMap.where((int v) => v < 0).unlock, []);
  //     expect(iMap.where((int v) => v < 3).unlock, [1, 2]);
  //     expect(iMap.where((int v) => v < 5).unlock, [1, 2, 3, 4]);
  //     expect(iMap.where((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
  //   });
  //
  //   test('`whereType`', () => expect((<num>[1, 2, 1.5].lock.whereType<double>()).unlock, [1.5]));
  // });
}

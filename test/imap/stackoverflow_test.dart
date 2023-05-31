// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/imap/imap.dart';
import "package:test/test.dart";

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();

    /// If you make this false, all test will end up in stack-overflow.
    ImmutableCollection.autoFlush = true;
  });

  test("IList", () {
    IList.flushFactor = 5000;
    const iterations = 20000;

    IList<int> iList;

    bool isFlushed = true;
    iList = const IListConst([]);
    for (int i = 0; i < iterations; i++) {
      iList = iList.add(i);
      if (isFlushed != iList.isFlushed) {
        isFlushed = !isFlushed;
        if (iList.isFlushed) print('IList flushed after $i iterations.');
      }
    }

    iList.contains(10);
  });

  test("ISet", () {
    ISet.flushFactor = 5000;
    const iterations = 40000;

    ISet<int> iSet;

    bool isFlushed = true;
    iSet = const ISetConst({});
    for (int i = 0; i < iterations; i++) {
      iSet = iSet.add(i);
      if (isFlushed != iSet.isFlushed) {
        isFlushed = !isFlushed;
        if (iSet.isFlushed) print('ISet flushed after $i iterations.');
      }
    }

    iSet.contains(10);
    iSet.containsAll([10, 20, 30]);
  });

  test("IMap", () {
    IMap.flushFactor = 5000;
    const keyIterations = 500;
    const valueIterations = 500;

    IMap<int, int> iMap;

    bool isFlushed = true;
    iMap = IMapImpl.empty();
    for (int i = 0; i < keyIterations; i++) {
      for (int j = 0; j < valueIterations; j++) {
        iMap = iMap.add(i, j);
        if (isFlushed != iMap.isFlushed) {
          isFlushed = !isFlushed;
          if (iMap.isFlushed) print('IMap flushed after ${(i * keyIterations) + j} iterations.');
        }
      }
    }

    iMap.containsKey(10);
    iMap.contains(10, 10);
    iMap.containsValue(10);
    iMap.containsEntry(MapEntry(10, 20));
  });

  test("IMapOfSets", () {
    IMap.flushFactor = 5000;
    const keyIterations = 500;
    const valueIterations = 500;

    IMapOfSets<int, int> iMapOfSets;

    bool isFlushed = true;
    iMapOfSets = IMapOfSets.empty();
    for (int i = 0; i < keyIterations; i++) {
      for (int j = 0; j < valueIterations; j++) {
        iMapOfSets = iMapOfSets.add(i, j);
        if (isFlushed != iMapOfSets.isFlushed) {
          isFlushed = !isFlushed;
          if (iMapOfSets.isFlushed)
            print('IMapOfSets flushed after ${(i * keyIterations) + j} iterations.');
        }
      }
    }

    iMapOfSets.containsKey(10);
    iMapOfSets.contains(10, 10);
    iMapOfSets.containsValue(10);
  });
}

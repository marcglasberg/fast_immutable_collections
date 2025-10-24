// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  group("IList2dExtension", () {
    group("putXY", () {
      test("Basic functionality - replace value in 2D list", () {
        // Create a 2D list
        final list2d = [
          ['a', 'b', 'c'],
          ['d', 'e', 'f'],
          ['g', 'h', 'i']
        ].map((row) => row.lock).toList().lock;

        // Replace value at position (1, 1) - should replace 'e' with 'X'
        final result = list2d.putXY(x: 1, y: 1, value: 'X');

        // Verify the change
        expect(result[1][1], equals('X'));

        // Verify other values remain unchanged
        expect(result[0][0], equals('a'));
        expect(result[0][1], equals('b'));
        expect(result[0][2], equals('c'));
        expect(result[1][0], equals('d'));
        expect(result[1][2], equals('f'));
        expect(result[2][0], equals('g'));
        expect(result[2][1], equals('h'));
        expect(result[2][2], equals('i'));
      });

      test("Replace value at corner positions", () {
        final list2d = [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]
        ].map((row) => row.lock).toList().lock;

        // Top-left corner (0, 0)
        var result = list2d.putXY(x: 0, y: 0, value: 99);
        expect(result[0][0], equals(99));
        expect(result[0][1], equals(2)); // unchanged

        // Top-right corner (2, 0)
        result = list2d.putXY(x: 2, y: 0, value: 88);
        expect(result[0][2], equals(88));
        expect(result[0][1], equals(2)); // unchanged

        // Bottom-left corner (0, 2)
        result = list2d.putXY(x: 0, y: 2, value: 77);
        expect(result[2][0], equals(77));
        expect(result[1][0], equals(4)); // unchanged

        // Bottom-right corner (2, 2)
        result = list2d.putXY(x: 2, y: 2, value: 66);
        expect(result[2][2], equals(66));
        expect(result[2][1], equals(8)); // unchanged
      });

      test("Original list remains unchanged (immutability)", () {
        final original = [
          ['a', 'b'],
          ['c', 'd']
        ].map((row) => row.lock).toList().lock;

        final modified = original.putXY(x: 1, y: 0, value: 'X');

        // Original should remain unchanged
        expect(original[0][1], equals('b'));
        expect(original[1][1], equals('d'));

        // Modified should have the change
        expect(modified[0][1], equals('X'));
        expect(modified[1][1], equals('d'));
      });

      test("Single element 2D list", () {
        final list2d = [
          ['only']
        ].map((row) => row.lock).toList().lock;

        final result = list2d.putXY(x: 0, y: 0, value: 'changed');

        expect(result[0][0], equals('changed'));
        expect(result.length, equals(1));
        expect(result[0].length, equals(1));
      });

      test("Rectangular (non-square) 2D list", () {
        // 3x2 matrix (3 columns, 2 rows)
        final list2d = [
          [1, 2, 3],
          [4, 5, 6]
        ].map((row) => row.lock).toList().lock;

        final result = list2d.putXY(x: 2, y: 1, value: 99);

        expect(result[1][2], equals(99));
        expect(result[0][2], equals(3)); // unchanged
        expect(result[1][0], equals(4)); // unchanged
      });

      test("Different data types", () {
        // Test with integers
        final intList = [
          [1, 2],
          [3, 4]
        ].map((row) => row.lock).toList().lock;

        final intResult = intList.putXY(x: 0, y: 1, value: 100);
        expect(intResult[1][0], equals(100));

        // Test with booleans
        final boolList = [
          [true, false],
          [false, true]
        ].map((row) => row.lock).toList().lock;

        final boolResult = boolList.putXY(x: 1, y: 0, value: true);
        expect(boolResult[0][1], equals(true));
      });

      test("Throws RangeError for out of bounds y-index", () {
        final list2d = [
          ['a', 'b'],
          ['c', 'd']
        ].map((row) => row.lock).toList().lock;

        // y-index out of bounds (negative)
        expect(
          () => list2d.putXY(x: 0, y: -1, value: 'X'),
          throwsA(isA<RangeError>()),
        );

        // y-index out of bounds (too large)
        expect(
          () => list2d.putXY(x: 0, y: 2, value: 'X'),
          throwsA(isA<RangeError>()),
        );
      });

      test("Throws RangeError for out of bounds x-index", () {
        final list2d = [
          ['a', 'b'],
          ['c', 'd']
        ].map((row) => row.lock).toList().lock;

        // x-index out of bounds (negative)
        expect(
          () => list2d.putXY(x: -1, y: 0, value: 'X'),
          throwsA(isA<RangeError>()),
        );

        // x-index out of bounds (too large)
        expect(
          () => list2d.putXY(x: 2, y: 0, value: 'X'),
          throwsA(isA<RangeError>()),
        );
      });

      test("Empty outer list throws RangeError", () {
        final IList<IList<String>> emptyList2d = <IList<String>>[].lock;

        expect(
          () => emptyList2d.putXY(x: 0, y: 0, value: 'X'),
          throwsA(isA<RangeError>()),
        );
      });

      test("Empty inner list throws RangeError", () {
        final list2d = [
          <String>[].lock
        ].lock;

        expect(
          () => list2d.putXY(x: 0, y: 0, value: 'X'),
          throwsA(isA<RangeError>()),
        );
      });

      test("Chaining multiple putXY operations", () {
        final list2d = [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]
        ].map((row) => row.lock).toList().lock;

        final result = list2d
            .putXY(x: 0, y: 0, value: 11)
            .putXY(x: 1, y: 1, value: 55)
            .putXY(x: 2, y: 2, value: 99);

        expect(result[0][0], equals(11));
        expect(result[1][1], equals(55));
        expect(result[2][2], equals(99));

        // Other values should remain unchanged
        expect(result[0][1], equals(2));
        expect(result[1][0], equals(4));
        expect(result[2][1], equals(8));
      });

      test("putXY with nullable types", () {
        final list2d = [
          ['a', null],
          [null, 'b']
        ].map((row) => row.lock).toList().lock;

        // Replace null with a string
        var result = list2d.putXY(x: 1, y: 0, value: 'replaced');
        expect(result[0][1], equals('replaced'));

        // Replace string with null
        result = list2d.putXY(x: 0, y: 0, value: null);
        expect(result[0][0], isNull);
      });
    });
  });
}

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //

  test("compare/then", () {
    IList<int> list = [1, 15, 3, 21, 360, 9, 17, 300, 25, 5, 22, 10, 12, 27, 14, 5].lock;

    /// Comparator Rules:
    /// 1) If present, number 14 is always the first, followed by number 15.
    /// 2) Otherwise, odd numbers come before even ones.
    /// 3) Otherwise, come numbers which are multiples of 3,
    /// 4) Otherwise, come numbers which are multiples of 5,
    /// 5) Otherwise, numbers come in their natural order.
    int Function(int, int) compareTo = sortBy((x) => x == 14,
        then: sortBy((x) => x == 15,
            then: sortBy((x) => x % 2 == 1,
                then: sortBy((x) => x % 3 == 0,
                    then: sortBy(
                      (x) => x % 5 == 0,
                      then: (int a, int b) => a.compareTo(b),
                    )))));

    list = list.sort(compareTo);

    expect(list, [
      14, // 14 must be the first.
      15, // 15 must be the second.
      3, 9, 21, 27, // Odd numbers, multiple of 3, in natural order.
      5, 5, 25, // Odd numbers, multiple of 5, in natural order.
      1, 17, // Odd numbers, not multiple of 3 or 5, in natural order.
      300, 360, // Even numbers, multiples of both 3 and 5, in order.
      12, // Even numbers, multiples of 3, not 5.
      10, // Even numbers, multiples of 5, not 3.
      22, // Even numbers, not multiples of 3 nor 5.
    ]);
  });
}

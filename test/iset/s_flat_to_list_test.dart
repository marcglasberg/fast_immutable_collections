// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

/// Tests for `toList` of a flushed (flat) [ISet].
void main() {
  //
  setUp(() => ImmutableCollection.resetAllConfigurations());

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  test("Keeps the order of the set", () {
    final ISet<int> iset = ISet<int>({3, 1, 2});
    expect(iset.isFlushed, isTrue);
    expect(iset.toList(), [3, 1, 2]);
    expect(iset.toList(growable: false), [3, 1, 2]);
    expect(ISet<int>().toList(), <int>[]);
    expect(ISet<int>({}).toList(growable: false), <int>[]);
  });

  test("Returns a growable or fixed-length copy", () {
    final ISet<int> iset = ISet<int>({3, 1, 2});

    final List<int> growable = iset.toList();
    growable.add(4);
    growable[0] = 100;
    expect(growable, [100, 1, 2, 4]);

    final List<int> fixed = iset.toList(growable: false);
    expect(() => fixed.add(4), throwsUnsupportedError);
    fixed[0] = 100;

    // The set doesn't change.
    expect(iset.toList(), [3, 1, 2]);
    expect(iset.contains(100), isFalse);
  });

  test("toList with compare doesn't change the order of the set", () {
    final ISet<int> iset = ISet<int>({3, 1, 2});
    expect(iset.toList(compare: (a, b) => a.compareTo(b)), [1, 2, 3]);
    expect(iset.toList(), [3, 1, 2]);
    expect(iset.first, 3);
    expect(iset[0], 3);
  });

  test("Sorted ISet", () {
    final ISet<int> iset = ISet<int>.withConfig({3, 1, 2}, ConfigSet(sort: true));
    expect(iset.toList(), [1, 2, 3]);
    expect(iset.toList(growable: false), [1, 2, 3]);
    expect(iset.toList(compare: (a, b) => b.compareTo(a)), [3, 2, 1]);
    expect(iset.toList(), [1, 2, 3]);
  });

  test("ISet backed by a view of a LinkedHashSet (unsafe)", () {
    // A set literal is a LinkedHashSet.
    final ISet<int> iset = ISet<int>.unsafe(<int>{5, 3, 4}, config: ISet.defaultConfig);
    expect(iset.toList(), [5, 3, 4]);
    final List<int> list = iset.toList();
    list.add(1);
    expect(iset.toList(), [5, 3, 4]);
    expect(iset.toList(growable: false), [5, 3, 4]);
  });
}

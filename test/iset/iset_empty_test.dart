// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("Runtime Type", () {
    expect(const ISetEmpty(), isA<ISetEmpty>());
    expect(const ISetEmpty(), isA<ISetEmpty>());
    expect(const ISetEmpty<String>(), isA<ISetEmpty<String>>());
    expect(const ISetEmpty<int>(), isA<ISetEmpty<int>>());

    expect(const ISetEmpty(), isA<ISet>());
    expect(const ISetEmpty(), isA<ISet>());
    expect(const ISetEmpty<String>(), isA<ISet<String>>());
    expect(const ISetEmpty<int>(), isA<ISet<int>>());
  });

  test("Make sure the ISetEmpty can be modified and later iterated", () {
    // SAddAll
    ISet<String> set = const ISet.empty();
    set = set.addAll(["a", "b", "c"]);
    set.forEach((_) { });

    // SAdd
    set = const ISet.empty();
    set = set.add("d");
    set.forEach((_) { });
  });

  test("Make sure the internal set is Set<int>, and not Set<Never>", () {
    const s1 = ISetEmpty<int>();
    expect(s1.runtimeType.toString(), 'ISetEmpty<int>');

    const s2 = ISetConst<int>({1, 2, 3});
    expect(s2.runtimeType.toString(), 'ISetConst<int>');

    final s3 = s1.addAll(s2);
    expect(s3.runtimeType.toString(), 'ISetImpl<int>');

    final result = s3.where((int i) => i == 2).toSet();
    expect(result, [2]);
  });

  test(".same() is working properly", () {
    expect(const ISet.empty().same(const ISet.empty()), isTrue);
  });
}

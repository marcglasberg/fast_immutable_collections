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
    expect(const IListEmpty(), isA<IListEmpty>());
    expect(const IListEmpty(), isA<IListEmpty>());
    expect(const IListEmpty<String>(), isA<IListEmpty<String>>());
    expect(const IListEmpty<int>(), isA<IListEmpty<int>>());

    expect(const IListEmpty(), isA<IList>());
    expect(const IListEmpty(), isA<IList>());
    expect(const IListEmpty<String>(), isA<IList<String>>());
    expect(const IListEmpty<int>(), isA<IList<int>>());
  });

  test("Make sure the IListEmpty can be modified and later iterated", () {
    IList<String> list = const IList.empty();
    list = list.addAll(["a", "b", "c"]);
    list.forEach((_) { });
    list = list.add("d");
    list.forEach((_) { });
    list = list.remove("a");
    list.forEach((_) { });
  });

  test("Make sure the internal list is List<int>, and not List<Never>", () {
    const l1 = IListEmpty<int>();
    expect(l1.runtimeType.toString(), 'IListEmpty<int>');

    const l2 = IListConst<int>([1, 2, 3]);
    expect(l2.runtimeType.toString(), 'IListConst<int>');

    final l3 = l1.addAll(l2);
    expect(l3.runtimeType.toString(), 'IListImpl<int>');

    final result = l3.where((int i) => i == 2).toList();
    expect(result, [2]);
  });
}

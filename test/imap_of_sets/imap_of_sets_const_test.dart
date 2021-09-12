import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

// ignore_for_file: non_const_call_to_literal_constructor

void main() {
  //////////////////////////////////////////////////////////////////////////////

  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Runtime Type", () {
    expect(const IMapOfSetsConst(IMapConst({})), isA<IMapOfSetsConst>());
    expect(const IMapOfSetsConst(IMapConst({})), isA<IMapOfSetsConst>());
    expect(const IMapOfSetsConst<String, int>(IMapConst({})), isA<IMapOfSetsConst<String, int>>());
    expect(
        const IMapOfSetsConst(IMapConst({
          'a': ISetConst<int>({1, 2})
        })),
        isA<IMapOfSetsConst<String, int>>());
    expect(
        const IMapOfSetsConst<String, int>(IMapConst({
          'a': ISetConst<int>({1, 2})
        })),
        isA<IMapOfSetsConst<String, int>>());
  });

  //////////////////////////////////////////////////////////////////////////////

  test("isEmpty | isNotEmpty", () {
    expect(const IMapOfSetsConst(IMapConst({})), isEmpty);
    expect(const IMapOfSetsConst(IMapConst({})).isEmpty, isTrue);
    expect(const IMapOfSetsConst(IMapConst({})).isNotEmpty, isFalse);

    expect(const IMapOfSetsConst<String, int>(IMapConst({})).isEmpty, isTrue);
    expect(const IMapOfSetsConst<String, int>(IMapConst({})).isNotEmpty, isFalse);

    expect(
        const IMapOfSetsConst(IMapConst({
          'a': ISetConst<int>({1, 2})
        })),
        isNotEmpty);
    expect(
        const IMapOfSetsConst(IMapConst({
          'a': ISetConst<int>({1, 2})
        })).isEmpty,
        isFalse);
    expect(
        const IMapOfSetsConst(IMapConst({
          'a': ISetConst<int>({1, 2})
        })).isNotEmpty,
        isTrue);

    expect(const IMapOfSetsConst<String, int>(IMapConst({})), isEmpty);
    expect(const IMapOfSetsConst<String, int>(IMapConst({})).isEmpty, isTrue);
    expect(const IMapOfSetsConst<String, int>(IMapConst({})).isNotEmpty, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////
}

////////////////////////////////////////////////////////////////////////////////////////////////////

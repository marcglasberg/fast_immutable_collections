import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

Map<String, String> add_code = {
  "List (mutable)": "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++) _list.add(i);",
  "IList": "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++) _result = _result.add(i);",
  "KtList":
      "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++) _result = _result.plusElement(i);",
  "BuiltList (with rebuild)":
      "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++) _result = _result.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));",
  "BuiltList (with ListBuilder)":
      "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++) listBuilder.add(i); _result = listBuilder.build();",
};

Map<String, String> add_all_code = {};

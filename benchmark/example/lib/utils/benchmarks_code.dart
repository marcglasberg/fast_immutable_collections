import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

abstract class ListCode {
  static final IMap<String, String> add = {
    "List (Mutable)": "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++)\n" "  _list.add(i);",
    "IList":
        "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++)\n" "  _result = _result.add(i);",
    "KtList": "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++)\n"
        "  _result = _result.plusElement(i);",
    "BuiltList (with rebuild)": "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++)\n"
        "  _result = _result.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));",
    "BuiltList (with ListBuilder)": "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++)\n"
        "  listBuilder.add(i);\n"
        "  _result = listBuilder.build();",
  }.lock;

  static final IMap<String, String> add_all = {
    "List (Mutable)":
        "_list = List<int>.of(_fixedList);\n" "  _list.addAll(ListAddAllBenchmark.listToAdd);",
    "IList": "_result = _iList.addAll(ListAddAllBenchmark.listToAdd);",
    "KtList": "_result = _ktList.plus(KtList<int>.from(ListAddAllBenchmark.listToAdd));",
    "BuiltList": "_builtList.rebuild((ListBuilder<int> listBuilder) => "
        "listBuilder.addAll(ListAddAllBenchmark.listToAdd));",
  }.lock;

  static final IMap<String, String> contains = {
    "List (Mutable)":
        "for (int i = 0; i < _list.length + 1; i++)\n" "  _contains = _list.contains(i);",
    "IList": "for (int i = 0; i < _iList.length + 1; i++)\n" " _contains = _iList.contains(i);",
    "KtList": "for (int i = 0; i < _ktList.size + 1; i++)\n" "  _contains = _ktList.contains(i);",
    "BuiltList":
        "for (int i = 0; i < _builtList.length + 1; i++)\n" " _contains = _builtList.contains(i);",
  }.lock;

  static final IMap<String, String> empty = {
    "List (Mutable)": "_list = <int>[];",
    "IList": "_iList = IList<int>();",
    "KtList": "_ktList = KtList<int>.empty();",
    "BuiltList": "_builtList = BuiltList<int>();",
  }.lock;

  static final IMap<String, String> read = {
    "List (Mutable)": "newVar = _list[ListReadBenchmark.indexToRead];",
    "IList": "newVar = _iList[ListReadBenchmark.indexToRead];",
    "KtList": "newVar = _ktList[ListReadBenchmark.indexToRead];",
    "BuiltList": "newVar = _builtList[ListReadBenchmark.indexToRead];",
  }.lock;

  static final IMap<String, String> remove = {
    "List (Mutable)": "_list.remove(1);",
    "IList": "_iList = _iList.remove(1);",
    "KtList": "_ktList = _ktList.minusElement(1);",
    "BuiltList":
        "_builtList = _builtList.rebuild((ListBuilder<int> listBuilder) => listBuilder.remove(1));",
  }.lock;
}

abstract class SetCode {
  static final IMap<String, String> add = {
    "Set (Mutable)": "_set = Set<int>.of(_fixedSet);\n"
        "for (int i = 0; i < SetAddBenchmark.innerRuns; i++)\n"
        "  _set.add(i);",
    "ISet": "_result = _iSet;\n"
        "for (int i = 0; i < SetAddBenchmark.innerRuns; i++)\n"
        "  _result = _result.add(i);",
    "KtSet": "_result = _ktSet;\n"
        "for (int i = 0; i < SetAddBenchmark.innerRuns; i++)\n"
        "  _result = _result.plusElement(i).toSet();",
    "BuiltSet (with Rebuild)": "_result = _builtSet;\n"
        "for (int i = 0; i < SetAddBenchmark.innerRuns; i++)\n"
        "  _result = _result.rebuild((SetBuilder<int> setBuilder) => setBuilder.add(i));",
    "BuiltSet (with ListBuilder)": "final SetBuilder<int> setBuilder = _builtSet.toBuilder();\n"
        "for (int i = 0; i < SetAddBenchmark.innerRuns; i++) setBuilder.add(i);\n"
        "  _result = setBuilder.build();",
  }.lock;

  static final IMap<String, String> add_all = {
    "Set (Mutable)":
        "_set = Set<int>.of(_fixedSet);\n" "  _set.addAll(SetAddAllBenchmark.setToAdd);",
    "ISet": "_iSet = _fixedISet.addAll(SetAddAllBenchmark.setToAdd);",
    "KtSet": "_ktSet = _fixedISet.plus(SetAddAllBenchmark.setToAdd.toImmutableSet()).toSet();",
    "BuiltSet": "_builtSet = _fixedISet.rebuild((SetBuilder<int> setBuilder) =>\n"
        "  setBuilder.addAll(SetAddAllBenchmark.setToAdd));",
  }.lock;

  static final IMap<String, String> contains = {
    "Set (Mutable)":
        "for (int i = 0; i < _set.length + 1; i++)\n" "  _contains = _set.contains(i);",
    "ISet": "for (int i = 0; i < _iSet.length + 1; i++)\n" "  _contains = _iSet.contains(i);",
    "KtSet": "for (int i = 0; i < _ktSet.size + 1; i++)\n" "  _contains = _ktSet.contains(i);",
    "BuiltSet":
        "for (int i = 0; i < _builtSet.length + 1; i++)\n" "  _contains = _builtSet.contains(i);",
  }.lock;

  static final IMap<String, String> empty = {
    "Set (Mutable)": "_set = <int>{};",
    "ISet": "_iSet = ISet<int>();",
    "KtSet": "_ktSet = KtSet<int>.empty();",
    "BuiltSet": "_builtSet = BuiltSet<int>();",
  }.lock;

  static final IMap<String, String> remove = {
    "Set (Mutable)": "_set.remove(1);",
    "ISet": "_iSet = _fixedSet.remove(1);",
    "KtSet": "_ktSet = _fixedSet.minusElement(1).toSet();",
    "BuiltSet": "_builtSet = _fixedSet.rebuild((SetBuilder<int> setBuilder) =>\n"
        "  setBuilder.remove(1));",
  }.lock;
}

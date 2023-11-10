abstract class ListCode {
  static const Map<String, String> add = {
    "List (Mutable)": "for (int i = 0; i < innerRuns; i++)\n" "  _list.add(i);",
    "IList": "for (int i = 0; i < innerRuns; i++)\n" "  _result = _result.add(i);",
    "KtList": "for (int i = 0; i < innerRuns; i++)\n"
        "  _result = _result.plusElement(i);",
    "BuiltList (with rebuild)": "for (int i = 0; i < innerRuns; i++)\n"
        "  _result = _result.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));",
    "BuiltList (with ListBuilder)": "for (int i = 0; i < innerRuns; i++)\n"
        "  listBuilder.add(i);\n"
        "  _result = listBuilder.build();",
  };

  static const Map<String, String> addAll = {
    "List (Mutable)":
        "list.addAll(ListBenchmarkBase.getDummyGeneratedList(size: config.size ~/ 10));",
    "IList":
        "result = iList.addAll(ListBenchmarkBase.getDummyGeneratedList(size: config.size ~/ 10));",
    "KtList":
        "ktList.plus(KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size ~/ 10)));",
    "BuiltList": "_builtList.rebuild((ListBuilder<int> listBuilder) => "
        "listBuilder.addAll(ListBenchmarkBase.getDummyGeneratedList(size: config.size ~/ 10)));",
  };

  static const Map<String, String> contains = {
    "List (Mutable)":
        "for (int i = 0; i < _list.length + 1; i++)\n" "  _contains = _list.contains(i);",
    "IList": "for (int i = 0; i < _iList.length + 1; i++)\n" " _contains = _iList.contains(i);",
    "KtList": "for (int i = 0; i < _ktList.size + 1; i++)\n" "  _contains = _ktList.contains(i);",
    "BuiltList":
        "for (int i = 0; i < _builtList.length + 1; i++)\n" " _contains = _builtList.contains(i);",
  };

  static const Map<String, String> empty = {
    "List (Mutable)": "_list = <int>[];",
    "IList": "_iList = IList<int>();",
    "KtList": "_ktList = KtList<int>.empty();",
    "BuiltList": "_builtList = BuiltList<int>();",
  };

  static const Map<String, String> insert = {
    "List (Mutable)": "list.insert(randomInt, randomInt);",
    "IList": "result = result.insert(randomInt, randomInt);",
    "KtList": "  final KtMutableList<int> mutable = result.toMutableList();\n"
        "  mutable.addAt(randomInt, randomInt);\n"
        "  result = KtList<int>.from(mutable.iter);",
    "BuiltList": "final ListBuilder<int> listBuilder = builtList.toBuilder();\n"
        "  listBuilder.insert(randomInt, randomInt);\n"
        "  result = listBuilder.build();",
  };

  static const Map<String, String> read = {
    "List (Mutable)": "newVar = _list[config.size ~/ 2];",
    "IList": "newVar = _iList[config.size ~/ 2];",
    "KtList": "newVar = _ktList[config.size ~/ 2];",
    "BuiltList": "newVar = _builtList[config.size ~/ 2];",
  };

  static const Map<String, String> remove = {
    "List (Mutable)": "_list.remove(config.size ~/ 2);",
    "IList": "_iList = _iList.remove(config.size ~/ 2);",
    "KtList": "_ktList = _ktList.minusElement(config.size ~/ 2);",
    "BuiltList": "_builtList = _builtList.rebuild((ListBuilder<int> listBuilder) =>\n"
        "  listBuilder.remove(config.size ~/ 2));",
  };
}

abstract class SetCode {
  static const Map<String, String> add = {
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
  };

  static const Map<String, String> addAll = {
    "Set (Mutable)": "_set.addAll(toBeAdded);",
    "ISet": "_iSet = _fixedISet.addAll(toBeAdded);",
    "KtSet": "_ktSet = _fixedISet.plus(toBeAdded.toImmutableSet()).toSet();",
    "BuiltSet": "_builtSet = _fixedISet.rebuild((SetBuilder<int> setBuilder) =>\n"
        "  setBuilder.addAll(toBeAdded));",
  };

  static const Map<String, String> contains = {
    "Set (Mutable)":
        "for (int i = 0; i < _set.length + 1; i++)\n" "  _contains = _set.contains(i);",
    "ISet": "for (int i = 0; i < _iSet.length + 1; i++)\n" "  _contains = _iSet.contains(i);",
    "KtSet": "for (int i = 0; i < _ktSet.size + 1; i++)\n" "  _contains = _ktSet.contains(i);",
    "BuiltSet":
        "for (int i = 0; i < _builtSet.length + 1; i++)\n" "  _contains = _builtSet.contains(i);",
  };

  static const Map<String, String> empty = {
    "Set (Mutable)": "_set = <int>{};",
    "ISet": "_iSet = ISet<int>();",
    "KtSet": "_ktSet = KtSet<int>.empty();",
    "BuiltSet": "_builtSet = BuiltSet<int>();",
  };

  static const Map<String, String> remove = {
    "Set (Mutable)": "_set.remove(config.size ~/ 2);",
    "ISet": "_iSet = _fixedSet.remove(config.size ~/ 2);",
    "KtSet": "_ktSet = _fixedSet.minusElement(config.size ~/ 2).toSet();",
    "BuiltSet": "_builtSet = _fixedSet.rebuild((SetBuilder<int> setBuilder) =>\n"
        "  setBuilder.remove(config.size ~/ 2));",
  };
}

abstract class MapCode {
  static const Map<String, String> add = {
    "Map (Mutable)": "for (int i = 0; i < initialLength + innerRuns(); i++)\n"
        "  _map.addAll({i.toString(): i});",
    "Map": "for (int i = 0; i < initialLength + innerRuns(); i++)\n"
        "  _result = _result.add(i.toString(), i);",
    "KtMap": "for (int i = 0; i < initialLength + innerRuns(); i++)\n"
        "  _result = _result.plus(<String, int>{i.toString(): i}.toImmutableMap());",
    "BuiltMap with Rebuild": "for (int i = 0; i < initialLength + innerRuns(); i++)\n"
        "  _result = _result.rebuild((MapBuilder<String, int> mapBuilder) =>\n"
        "  mapBuilder.addAll(<String, int>{i.toString(): i}));",
    "BuiltMap with ListBuilder": "for (int i = 0; i < initialLength + innerRuns(); i++)\n"
        "  mapBuilder.addAll(<String, int>{i.toString(): i});\n"
        "  _result = mapBuilder.build();"
  };

  static const Map<String, String> addAll = {
    "Map (Mutable)": "_map = Map<String, int>.of(_fixedMap);\n" "_map.addAll(toBeAdded);",
    "Map": "_result = _Map.addAll(toBeAdded);",
    "KtMap": "_result = _ktMap.plus(KtMap<String, int>.from(toBeAdded));",
    "BuiltMap": "_result = _builtMap.rebuild((MapBuilder<String, int> mapBuilder) => "
        "mapBuilder.addAll(toBeAdded));",
  };

  static const Map<String, String> containsValue = {
    "Map (Mutable)":
        "for (int i = 0; i < _map.length + 1; i++)\n" "  _contains = _map.containsValue(i);",
    "Map": "for (int i = 0; i < _Map.length + 1; i++)\n" "  _contains = _Map.containsValue(i);",
    "KtMap": "for (int i = 0; i < _ktMap.size + 1; i++)\n" "  _contains = _ktMap.containsValue(i);",
    "BuiltMap": "for (int i = 0; i < _builtMap.length + 1; i++)\n"
        "  _contains = _builtMap.containsValue(i);",
  };

  static const Map<String, String> empty = {
    "Map (Mutable)": "_map = <String, int>{};",
    "Map": "_Map = Map<String, int>();",
    "KtMap": "_ktMap = KtMap<String, int>.empty();",
    "BuiltMap": "_builtMap = BuiltMap<String, int>();",
  };

  static const Map<String, String> read = {
    "Map (Mutable)": "_newVar = _map[(config.size ~/ 2).toString()];",
    "Map": "_newVar = _Map[(config.size ~/ 2).toString()];",
    "KtMap": "_newVar = _ktMap[(config.size ~/ 2).toString()];",
    "BuiltMap": "_newVar = _builtMap[(config.size ~/ 2).toString()];",
  };

  static const Map<String, String> remove = {
    "Map (Mutable)": "_map.remove((config.size ~/ 2).toString());",
    "Map": "_Map = _Map.remove((config.size ~/ 2).toString());",
    "KtMap": "_ktMap = _ktMap.minus((config.size ~/ 2).toString());",
    "BuiltMap": "_builtMap = _builtMap.rebuild((MapBuilder<String, int> mapBuilder)\n"
        " => mapBuilder.remove((config.size ~/ 2).toString()));",
  };
}

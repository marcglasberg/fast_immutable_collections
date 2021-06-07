extension FicObjectExtension on Object? {
  //
  /// Checks if some object in the format "Obj<T>" has a generic type T.
  ///
  /// Examples:
  /// expect(<int>[1].isOfExactGenericType(int), isTrue);
  /// expect(<num>[1].isOfExactGenericType(num), isTrue);
  /// expect(<int>[1].isOfExactGenericType(num), isFalse);
  /// expect(<num>[1].isOfExactGenericType(int), isFalse);
  bool isOfExactGenericType(Type type) {
    // ignore: no_runtimetype_tostring
    return runtimeType.toString().endsWith('<$type>');
  }

  /// Checks if some object in the format "Obj1<T>" has a generic type equal to "Obj2<T>".
  ///
  /// Examples:
  /// expect(<int>[1].isOfExactGenericTypeAs(<int>[1]), isTrue);
  /// expect(<num>[1].isOfExactGenericType(<num>[1]), isTrue);
  /// expect(<int>[1].isOfExactGenericType(<num>[1]), isFalse);
  /// expect(<num>[1].isOfExactGenericType(<num>[1]), isFalse);
  bool isOfExactGenericTypeAs(Object? obj) {
    var runtimeTypeStr = obj.runtimeType.toString();
    var pos = runtimeTypeStr.lastIndexOf('<');
    // ignore: no_runtimetype_tostring
    return runtimeType.toString().endsWith('<${runtimeTypeStr.substring(pos + 1)}');
  }
}

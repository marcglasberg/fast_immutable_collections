// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

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
    final runtimeTypeStr = obj.runtimeType.toString();
    final pos = runtimeTypeStr.lastIndexOf('<');
    return runtimeType.toString().endsWith('<${runtimeTypeStr.substring(pos + 1)}');
  }
}

// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
// ignore_for_file: unnecessary_type_check
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("isOfExactGenericType / isOfExactGenericTypeAs", () {
    expect(<int>[1].isOfExactGenericType(int), isTrue);
    expect(<int>[1].isOfExactGenericTypeAs(<int>[1]), isTrue);
    expect(<int>[1] is List<int>, isTrue);

    expect(<num>[1].isOfExactGenericType(num), isTrue);
    expect(<num>[1].isOfExactGenericTypeAs(<num>[1]), isTrue);
    expect(<num>[1] is List<num>, isTrue);

    expect(<int>[1].isOfExactGenericType(num), isFalse);
    expect(<int>[1].isOfExactGenericTypeAs(<num>[1]), isFalse);
    expect(<int>[1] is List<num>, isTrue);

    expect(<num>[1].isOfExactGenericType(int), isFalse);
    expect(<num>[1].isOfExactGenericTypeAs(<int>[1]), isFalse);
    expect(<num>[1] is List<int>, isFalse);

    expect(<num>[1].isOfExactGenericType(String), isFalse);
    expect(<num>[1].isOfExactGenericTypeAs(<String>["1"]), isFalse);
    expect(<num>[1] is List<String>, isFalse);

    expect(<String>["1"].isOfExactGenericType(String), isTrue);
    expect(<String>["1"].isOfExactGenericTypeAs(<String>["1"]), isTrue);
    expect(<String>["1"] is List<String>, isTrue);
  });
}

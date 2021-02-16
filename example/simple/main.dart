import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  var ilist1 = IList<dynamic>();

  print(ilist1); // []

  var ilist2 = ilist1.add(1);

  print(ilist1); // []
  print(ilist2); // [1]
}

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main(List<String> args) {
   IList<String> list = const IList.empty();
   //list = list.flush;
   list = list.addAll(["abc"]);
   final expanded = list.expand((p0) => p0.runes);
   print(expanded);
}

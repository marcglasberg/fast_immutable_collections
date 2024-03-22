import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  // Example usage of IList.
  print('IList Example:');
  IList<int> iList = IList<int>();

  // Add elements to the list.
  iList = iList.add(10).addAll([20, 30, 40]);
  print('Original List: $iList');

  // Access elements in the list.
  final int firstElement = iList.first;
  print('First Element: $firstElement');

  // Remove an element from the list.
  iList = iList.remove(20);
  print('List after removing 20: $iList');

  // Find an element in the list.
  final bool containsThirty = iList.contains(30);
  print('Does the list contain 30? $containsThirty');

  // Creating a empty IList
  const emptyIList = IList<String>.empty();
  print("Empty IList is empty? ${emptyIList.isEmpty}");



  // Example usage of ISet.
  print('\nISet Example:');
  ISet<String> iSet = ISet<String>();

  // Add elements to the set.
  iSet = iSet.add('apple').addAll(['banana', 'orange', 'grape']);
  print('Original Set: $iSet');

  // Remove an element from the set.
  iSet = iSet.remove('orange');
  print('Set after removing orange: $iSet');

  // Check if the set contains an element.
  final bool containsBanana = iSet.contains('banana');
  print('Does the set contain banana? $containsBanana');

  // Iterate over the elements in the set.
  print('Iterating over the set:');
  for (final String fruit in iSet) {
    print(fruit);
  }

  // Creating a empty ISet
  const emptyISet = ISet<String>.empty();
  print("Empty ISet is empty? ${emptyISet.isEmpty}");

  // Example usage of IMap
  print('\nIMap Example:');
  IMap<String, String> iMap = IMap<String, String>();

  // Add elements to the map.
  iMap = iMap.add('apple', 'red');
  iMap = iMap.addEntries([
    const MapEntry('banana', 'yellow'),
    const MapEntry('orange', 'orange'),
    const MapEntry('grape', 'green')
  ]);
  print('Original Map: $iMap');

  // Remove an element from the map.
  iMap = iMap.remove('orange');
  print('Map after removing orange: $iMap');

  // Check if the map contains an element.
  final bool containsApple = iMap.containsKey('apple');
  print('Does the map contain apple as a key? $containsApple');

  // Iterate over the elements in the map.
  print('Iterating over the map:');
  for (final MapEntry<String, String> fruitAndColor in iMap.entries) {
    print("${fruitAndColor.key}: ${fruitAndColor.value}");
  }

  // Creating a empty IMap
  const emptyIMap = IMap<String, String>.empty();
  print("Empty IMap is empty? ${emptyIMap.isEmpty}");
}

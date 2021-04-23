import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_serializable_e2e_test/src/model/ilist_model.dart';
import 'package:test/test.dart';

void main() {
  group('iList:', () {
    test('can serialize IList', () {
      expect(IListWrapper(IList()).toJson(), {'iList': <String>[]});
      expect(IListWrapper(IList(['a', 'b', 'c'])).toJson(), {
        'iList': <String>['a', 'b', 'c']
      });
    });

    test('can deserialize IList', () {
      expect(IListWrapper.fromJson({'iList': <String>[]}).iList,
          IList(<String>[]));
      expect(
          IListWrapper.fromJson({
            'iList': <String>['a', 'b', 'c']
          }).iList,
          IList(<String>['a', 'b', 'c']));
    });
  });

  group('iSet:', () {
    test('can serialize ISet', () {
      expect(ISetWrapper(ISet()).toJson(), {'iSet': <String>[]});
      expect(ISetWrapper(ISet(['a', 'b', 'c'])).toJson(), {
        'iSet': <String>['a', 'b', 'c']
      });
    });

    test('can deserialize ISet', () {
      expect(ISetWrapper.fromJson({'iSet': <String>[]}).iSet, ISet(<String>[]));
      expect(
          ISetWrapper.fromJson({
            'iSet': <String>['a', 'b', 'c']
          }).iSet,
          ISet(<String>['a', 'b', 'c']));
    });
  });

  group('iMap', () {
    test('can serialize IMap', () {
      expect(IMapWrapper(IMap()).toJson(), {'iMap': {}});
      expect(
          IMapWrapper(IMap({
            'a': 'b',
            'c': 'd',
          })).toJson(),
          {
            'iMap': {
              'a': 'b',
              'c': 'd',
            }
          });
    });

    test('can deserialize IMap', () {
      expect(
          IMapWrapper.fromJson({
            'iMap': {
              'a': 'b',
              'c': 'd',
            }
          }).iMap,
          IMap({
            'a': 'b',
            'c': 'd',
          }));
    });
  });
}

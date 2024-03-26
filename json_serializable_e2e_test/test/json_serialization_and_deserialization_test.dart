import 'dart:convert';

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
      expect(IListWrapper.fromJson({'iList': <String>[]}).iList, IList(<String>[]));
      expect(
          IListWrapper.fromJson({
            'iList': <String>['a', 'b', 'c']
          }).iList,
          IList(<String>['a', 'b', 'c']));
    });

    test('can serialize IList of enums', () {
      expect(IListWrapper2(IList<TestEnum>()).toJson(), {'iList': <TestEnum>[]});

      expect(
          IListWrapper2(IList([TestEnum.valA, TestEnum.valB, TestEnum.valC])).toJson(),
          anyOf({
            'iList': <TestEnum>[TestEnum.valA, TestEnum.valB, TestEnum.valC]
          }, {
            'iList': ['valA', 'valB', 'valC']
          }));
    });

    test('can deserialize IList of enums', () {
      expect(IListWrapper2.fromJson({'iList': <TestEnum>[]}).iList, IList(<TestEnum>[]));

      IList result;
      try {
        result = IListWrapper2.fromJson({
          'iList': <String>['valA', 'valB', 'valC']
        }).iList;
      } catch (e) {
        result = IListWrapper2.fromJson({
          'iList': <TestEnum>[TestEnum.valA, TestEnum.valB, TestEnum.valC]
        }).iList;
      }

      expect(result, IList(<TestEnum>[TestEnum.valA, TestEnum.valB, TestEnum.valC]));
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

      expect(
          jsonEncode(IMapWrapper2({
            1: 'b',
            2: 'd',
          }.lock)
              .toJson()),
          '''{"iMap":{"1":"b","2":"d"}}''');
    });

    test('can serialize and deserialize IMap', () {
      final wrapper = IMapWrapper(IMap({'a': 'b', 'c': 'd'}));
      expect(IMapWrapper.fromJson(wrapper.toJson()).iMap, wrapper.iMap);
    });

    test('can serialize IMap of enums', () {
      expect(IMapWrapper3(IMap()).toJson(), {'iMap': {}});

      expect(
          IMapWrapper3(IMap({
            TestEnum.valA: 'b',
            TestEnum.valC: 'd',
          })).toJson(),
          {
            'iMap': {'valA': 'b', 'valC': 'd'}
          });

      expect(
          jsonEncode(IMapWrapper3({
            TestEnum.valA: 'b',
            TestEnum.valC: 'd',
          }.lock)
              .toJson()),
          '''{"iMap":{"valA":"b","valC":"d"}}''');
    });

    test('can deserialize IMap where enums are keys', () {
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
      expect(
          IMapWrapper2.fromJson(
                  jsonDecode('''{"iMap":{"1":"b","2":"d"}}''') as Map<String, dynamic>)
              .iMap,
          IMap({
            1: 'b',
            2: 'd',
          }));
    });
  });

  test('can deserialize IMap where enums are keys', () {
    expect(
        () => IMapWrapper3.fromJson({
              'iMap': {
                'valA': 'b',
                'valC': 'd',
              }
            }).iMap,
        throwsUnsupportedError);

    // When enum IMap keys are implemented, uncomment this:
    // expect(
    //     IMapWrapper3.fromJson({
    //       'iMap': {
    //         'valA': 'b',
    //         'valC': 'd',
    //       }
    //     }).iMap,
    //     IMap({
    //       TestEnum.valA: 'b',
    //       TestEnum.valC: 'd',
    //     }));
  });
}

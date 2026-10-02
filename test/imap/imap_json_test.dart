// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
//
// Tests for IMap keys in IMap.fromJson and IMap.toJson. See issues #39, #58 and #82:
//   https://github.com/marcglasberg/fast_immutable_collections/issues/39
//   https://github.com/marcglasberg/fast_immutable_collections/issues/58
//   https://github.com/marcglasberg/fast_immutable_collections/issues/82
//
// The `fromJsonK` and `toJsonK` functions below are copied from the code json_serializable
// generates. The real generated code is tested in `json_serializable_e2e_test/test/imap_keys_test.dart`.
import "dart:convert";
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

enum Color { red, green, blue }

const _colorEnumMap = {Color.red: "red", Color.green: "green", Color.blue: "blue"};

Color _enumDecode(Object? value) => _colorEnumMap.entries.singleWhere(
      (entry) => entry.value == value,
      orElse: () => throw ArgumentError("`$value` is not one of the supported values."),
    ).key;

class UserId {
  final int value;

  const UserId(this.value);

  factory UserId.fromJson(String json) => UserId(int.parse(json.substring("user-".length)));

  String toJson() => "user-$value";

  @override
  bool operator ==(Object other) => other is UserId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Encodes to a JSON string and decodes it back, exactly like a real network round-trip.
Map<String, dynamic> viaJsonString(Object json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

void main() {
  group("Key types which already work, and must keep working:", () {
    test("String keys", () {
      final imap = {"a": 1, "b": 2}.lock;
      final json = imap.toJson((value) => value, (value) => value);
      expect(jsonEncode(json), '{"a":1,"b":2}');
      expect(
          IMap<String, int>.fromJson(viaJsonString(json), (value) => value as String,
              (value) => (value as num).toInt()),
          imap);
    });

    test("int keys", () {
      final imap = {1: "a", -2: "b"}.lock;
      final json = imap.toJson((value) => value, (value) => value);
      expect(jsonEncode(json), '{"1":"a","-2":"b"}');
      expect(
          IMap<int, String>.fromJson(viaJsonString(json), (value) => (value as num).toInt(),
              (value) => value as String),
          imap);
    });

    test("double keys", () {
      final imap = {1.5: "a", -2.25: "b"}.lock;
      final json = imap.toJson((value) => value, (value) => value);
      expect(jsonEncode(json), '{"1.5":"a","-2.25":"b"}');
      expect(
          IMap<double, String>.fromJson(viaJsonString(json),
              (value) => (value as num).toDouble(), (value) => value as String),
          imap);
    });

    test("bool keys", () {
      final imap = {true: "yes", false: "no"}.lock;
      final json = imap.toJson((value) => value, (value) => value);
      expect(jsonEncode(json), '{"true":"yes","false":"no"}');
      expect(
          IMap<bool, String>.fromJson(
              viaJsonString(json), (value) => value as bool, (value) => value as String),
          imap);
    });
  });

  group("Issue #39: Enum keys:", () {
    test("Enum keys", () {
      final imap = {Color.red: true, Color.blue: false}.lock;
      final json = imap.toJson((value) => _colorEnumMap[value]!, (value) => value);
      expect(jsonEncode(json), '{"red":true,"blue":false}');
      expect(
          IMap<Color, bool>.fromJson(
              viaJsonString(json), (value) => _enumDecode(value), (value) => value as bool),
          imap);
    });

    test("An unknown enum key throws the error thrown by fromJsonK", () {
      expect(
          () => IMap<Color, bool>.fromJson(
              {"purple": true}, (value) => _enumDecode(value), (value) => value as bool),
          throwsArgumentError);
    });
  });

  group("Issue #58: DateTime, BigInt and Uri keys:", () {
    test("DateTime keys", () {
      final imap = {DateTime.utc(2023, 6, 25): "a", DateTime(2024, 1, 2, 3, 4, 5): "b"}.lock;
      final json = imap.toJson((value) => value.toIso8601String(), (value) => value);
      expect(jsonEncode(json), '{"2023-06-25T00:00:00.000Z":"a","2024-01-02T03:04:05.000":"b"}');
      expect(
          IMap<DateTime, String>.fromJson(viaJsonString(json),
              (value) => DateTime.parse(value as String), (value) => value as String),
          imap);
    });

    test("BigInt keys", () {
      final imap = {BigInt.parse("123456789012345678901234567890"): "a", BigInt.from(-1): "b"}.lock;
      final json = imap.toJson((value) => value.toString(), (value) => value);
      expect(jsonEncode(json), '{"123456789012345678901234567890":"a","-1":"b"}');
      expect(
          IMap<BigInt, String>.fromJson(viaJsonString(json),
              (value) => BigInt.parse(value as String), (value) => value as String),
          imap);
    });

    test("Uri keys", () {
      final imap = {Uri.parse("https://example.com/a?b=c"): "a", Uri.parse("mailto:x@y.com"): "b"}.lock;
      final json = imap.toJson((value) => value.toString(), (value) => value);
      expect(jsonEncode(json), '{"https://example.com/a?b=c":"a","mailto:x@y.com":"b"}');
      expect(
          IMap<Uri, String>.fromJson(viaJsonString(json), (value) => Uri.parse(value as String),
              (value) => value as String),
          imap);
    });
  });

  group("Issue #82: Custom key types:", () {
    test("Custom keys with a JsonConverter", () {
      final imap = {const Point(3, 4): 1, const Point(-1, 0): 2}.lock;
      final json = imap.toJson((value) => "${value.x}x${value.y}", (value) => value);
      expect(jsonEncode(json), '{"3x4":1,"-1x0":2}');
      expect(
          IMap<Point<int>, int>.fromJson(viaJsonString(json), (value) {
            final parts = (value as String).split("x");
            return Point(int.parse(parts[0]), int.parse(parts[1]));
          }, (value) => (value as num).toInt()),
          imap);
    });

    test("Custom keys with their own fromJson/toJson", () {
      // For keys with a `toJson` method, json_serializable generates `(value) => value`,
      // so the key's `toJson` must be called by IMap.toJson.
      final imap = {const UserId(1): "Alice", const UserId(42): "Bob"}.lock;
      final json = imap.toJson((value) => value, (value) => value);
      expect(jsonEncode(json), '{"user-1":"Alice","user-42":"Bob"}');
      expect(
          IMap<UserId, String>.fromJson(viaJsonString(json),
              (value) => UserId.fromJson(value as String), (value) => value as String),
          imap);
    });
  });
}

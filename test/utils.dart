import "package:test/test.dart";

final Matcher throwsAssertionError = throwsA(const TypeMatcher<AssertionError>());
final Matcher throwsTypeError = throwsA(const TypeMatcher<TypeError>());

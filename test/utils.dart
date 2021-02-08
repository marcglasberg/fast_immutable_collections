import "package:test/test.dart";

const TypeMatcher<AssertionError> isTypeError = TypeMatcher<AssertionError>();
final Matcher throwsAssertionError = throwsA(isTypeError);

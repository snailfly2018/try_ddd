import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:try_ddd/domain/auth/value_objects.dart';
import 'package:try_ddd/domain/core/value_failure.dart';

void main() {
  group('EmailAddress', () {
    const errEmail = "email.error";
    const rightEmail = 'right@email.ca';
    test('email invalid value failed', () {
      expect(EmailAddress(errEmail).value,
          left(const InvalidEmail(failedValue: errEmail)));
    });

    test('email invalid value right!', () {
      expect(EmailAddress(rightEmail).value, right(rightEmail));
    });
  });

    group('PassWord', () {
    const errPassword = "12345";
    const rightPassword = '123456';
    test('password invalid too short-value failed', () {
      expect(Password(errPassword).value,
          left(const ShortPassword(failedValue: errPassword)));
    });

    test('password invalid value right!', () {
      expect(Password(rightPassword).value, right(rightPassword));
    });
  });
}

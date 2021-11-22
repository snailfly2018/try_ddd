import 'package:fpdart/fpdart.dart';

import 'package:try_ddd/domain/core/value_failure.dart';
import 'package:try_ddd/domain/core/value_objects.dart';
import 'package:try_ddd/domain/core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  //私有构造函数
  const EmailAddress._(this.value);

  factory EmailAddress(String input) {
    return EmailAddress._(validateEmailAddress(input));
  }
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) {
    return Password._(
      validatePassword(input),
    );
  }

  ///私有化
  const Password._(this.value);
}


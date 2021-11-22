import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:try_ddd/domain/core/errors.dart';

import 'package:try_ddd/domain/core/value_failure.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

    /// Throws [UnexpectedValueError] containing the [ValueFailure]
  /// 获取数据，如果left错误则直接抛出异常，那是在api中需要用right数据作为参数的时候，
  /// 必须在程序里保证不会出现该情况，如果出现，则异常乐
  T getOrCrash() {
    // id = identity - same as writing (right) => right
    return value.fold((f) => throw UnexpectedValueError(f), id);
  }

  ///判断
  bool isValid() => value.isRight();
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';

}

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  ///缺省通过Uuid构建
  factory UniqueId() {
    return UniqueId._(
      right(const Uuid().v1()),
    );
  }

  ///给定uid
  factory UniqueId.fromUniqueString(String uniqueId) {
    return UniqueId._(
      right(uniqueId),
    );
  }

  ///私有化
  const UniqueId._(this.value);
}

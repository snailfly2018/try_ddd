import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:try_ddd/domain/core/value_objects.dart';

part 'user.freezed.dart';

@freezed
abstract class UserId with _$UserId {
  const factory UserId({required UniqueId id,}) = _UserId;
}

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:try_ddd/domain/auth/user.dart';
import 'package:try_ddd/domain/core/value_objects.dart';

extension FirebaseUserDomainX on firebase.User {
  UserId toDomain() {
    return UserId(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
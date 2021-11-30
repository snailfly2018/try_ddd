import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:try_ddd/domain/auth/auth_failure.dart';
import 'package:try_ddd/domain/auth/i_auth_facade.dart';
import 'package:try_ddd/domain/auth/user.dart';
import 'package:try_ddd/domain/auth/value_objects.dart';
import 'package:try_ddd/domain/core/value_objects.dart';

@LazySingleton(as: IAuthFacade)
class FirebaseAuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthFacade(this._firebaseAuth, this._googleSignIn);

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
      {required EmailAddress emailAddress, required Password password}) async {
    //如果到这里没有合法的emailaddress或者password那就crash吧
    final emailAddressString = emailAddress.getOrCrash();
    final passwordString = password.getOrCrash();

    //将异常转为left错误的地方，从这里往上就是错误乐
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailAddressString, password: passwordString);
      return right(unit); //没错了
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword(
      {required EmailAddress emailAddress, required Password password}) async {
    final emailAddressString = emailAddress.getOrCrash();
    final passwordString = password.getOrCrash();

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: emailAddressString, password: passwordString);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      //两种情况统一为email password combination error
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return left(const AuthFailure.cancelledByUser());
      }
      final googleAuthentication = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
          idToken: googleAuthentication.idToken,
          accessToken: googleAuthentication.accessToken);

      return _firebaseAuth
          .signInWithCredential(authCredential)
          .then((r) => right(unit));
    } on FirebaseAuthException catch (_) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<void> signOut() => Future.wait([
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);

  @override
  Future<Option<UserId>> getSignedInUser() async {
    if (_firebaseAuth.currentUser == null) {
      return none();
    } else {
      return some(UserId(
          id: UniqueId.fromUniqueString(_firebaseAuth.currentUser!.uid)));
    }
  }
  // return optionOf(_firebaseAuth.currentUser?.toDomain());

}

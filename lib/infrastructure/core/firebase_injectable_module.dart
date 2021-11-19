
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

///注入需要的对象定义在这里

@module
abstract class FirebaseInjectableModule {
  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}

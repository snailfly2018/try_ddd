import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:try_ddd/presentation/core/app_widget.dart';

import 'injection.dart';

Future<void> main() async {
  // Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection(Environment.prod); //注入

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBC7Muw1zsYqCBQb91kI6fNB7cjY0kYPyw",
          authDomain: "ddd-note-app-70a22.firebaseapp.com",
          projectId: "ddd-note-app-70a22",
          storageBucket: "ddd-note-app-70a22.appspot.com",
          messagingSenderId: "423320686303",
          appId: "1:423320686303:web:7772e418c1bdfccdb7636a"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(AppWidget());
}

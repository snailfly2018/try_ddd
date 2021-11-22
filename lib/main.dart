import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:try_ddd/bloc_observer.dart';
import 'package:try_ddd/presentation/core/app_widget.dart';

import 'injection.dart';

Future<void> main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection(Environment.prod); //注入
  await Firebase.initializeApp();
  runApp(AppWidget());
}

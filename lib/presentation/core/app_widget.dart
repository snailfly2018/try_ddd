// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_ddd/application/auth/auth_bloc.dart';
import 'package:try_ddd/presentation/router/router.gr.dart' as app_router;

import '../../injection.dart';

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final _appRouter = app_router.Router();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()
            ..add(const AuthEvent.authCheckRequested()), //开始发一个auth check
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Notes',
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.green[800],
          // accentColor: Colors.blueAccent,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue[900],
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // home: MaterialApp.router(
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate(),
      ),
    );
  }
}


/* When the platform emits a new route (for example, “books/2”) , 
the RouteInformationParser converts it into an abstract data type T that you define in your app
 (for example, a class called BooksRoutePath).

RouterDelegate’s setNewRoutePath method is called with this data type, and must update 
the application state to reflect the change (for example, by setting the selectedBookId) 
and call notifyListeners.

When notifyListeners is called, it tells the Router to rebuild the RouterDelegate 
(using its build() method)

RouterDelegate.build() returns a new Navigator, whose pages now reflect the change to the app state 
(for example, the selectedBookId).
*/
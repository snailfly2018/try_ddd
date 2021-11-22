import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_ddd/application/auth/auth_bloc.dart';
import '../router/router.gr.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        //根据登入情况选择页面
        state.map(
          initial: (_) {},
          authenticated: (_) => context.replaceRoute(const NotesOverviewRoute()),
          unauthenticated: (_) => context.replaceRoute(const SignInRoute()),
          
        );
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

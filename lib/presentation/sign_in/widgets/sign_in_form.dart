import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_ddd/application/auth/auth_bloc.dart';
import 'package:try_ddd/application/auth/sign_in_form/sign_in_form_bloc.dart';
import '../../router/router.gr.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  // SignInFormState? nowState;
  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  //为了取得新状态做的改动，why?
  SignInFormState? nowState;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        {
          //登录结果回来的处理
          state.authFailureOrSuccessOption.match(
            (either) => either.fold(
              (failure) {
                FlushbarHelper.createError(
                  message: failure.map(
                      cancelledByUser: (_) => 'Cancelled',
                      serverError: (_) => 'Server Error',
                      emailAlreadyInUse: (_) => 'Email already in use',
                      invalidEmailAndPasswordCombination: (_) =>
                          'Invalid email and password combination'),
                ).show(context);
              },
              (_) {
                context.replaceRoute(const NotesOverviewRoute());
                context
                    .read<AuthBloc>()
                    .add(const AuthEvent.authCheckRequested());
              },
            ),
            () {},
          );
        }
      },
      builder: (context, state) {
        // state.emailAddress.value.fold(
        //     (l) => print('log::bu:failed:$l.failedValue'),
        //     (r) => print('log::bu:right:$r'));
        nowState = state;

        return Form(
          autovalidateMode: state.showErrorMessages
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          key: _formKey,
          // autovalidateMode: AutovalidateMode.always,
          child: ListView(
            // ignore: prefer_const_literals_to_create_immutables
            padding: const EdgeInsets.all(16.0),
            children: [
              const Icon(
                Icons.access_alarms_outlined,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
                autocorrect: false,
                onChanged: (value) {
                  // print('onchange:$value');
                  context
                      .read<SignInFormBloc>()
                      .add(SignInFormEvent.emailChanged(value));
                },
                validator: (_) {
                  // print('see::now:$state');
                  // print('see::saved:$nowState');
                  // nowState?.emailAddress.value.fold(
                  //     (l) => print('log::va:failed:$l.failedValue'),
                  //     (r) => print('log::va:right:$r'));
                  return nowState!.emailAddress.value.fold(
                      (f) => f.maybeMap(
                          invalidEmail: (_) => 'Invalid Email',
                          orElse: () => null),
                      (r) => null);
                },
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => context
                    .read<SignInFormBloc>()
                    .add(SignInFormEvent.passwordChanged(value)),
                validator: (_) => nowState!.password.value.fold(
                    (f) => f.maybeMap(
                        shortPassword: (_) => 'Short Password',
                        orElse: () => null),
                    (r) => null),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<SignInFormBloc>().add(
                              const SignInWithEmailAndPassword(),
                            );
                      },
                      child: const Text('SIGN IN'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<SignInFormBloc>().add(
                              const RegisterWithEmailAndPassword(),
                            );
                      },
                      child: const Text('REGISTER'),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<SignInFormBloc>().add(
                        const SignInWithGoogle(),
                      );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlue),
                ),
                child: const Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              if (state.isSubmitting) ...[
                const SizedBox(
                  height: 8,
                ),
                const LinearProgressIndicator(),
              ]
            ],
          ),
        );
      },
    );
  }
}

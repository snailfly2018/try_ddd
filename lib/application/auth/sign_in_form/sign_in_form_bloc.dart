import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:try_ddd/domain/auth/auth_failure.dart';
import 'package:try_ddd/domain/auth/i_auth_facade.dart';
import 'package:try_ddd/domain/auth/value_objects.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  //给bloc一个初始化状态
  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<EmailChanged>(_onEmailChange);
    on<PasswordChanged>(_onPasssWordChange);
    on<RegisterWithEmailAndPassword>(_onRegisterWithEmailAndPassword);
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
  }

  //需要一个api的实现
  final IAuthFacade _authFacade;

  //bloc逻辑所在，收到一个event，发送一个state到流

  FutureOr<void> _onEmailChange(
      EmailChanged event, Emitter<SignInFormState> emit) {
    emit(
      state.copyWith(
        emailAddress: EmailAddress(event.emailStr),
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _onPasssWordChange(
      PasswordChanged event, Emitter<SignInFormState> emit) {
    emit(
      state.copyWith(
        password: Password(event.passwordStr),
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _onRegisterWithEmailAndPassword(
      RegisterWithEmailAndPassword event, Emitter<SignInFormState> emit) async {
    _performActionWithEmailAndPassword(
        _authFacade.registerWithEmailAndPassword, emit);
  }

  FutureOr<void> _onSignInWithEmailAndPassword(
      SignInWithEmailAndPassword event, Emitter<SignInFormState> emit) async {
    _performActionWithEmailAndPassword(
      _authFacade.signInWithEmailAndPassword,
      emit,
    );
  }

  Future<FutureOr<void>> _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<SignInFormState> emit) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ),
    );
    final failureOrSuccess = await _authFacade.signInWithGoogle();
    emit(
      state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOption: some(failureOrSuccess),
      ),
    );
  }

  FutureOr<void> _performActionWithEmailAndPassword(
      Future<Either<AuthFailure, Unit>> Function(
              {required EmailAddress emailAddress, required Password password})
          forwardedCall,
      Emitter<SignInFormState> emit) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      //开始行动
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ));

      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );

      // emit(state.copyWith(
      //   isSubmitting: false,
      //   showErrorMessages: true, //开始显示错误信息了
      //   //optionOf() 可以将null转换为none(),非null转为some()
      //   // optionOf is equivalent to:
      //   // failureOrSuccess == null ? none() : some(failureOrSuccess)
      //   authFailureOrSuccessOption: optionOf(failureOrSuccess),
      // ));
      print('api call return $failureOrSuccess');
    }
    //行动结束
    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: true, //开始显示错误信息了
      //optionOf() 可以将null转换为none(),非null转为some()
      // optionOf is equivalent to:
      // failureOrSuccess == null ? none() : some(failureOrSuccess)
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
    print('api call return $failureOrSuccess in the end');
  }
}

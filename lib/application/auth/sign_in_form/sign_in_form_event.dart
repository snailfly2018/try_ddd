part of 'sign_in_form_bloc.dart';

@freezed
class SignInFormEvent with _$SignInFormEvent {
  //一共五个事件
  const factory SignInFormEvent.emailChanged(String emailStr) = EmailChanged;
  const factory SignInFormEvent.passwordChanged(String passwordStr) = PasswordChanged;
  const factory SignInFormEvent.registerWithEmailAndPassword() = RegisterWithEmailAndPassword;
  const factory SignInFormEvent.signInWithEmailAndPassword() = SignInWithEmailAndPassword;
  const factory SignInFormEvent.signInWithGoogle() = SignInWithGoogle;
}
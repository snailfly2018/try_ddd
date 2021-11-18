part of 'sign_in_form_bloc.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required EmailAddress emailAddress,
    required Password password,
    //一开始并不显示错误信息，在第一次按button之前
    required bool showErrorMessages,
    //表示api正在运行中，该参数用户显示类loading界面
    required bool isSubmitting,
    //api返回的结果，Option是一种可空数据类型的很好包装，none表示空
    required Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption,
  }) = _SignInFormState;

//初始状态
  factory SignInFormState.initial() => SignInFormState(
    emailAddress: EmailAddress(''),
    password: Password(''),
    showErrorMessages: false,
    isSubmitting: false,
    authFailureOrSuccessOption: none()
  );
}

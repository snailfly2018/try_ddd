
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:try_ddd/domain/auth/auth_failure.dart';
import 'package:try_ddd/domain/auth/i_auth_facade.dart';
import 'package:try_ddd/domain/auth/value_objects.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  //给bloc一个初始化状态
  SignInFormBloc(this._authFacade) : super(SignInFormState.initial());

  //需要一个api的实现
  final IAuthFacade _authFacade;

  //bloc逻辑所在，收到一个event，发送一个state到流
  @override
  Stream<SignInFormState> mapEventToState(SignInFormEvent event) {
    // TODO: implement mapEventToState
    return super.mapEventToState(event);
  }

}

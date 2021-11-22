import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:try_ddd/domain/auth/i_auth_facade.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;
  AuthBloc(this._authFacade) : super(const Initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignedOut>(_onSignOut);
  }

  Future<FutureOr<void>> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    final userOption = await _authFacade.getSignedInUser();
    emit(userOption.match(
      (_) => const AuthState.authenticated(),
      () => const AuthState.unauthenticated(),
    ));
  }

  Future<FutureOr<void>> _onSignOut(SignedOut event, Emitter<AuthState> emit) async {
    await _authFacade.signOut();
        emit(const AuthState.unauthenticated());
  }

  // @override
  // Stream<AuthState> mapEventToState(
  //   AuthEvent event,
  // ) async* {
  //   yield* event.map(
  //     authCheckRequested: (e) async* {
  //       final userOption = await _authFacade.getSignedInUser();
  //       yield userOption.match(
  //         (_) => const AuthState.authenticated(),
  //         () => const AuthState.unauthenticated(),
  //       );
  //     },
  //     signedOut: (e) async* {
  //       await _authFacade.signOut();
  //       yield const AuthState.unauthenticated();
  //     },
  //   );
  // }

}

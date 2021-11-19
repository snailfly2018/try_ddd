import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:try_ddd/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:try_ddd/domain/auth/auth_failure.dart';
import 'package:try_ddd/domain/auth/i_auth_facade.dart';
import 'package:try_ddd/domain/auth/value_objects.dart';
import 'sign_in_form_bloc_test.mocks.dart';

@GenerateMocks([IAuthFacade])
void main() {
  group('sign_in_from_bloc', () {
    late SignInFormBloc signInFormBloc;
    late MockIAuthFacade mockIAuthFacade;

    const rightEmail = 'abc@gmail.com';
    const leftEmail = 'abc.com';
    const rightPassword = '123456';
    const shortPassword = '12345';

    Either<AuthFailure, Unit> rightUnit = right(unit);
    Either<AuthFailure, Unit> leftError =
        left(const AuthFailure.cancelledByUser());

    setUp(() {
      mockIAuthFacade = MockIAuthFacade();
      signInFormBloc = SignInFormBloc(mockIAuthFacade);
    });

    tearDown(() {
      signInFormBloc.close();
    });

  ///老派的写法也是很不错的
    test(
        'initial state then right email and right password and sign in at last',
        () async {
      when(mockIAuthFacade.signInWithEmailAndPassword(
              emailAddress: EmailAddress(rightEmail),
              password: Password(rightPassword)))
          .thenAnswer((_) async => rightUnit);

      expect(signInFormBloc.state, SignInFormState.initial());
      final expected = [
        SignInFormState.initial()
            .copyWith(emailAddress: EmailAddress(rightEmail)),
        SignInFormState.initial().copyWith(
          emailAddress: EmailAddress(rightEmail),
          password: Password(rightPassword),
        ),
        SignInFormState.initial().copyWith(
          emailAddress: EmailAddress(rightEmail),
          password: Password(rightPassword),
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState.initial().copyWith(
          emailAddress: EmailAddress(rightEmail),
          password: Password(rightPassword),
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: some(rightUnit),
        ),
      ];

      expectLater(signInFormBloc.stream, emitsInOrder(expected));
      signInFormBloc.add(const EmailChanged(rightEmail));
      signInFormBloc.add(const PasswordChanged(rightPassword));
      signInFormBloc.add(const SignInFormEvent.signInWithEmailAndPassword());

      await untilCalled(mockIAuthFacade.signInWithEmailAndPassword(
        emailAddress: EmailAddress(rightEmail),
        password: Password(rightPassword),
      ));
      verify(mockIAuthFacade.signInWithEmailAndPassword(
        emailAddress: EmailAddress(rightEmail),
        password: Password(rightPassword),
      )).called(1);
    });

    blocTest<SignInFormBloc, SignInFormState>(
      'email changed',
      build: () => signInFormBloc,
      act: (bloc) {
        bloc.add(const EmailChanged(rightEmail));
      },
      seed: () => SignInFormState.initial(),
      expect: () => [
        SignInFormState.initial()
            .copyWith(emailAddress: EmailAddress(rightEmail))
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'password changed',
      build: () => signInFormBloc,
      act: (bloc) {
        bloc.add(const PasswordChanged(shortPassword));
      },
      seed: () => SignInFormState.initial(),
      expect: () => [
        SignInFormState.initial().copyWith(password: Password(shortPassword))
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'signIn with error email address',
      build: () => signInFormBloc,
      act: (bloc) {
        bloc.add(const SignInWithEmailAndPassword());
      },
      seed: () => SignInFormState.initial()
          .copyWith(emailAddress: EmailAddress(leftEmail)),
      expect: () => [
        SignInFormState.initial().copyWith(
          emailAddress: EmailAddress(leftEmail),
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: none(),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'signIn with right email address and right password',
      setUp: () {
        when(mockIAuthFacade.signInWithEmailAndPassword(
                emailAddress: EmailAddress(rightEmail),
                password: Password(rightPassword)))
            .thenAnswer((_) async => rightUnit);
      },
      build: () => signInFormBloc,
      act: (bloc) {
        bloc.add(const SignInWithEmailAndPassword());
      },
      seed: () => SignInFormState.initial().copyWith(
        emailAddress: EmailAddress(rightEmail),
        password: Password(rightPassword),
      ),
      // verify: (_) async{
      //   verify(() => mockIAuthFacade.signInWithEmailAndPassword(
      //         emailAddress: EmailAddress(rightEmail),
      //         password: Password(rightPassword),
      //       )).called(1);
      // },
      expect: () => [
        SignInFormState.initial().copyWith(
          emailAddress: EmailAddress(rightEmail),
          password: Password(rightPassword),
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState.initial().copyWith(
          emailAddress: EmailAddress(rightEmail),
          password: Password(rightPassword),
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: some(rightUnit),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'register with error email address',
      build: () => signInFormBloc,
      act: (bloc) {
        bloc.add(const RegisterWithEmailAndPassword());
      },
      seed: () => SignInFormState.initial()
          .copyWith(emailAddress: EmailAddress(leftEmail)),
      expect: () => [
        SignInFormState.initial().copyWith(
          emailAddress: EmailAddress(leftEmail),
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: none(),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'register with right email address and right password',
      setUp: () {
        when(mockIAuthFacade.registerWithEmailAndPassword(
                emailAddress: EmailAddress(rightEmail),
                password: Password(rightPassword)))
            .thenAnswer((_) async => rightUnit);
      },
      build: () => signInFormBloc,
      act: (bloc) {
        bloc.add(const RegisterWithEmailAndPassword());
      },
      seed: () => SignInFormState.initial().copyWith(
        emailAddress: EmailAddress(rightEmail),
        password: Password(rightPassword),
      ),
      expect: () => [
        SignInFormState.initial().copyWith(
          emailAddress: EmailAddress(rightEmail),
          password: Password(rightPassword),
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState.initial().copyWith(
          emailAddress: EmailAddress(rightEmail),
          password: Password(rightPassword),
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: some(rightUnit),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'signIn with Google succeed',
      setUp: () {
        when(mockIAuthFacade.signInWithGoogle())
            .thenAnswer((_) async => rightUnit);
      },
      build: () => signInFormBloc,
      act: (bloc) {
        bloc.add(const SignInWithGoogle());
      },
      seed: () => SignInFormState.initial(),
      expect: () => [
        SignInFormState.initial().copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState.initial().copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(rightUnit),
        )
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'signIn with Google failure',
      setUp: () {
        when(mockIAuthFacade.signInWithGoogle())
            .thenAnswer((_) async => leftError);
      },
      build: () => signInFormBloc,
      act: (bloc) {
        bloc.add(const SignInWithGoogle());
      },
      seed: () => SignInFormState.initial(),
      expect: () => [
        SignInFormState.initial().copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState.initial().copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(leftError),
        )
      ],
    );
  });
}

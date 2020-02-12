import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../message/message.dart';
import '../../repository/abstract/signin_repository.dart';
import 'bloc.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc({this.repository});

  final SigninRepository repository;

  @override
  SigninState get initialState => InitialSignin();

  @override
  Stream<SigninState> mapEventToState(SigninEvent event) async* {
    if (event is SigninTried) {
      yield SigninLoading();
      try {
        final user = await repository.signInWithEmailAndPassword(
            event.email, event.password);

        if (user != null) {
          yield UserAuthenticated(user);
        } else {
          yield UserAuthenticationFailed(ERROR_AUTENTICATING_USER);
        }
      } on Exception catch (e) {
        yield SigninFailed(e.toString());
      }
    }
  }
}

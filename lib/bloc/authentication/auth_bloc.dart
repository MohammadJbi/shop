import 'package:apple_shop_application/bloc/authentication/auth_event.dart';
import 'package:apple_shop_application/bloc/authentication/auth_state.dart';
import 'package:apple_shop_application/data/repository/authentication_repository.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthenRepository _repository = locator.get();

  AuthBloc() : super(AuthInitiateState()) {
    on<AuthLoginRequest>(
      (event, emit) async {
        emit(
          AuthLoadingState(),
        );
        var response = await _repository.login(event.username, event.password);
        emit(
          AuthResponseState(response),
        );
      },
    );
    on<AuthRegisterRequest>(
      (event, emit) async {
        emit(
          AuthLoadingState(),
        );
        var response = await _repository.register(
          event.username,
          event.password,
          event.passwordConfirm,
        );
        emit(
          AuthResponseState(response),
        );
      },
    );
  }
}

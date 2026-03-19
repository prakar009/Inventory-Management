import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_service.dart';
import '../../models/user_model.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final AppUser user = await authService.login(
          event.email,
          event.password,
        );

        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final AppUser user = await authService.register(
          event.email,
          event.password,
          event.role,
        );

        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authService.logout();
      emit(AuthInitial());
    });
  }
}
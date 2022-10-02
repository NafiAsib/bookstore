import 'package:bloc/bloc.dart';
import 'package:bookstore/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<GoogleSignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.googleSignIn();
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(errorMsg: e.toString()));
        emit(UnAuthenticated());
      }
    });
    on<SignOut>(((event, emit) async {
      emit(AuthLoading());
      await authRepository.signOut();
      emit(UnAuthenticated());
    }));
  }
}

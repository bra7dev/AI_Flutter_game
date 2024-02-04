import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/authentication/repo/auth_repository.dart';

enum SplashState {
  none,
  unauthenticated,
  authenticated,
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._authRepository) : super(SplashState.none);
  final AuthRepository _authRepository;

  void init() async {
    await Future.delayed(const Duration(seconds: 2));
    bool isAuthenticated = _authRepository.isAuthenticated();

    if (isAuthenticated) {
      // init session
      await _authRepository.getUser();
      emit(SplashState.authenticated);
    } else {
      emit(SplashState.unauthenticated);
    }
  }
}

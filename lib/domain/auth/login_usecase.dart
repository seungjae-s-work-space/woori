// lib/domain/auth/login_usecase.dart

import 'auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  /// 로그인 로직, 토큰을 반환한다고 가정
  Future<String> call(String email, String password) async {
    return await _authRepository.login(email, password);
  }
}

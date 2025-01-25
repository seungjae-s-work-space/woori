// lib/domain/auth/sign_up_usecase.dart

import 'auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  /// 회원가입 로직
  Future<void> call(String email, String password) async {
    // 추가 유효성 검증, 비즈니스 로직 등을 여기에 넣을 수 있음
    await _authRepository.signUp(email, password);
  }
}

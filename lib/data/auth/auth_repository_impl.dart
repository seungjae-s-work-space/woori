// lib/data/auth/auth_repository_impl.dart

import '../../domain/auth/auth_repository.dart';
import 'auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl(this._authApi);

  @override
  Future<void> signUp(String email, String password) async {
    // 실제 서버 통신 호출
    await _authApi.signUp(email, password);
  }

  @override
  Future<String> login(String email, String password) async {
    final response = await _authApi.login(email, password);
    return response.token; // 서버에서 받은 token
  }
}

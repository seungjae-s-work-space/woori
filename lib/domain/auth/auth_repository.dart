abstract class AuthRepository {
  /// 회원가입
  Future<void> signUp(String email, String password);

  /// 로그인하면 서버에서 토큰을 받아온다고 가정
  Future<String> login(String email, String password);
}

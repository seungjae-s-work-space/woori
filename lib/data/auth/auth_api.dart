// lib/data/auth/auth_api.dart

import 'package:dio/dio.dart';
import 'dto/login_request.dart';
import 'dto/login_response.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<void> signUp(String email, String password) async {
    // POST /auth/signup
    print('pw');
    await dio.post('/auth/signup', data: {
      'email': email,
      'password': password,
    });
    // 서버에서 { message: '회원가입 성공', ... } 식으로 응답한다고 가정
  }

  Future<LoginResponse> login(String email, String password) async {
    // POST /auth/login
    final response = await dio.post('/auth/login',
        data: LoginRequest(email: email, password: password).toJson());

    // 서버에서 { message: '로그인 성공', token: '...' }라고 응답한다고 가정
    return LoginResponse.fromJson(response.data);
  }
}

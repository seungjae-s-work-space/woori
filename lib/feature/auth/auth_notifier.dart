// lib/presentation/auth/auth_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/auth/login_usecase.dart';
import '../../domain/auth/signup_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LoginUseCase _loginUseCase;

  AuthNotifier(this._signUpUseCase, this._loginUseCase) : super(AuthState());

  // 회원가입
  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _signUpUseCase(email, password);
      // 회원가입 성공 -> 별다른 응답이 없다면, 그냥 로딩 false로
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 로그인
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _loginUseCase(email, password);
      // 로그인 성공 -> token을 상태에 저장
      state = state.copyWith(token: token);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 로그아웃
  void logout() {
    state = state.copyWith(token: null);
  }
}

// lib/presentation/auth/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../data/auth/auth_api.dart';
import '../../data/auth/auth_repository_impl.dart';
import '../../domain/auth/login_usecase.dart';
import '../../domain/auth/signup_usecase.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

// 1) Dio Provider
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
});

// 2) AuthApi Provider
final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.read(dioProvider);
  return AuthApi(dio);
});

// 3) Repository Impl
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final api = ref.read(authApiProvider);
  return AuthRepositoryImpl(api);
});

// 4) UseCases
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return SignUpUseCase(repo);
});
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUseCase(repo);
});

// 5) AuthNotifier Provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final signUpUC = ref.read(signUpUseCaseProvider);
  final loginUC = ref.read(loginUseCaseProvider);
  return AuthNotifier(signUpUC, loginUC);
});

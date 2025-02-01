// lib/presentation/auth/auth_state.dart

class AuthState {
  final bool isLoading;
  final String? token;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.token,
    this.error,
  });

  // copyWith (필요하면 직접 구현)
  AuthState copyWith({
    bool? isLoading,
    String? token,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      error: error ?? this.error,
    );
  }
}

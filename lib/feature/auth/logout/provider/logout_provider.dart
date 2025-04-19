// lib/feature/auth/logout/logout_provider.dart
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/data/secure_storage/secure_storage_repository.dart';
import 'package:woori/utils/router/router.dart';
import 'package:woori/utils/talker.dart';

final logoutProvider =
    StateNotifierProvider<LogoutNotifier, LogoutState>((ref) {
  final api = ref.read(restApiClientProvider);
  final storage = ref.read(secureStorageRepositoryProvider);
  return LogoutNotifier(ref, api, storage); // ref 주입
});

class LogoutNotifier extends StateNotifier<LogoutState> {
  LogoutNotifier(this._ref, this._api, this._storage)
      : super(const LogoutState.idle());

  final Ref _ref;
  final RestApiClient _api;
  final SecureStorageRepository _storage;

  Future<void> logout() async {
    try {
      state = const LogoutState.loading();

      // 1) 서버 토큰 폐기
      final token = await _storage.readString('token');
      if (token != null) {
        await _api.post(
          'auth/logout',
          {},
        );
      }

      // 2) 로컬 토큰 삭제
      await _storage.deleteString('token');
      final ctx = navigatorKey.currentContext;
      if (ctx != null) Phoenix.rebirth(ctx); // 🔥 핵심 한 줄

      state = const LogoutState.success();
      talkerInfo('logout_provider', 'Logout success');
    } catch (e) {
      talkerError('logout_provider', 'Logout failed', e);
      state = LogoutState.error(e.toString());
      rethrow;
    }
  }
}

/// 로그아웃 상태 모델  ────────────────────────────────
class LogoutState {
  final LogoutStatus status;
  final String? message;

  const LogoutState._(this.status, [this.message]);

  const LogoutState.idle() : this._(LogoutStatus.idle);
  const LogoutState.loading() : this._(LogoutStatus.loading);
  const LogoutState.success() : this._(LogoutStatus.success);
  const LogoutState.error(String msg) : this._(LogoutStatus.error, msg);
}

enum LogoutStatus { idle, loading, success, error }

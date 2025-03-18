import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/data/secure_storage/secure_storage_repository.dart';
import 'package:woori/utils/talker.dart';
import 'package:dio/dio.dart';

/// 요청 응답 인터셉터 입니다.
/// 자동으로 토큰을 갱신하고 토큰 유효성 검사를 진행합니다.
class DioInterceptor extends Interceptor {
  /// storage 저장소와 api 클라이언트를 주입받습니다.
  DioInterceptor(this._secureStorageRepository, this._apiClient);
  final RestApiClient _apiClient;
  final SecureStorageRepository _secureStorageRepository;

  /// 토큰 갱신 중 중복 갱신 방지를 위한 변수
  bool isTokenRefresh = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    talkerLog(
      'DioInterceptor',
      'REQUEST: [${options.method}] => PATH: ${options.path}',
    );

    // 토큰이 필요없는 public API 경로
    // 현재 임시값 입니다. 실제 경로로 수정해주세요
    final publicPaths = [
      // 'auth/signup',
      // 'auth/login',
    ];

    if (!publicPaths.contains(options.path)) {
      try {
        final token = await _secureStorageRepository.readString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          talkerError('DioInterceptor(onRequest)', 'Token is null', 'error');
        }
      } on Exception catch (e) {
        talkerError(
          'DioInterceptor(onRequest)',
          'Error reading token: ',
          'error: $e',
        );
      }
    }

    handler.next(
      options,
    );

    /// 요청이 무한 대기 상태를 방지하기 위해 path조건과 무관하기 적용시킴.
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.headers.map['X-Token-Refresh-Required']?.first == 'true') {
      try {
        // 토큰 갱신이 진행 중이면 스킵

        if (!isTokenRefresh) {
          isTokenRefresh = true;
          talkerLog('DioInterceptor(onResponse)', 'try to refresh token');
          final Map<String, dynamic> refreshTokenResponse =
              await _apiClient.post(
            'auth/refresh-token',
            null, // 여기가 null인 이유는 토큰 갱신에는 바디가 필요없습니다
          );
          if (refreshTokenResponse['statusCode'] == 200) {
            await _secureStorageRepository.writeString(
              'token',

              /// 받는타입을 벗기는 작업을 린트룰대로 하게되면 코드가 더 지저분해짐 그래서 여기는 수정안하겠습니다
              refreshTokenResponse['data']['token'],
            );
          }
          isTokenRefresh = false;
        }
      } on Exception catch (e) {
        isTokenRefresh = false;
        talkerError(
          'DioInterceptor(onResponse)',
          'Error refreshing token: ',
          e,
        );
      }
    }
    talkerLog(
      'DioInterceptor(onResponse)',
      'RESPONSE: [${response.statusCode}] => '
          'PATH: ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  /// 토큰 갱신 실패 시 에러 처리
  Future<void> handleTokenRefreshError(dynamic error) async {
    if (error is DioException) {
      if (error.response?.statusCode == 500) {
        talkerError('TokenRefreshError', 'Server error', error);

        return;
      }
    }
    talkerError('TokenRefreshError', 'Authentication failed', error);
    await _secureStorageRepository.deleteString('token');

    ///  TODO: 로그인 화면으로 이동하는 로직이 필요합니다. 현재는 예시로 콘솔에만 출력하고, 추후 수정이 필요합니다.
    /// 아직 토큰을 사용하는 모든 케이스가 존재하지 않습니다.
    /// 임의 테스트로 이동하게 처리 하더라도 실제 로직이 정확하게 작동하는지 테스트가 어렵습니다.
    /// 추후 모든 Task가 완성되고 점차적으로 수정 예정입니다.
  }
}

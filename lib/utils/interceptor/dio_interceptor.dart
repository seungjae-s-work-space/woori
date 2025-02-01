import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:woori/data/secure_storage/secure_storage_repository.dart';
import 'package:woori/utils/talker.dart';

class DioInterceptor extends Interceptor {
  final SecureStorageRepository _secureStorageRepository;
  final String _tokenKey = dotenv.env['TOKEN_KEY'] ?? 'auth_token';

  DioInterceptor(this._secureStorageRepository);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    talkerLog("DioInterceptor",
        "REQUEST: [${options.method}] => PATH: ${options.path}");

    // 토큰이 필요없는 public API 경로
    // 현재 임시값 입니다. 실제 경로로 수정해주세요
    final publicPaths = [
      'auth/signup',
    ];

    if (!publicPaths.contains(options.path)) {
      try {
        final token = await _secureStorageRepository.readString(_tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          talkerError("DioInterceptor(onRequest)", "Token is null", 'error');
        }
      } catch (e) {
        talkerError(
            "DioInterceptor(onRequest)", "Error reading token: ", 'error: $e');
      }
    }
    // el xse {
    handler.next(
        options); //요청이 무한 대기 상태를 방지하기 위해 path조건과 무관하기 적용시킴. 토큰필요경로일때 handler.next(options), handler.resolve(...), handler.reject(...) 등으로 필요에맞게 분리해서 적용 가능
    // }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    talkerLog("DioInterceptor(onResponse)",
        "RESPONSE: [${response.statusCode}] => PATH: ${response.requestOptions.path}");
    handler.next(response);
  }
}

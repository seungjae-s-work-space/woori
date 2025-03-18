import 'package:woori/data/secure_storage/secure_storage_repository.dart';
import 'package:woori/utils/interceptor/dio_interceptor.dart';
import 'package:woori/utils/interceptor/error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/rest_api_client.g.dart';

/// http 통신 / 인터셉터 처리를 위한 생성자 프로바이더
final restApiClientProvider = Provider<RestApiClient>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get('BASE_TEST_URL'),
      contentType: 'application/json',
    ),
  );

  final client = RestApiClient(dio);

  dio.interceptors.addAll([
    DioInterceptor(ref.read(secureStorageRepositoryProvider), client),
    ErrorInterceptor(),
  ]);

  return client;
});

@RestApi()

/// HTTP 통신을 위한 레트로핏 클라이언트 추상클래스
/// 현재 전체 통신을 규격화 하기위해 Path를 통한 Query 처리는 사용하지 않음
abstract class RestApiClient {
  /// 레트로핏 클라이언트 생성자
  factory RestApiClient(Dio dio) = _RestApiClient;

  /// GET 요청 함수
  @GET('{endpoint}')
  Future<dynamic> get(@Path('endpoint') String endpoint, @Body() dynamic body);

  /// POST 요청 함수
  @POST('{endpoint}')
  Future<dynamic> post(@Path('endpoint') String endpoint, @Body() dynamic body);

  /// PUT 요청 함수
  @PUT('{endpoint}')
  Future<dynamic> put(@Path('endpoint') String endpoint, @Body() dynamic body);

  /// DELETE 요청 함수
  @DELETE('{endpoint}')
  Future<dynamic> delete(
    @Path('endpoint') String endpoint,
    @Body() dynamic body,
  );
}

import 'package:woori/data/secure_storage/secure_storage_repository.dart';
import 'package:woori/utils/interceptor/dio_interceptor.dart';
import 'package:woori/utils/interceptor/error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/rest_api_client.g.dart';

final restApiClientProvider = Provider<RestApiClient>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_TEST_URL'] ?? '',
    contentType: 'application/json',
  ))
    ..interceptors
        .add(DioInterceptor(ref.read(secureStorageRepositoryProvider)))
    ..interceptors.add(ErrorInterceptor());

  return RestApiClient(dio);
});

@RestApi()
abstract class RestApiClient {
  factory RestApiClient(Dio dio) = _RestApiClient;

  @GET('{endpoint}')
  Future<dynamic> get(@Path('endpoint') String endpoint);

  @POST('{endpoint}')
  Future<dynamic> post(@Path('endpoint') String endpoint, @Body() dynamic body);

  @PUT('{endpoint}')
  Future<dynamic> put(@Path('endpoint') String endpoint, @Body() dynamic body);

  @DELETE('{endpoint}')
  Future<dynamic> delete(@Path('endpoint') String endpoint);
}

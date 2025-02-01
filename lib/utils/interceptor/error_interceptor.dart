import 'package:dio/dio.dart';
import 'package:woori/models/api_error_response_model.dart';
import 'package:woori/utils/talker.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    talkerError(
        "ErrorInterceptor(onError)",
        "ERROR: [${err.requestOptions.method}] => PATH: ${err.requestOptions.path}",
        'error: ${err.error}');

    final errorResponse = err.response?.data != null
        ? ApiErrorResponseModel.fromJson(err.response!.data)
        : const ApiErrorResponseModel(
            errorCode: 'errorCode_public001',
            message: 'Fail',
          );
    final error = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorResponse,
    );

    handler.next(error);
  }
}

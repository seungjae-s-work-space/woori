import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:woori/models/api_error_response_model.dart';
import 'package:woori/utils/localization_extension.dart';

extension ErrorCodeExtension on DioException {
  String getErrorMessage(BuildContext context) {
    final errorResponse = error as ApiErrorResponseModel;
    switch (errorResponse.errorCode) {
      // Public
      case 'errorCode_public001':
        return context.l10n.errorCode_public001;

      // Auth
      case 'errorCode_auth001':
        return context.l10n.errorCode_auth001;
      case 'errorCode_auth002':
        return context.l10n.errorCode_auth002;
      case 'errorCode_auth003':
        return context.l10n.errorCode_auth003;
      case 'errorCode_auth004':
        return context.l10n.errorCode_auth004;
      case 'errorCode_auth005':
        return context.l10n.errorCode_auth005;
      case 'errorCode_auth006':
        return context.l10n.errorCode_auth006;
      case 'errorCode_auth007':
        return context.l10n.errorCode_auth007;
      case 'errorCode_auth008':
        return context.l10n.errorCode_auth008;
      case 'errorCode_auth009':
        return context.l10n.errorCode_auth009;

      case 'errorCode_user001':
        return context.l10n.errorCode_user001;

      // // Category
      // case 'errorCode_category001':
      //   return context.l10n.errorCode_category001;
      // case 'errorCode_category002':
      //   return context.l10n.errorCode_category002;
      // case 'errorCode_category003':
      //   return context.l10n.errorCode_category003;
      // case 'errorCode_category004':
      //   return context.l10n.errorCode_category004;
      // case 'errorCode_category005':
      //   return context.l10n.errorCode_category005;
      // case 'errorCode_category006':
      //   return context.l10n.errorCode_category006;
      // case 'errorCode_category007':
      //   return context.l10n.errorCode_category007;
      // case 'errorCode_category008':
      //   return context.l10n.errorCode_category008;
      // case 'errorCode_category009':
      //   return context.l10n.errorCode_category009;
      // case 'errorCode_category010':
      //   return context.l10n.errorCode_category010;
      // case 'errorCode_category011':
      //   return context.l10n.errorCode_category011;

      default:
        return context.l10n.errorCode_public001;
    }
  }
}

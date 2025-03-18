import 'dart:convert';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/data/secure_storage/secure_storage_repository.dart';
import 'package:woori/dto/update_user_info_dto.dart';
import 'package:woori/models/user_model.dart';
import 'package:woori/utils/talker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
  토큰을 사용해 유저정보를 요청하고 가져온 유저를 업데이트 해줍니다.
  Notifier안에 실행함수로 getUser를 호출해서 Provider가 스크린에서 호출되었을때
  즉각적인 요청을 통해 리스너를 달아서 자동로그인 처리를 구현하였습니다.
  참조는 auth_gate_screen의 화면을 확인하시면 listener의 구현을 확인 하실 수 있습니다.

  유저 정보 업데이트 함수같은 경우에는 저장해둔 모델(UserModel)과
  받은 DTO(UpdateUserInfoDTO)의 type 차이가 있어 json 으로 변환 후 바뀐 내용을
  스프레드 연산자로 업데이트하고 업데이트 된 json 으로 state 의 model 을 업데이트 해줍니다.
*/

final userProfileProvider =
    StateNotifierProvider.autoDispose<UserProfileNotifier, UserProfileState>(
        (ref) {
  final apiClientRepository = ref.read(restApiClientProvider);
  final secureStorageRepository = ref.read(secureStorageRepositoryProvider);
  return UserProfileNotifier(apiClientRepository, secureStorageRepository);
});

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  UserProfileNotifier(this._apiClient, this._secureStorage)
      : super(UserProfileState()) {
    getUser();
  }
  final RestApiClient _apiClient;
  final SecureStorageRepository _secureStorage;

  Future<void> getUser() async {
    try {
      final token = await _secureStorage.readString('token');
      if (token != null) {
        final Map<String, dynamic> response =
            await _apiClient.get('user/get-user', {});

        talkerInfo('GetUserNotifier(getUser1)', jsonEncode(response));

        state =
            UserProfileState(userModel: UserModel.fromJson(response['data']));

        talkerInfo('GetUserNotifier(getUser)', state.userModel.toString());
      } else {
        state = UserProfileState();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UpdateUserInfoDTO updateUserInfoDTO) async {
    try {
      state = state.copyWith(isLoading: true); // 로딩 시작

      final response =
          await _apiClient.post('user/update-user', updateUserInfoDTO);

      talkerInfo('GetUserNotifier(update user)', jsonEncode(response));

      if (response['message'] == 'Success') {
        final updatedUserJson = updateUserInfoDTO.toJson(); // DTO json 변환
        final completeUserJson = {
          ...state.userModel!.toJson(), // 기존 유저 모델 json 변환
          ...updatedUserJson, // DTO 내용 업데이트
        };

        // 모델 업데이트 및 확인
        state =
            UserProfileState(userModel: UserModel.fromJson(completeUserJson));
        talkerInfo('GetUserNotifier(getUser)', state.userModel.toString());
      }
    } catch (e) {
      talkerError('GetUserNotifier(update user)', '유저 정보 업데이트 실패', e);
      rethrow;
    } finally {
      // 예외 발생 여부와 관계없이 로딩 상태를 종료합니다.
      state = state.copyWith(isLoading: false);
    }
  }
}

class UserProfileState {
  UserProfileState({this.userModel, this.isLoading = false});
  UserModel? userModel;
  bool isLoading;

  UserProfileState copyWith({
    UserModel? userModel,
    bool? isLoading,
  }) =>
      UserProfileState(
        userModel: userModel ?? this.userModel,
        isLoading: isLoading ?? this.isLoading,
      );
}

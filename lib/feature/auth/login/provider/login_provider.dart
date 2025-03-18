import 'dart:convert';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/data/secure_storage/secure_storage_repository.dart';
import 'package:woori/dto/login_dto.dart';
import 'package:woori/utils/talker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 로그인을 위한 프로바이더
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final apiClientRepository = ref.read(restApiClientProvider);
  final secureStorageRepository = ref.read(secureStorageRepositoryProvider);
  return LoginNotifier(apiClientRepository, secureStorageRepository);
});

/// 스크린에서 로그인에 필요한 데이터를 updateDto로 업데이트하고
/// 최종적으로는 각 함수의 post요청을 서버로 전달
/// 아래 에러처리가 rethrow되어 있는 이유는 UI에서 에러처리를 위한 dialog를 띄우기 위함

/// getRestaurantTableInfo 함수는 로그인시 테이블 정보를 가져와서 저장합니다.
/// 그리고 이 후 selectedLoleScreen에서
/// login 함수를 호출해서 기본정보와 / 로그인을 시도 할 role의 데이터를 입력받아 로그인을 시도합니다.
class LoginNotifier extends StateNotifier<LoginState> {
  /// LoginNotifier 생성자
  LoginNotifier(this._apiClient, this._secureStorage) : super(LoginState());
  final RestApiClient _apiClient;
  final SecureStorageRepository _secureStorage;

  /// 로그인 정보를 업데이트하는 함수
  void updateLogInDto(LoginDto loginDto) {
    state = state.copyWith(loginDto: loginDto);
    talkerInfo('loginProvider', state.loginDto.toString());
  }

  /// 유저 역할 정보를 업데이트하는 함수
  // void updateUserRoleDto(UserRoleDto roleDto) {
  //   final updatedState = state.copyWith(userRoleDto: roleDto);

  //   /// LoginDto의 roles 필드도 함께 업데이트
  //   final updatedLoginDto = state.loginDto?.copyWith(roles: roleDto);

  //   /// 둘 다 한번에 업데이트
  //   state = updatedState.copyWith(loginDto: updatedLoginDto);
  //   talkerInfo('loginProvider', state.userRoleDto.toString());
  //   talkerInfo('loginProvider', state.loginDto.toString());
  // }

  // /// 테이블 정보를 가져오는 함수
  // Future<void> getRestaurantTableInfo(LoginDto loginDto) async {
  //   try {
  //     talkerInfo('loginProvider', loginDto.toString());
  //     final Map<String, dynamic> loginResponse = await _apiClient
  //         .get('auth/get-table-count', {'email': loginDto.email});
  //     talkerInfo('loginProvider', jsonEncode(loginResponse));

  //     final updatedLoginDto = loginDto.copyWith(
  //       totalTableCount: loginResponse['data']['tableCount'] as int,
  //     );

  //     talkerInfo('loginProvider(loginDto)', updatedLoginDto.toString());

  //     state = state.copyWith(loginDto: updatedLoginDto);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  /// 로그인 함수
  Future<void> login() async {
    try {
      talkerInfo('login', state.loginDto.toString());

      final Map<String, dynamic> loginResponse =
          await _apiClient.post('auth/login', state.loginDto);

      talkerInfo('login', jsonEncode(loginResponse));

      final data = loginResponse['data'] as Map<String, dynamic>;
      final token = data['token'];
      if (token is! String) {
        throw Exception('Invalid token type in response');
      }
      await _secureStorage.writeString('token', token);
      // final storedToken = await _secureStorage.readString('token');
      // print('Stored Token: $storedToken'); // 토큰이 잘 저장되었는지 확인
    } catch (e) {
      talkerInfo('login_error', e.toString());
      rethrow;
    }
  }

  // /// 로그아웃 함수
  // Future<void> logout() async {
  //   try {
  //     /// 빈 배열을 보내고 서버에서 로그아웃 처리, 토큰은 어차피 자동으로 인터셉터에서 추가 해서 요청을 보냄
  //     final response = await _apiClient.delete('auth/logout', {});

  //     talkerInfo('logout', jsonEncode(response));

  //     /// 자동인가 처리때문에 로컬에서도 토큰을 삭제처리 해줘야함
  //     await _secureStorage.deleteString('token');
  //   } on Exception catch (e) {
  //     /// 아래 주석 메세지를 확인하시면 왜 rethrow 하지 않는지 알 수 있습니다.
  //     talkerError('LoginProvider(logout)', '로그아웃 처리 중 에러 발생', e);
  //   } finally {
  //     /// 로그아웃 처리에서 서버에서 에러가 발생하더라도 로컬에서는 일단 요청을 보낸 부분이기 때문에
  //     /// 로컬에서 토큰을 삭제처리 하고 로직은 정상 작동하는 것 처럼 보이게 해야함
  //     await _secureStorage.deleteString('token');
  //   }
  // }
}

/// 로그인 상태 클래스
class LoginState {
  /// LoginState 생성자
  // LoginState({this.loginDto, this.userRoleDto});
  LoginState({this.loginDto});

  /// 로그인 처리를 위한 DTO
  LoginDto? loginDto;

  // /// 유저 역할 정보를 위한 DTO
  // UserRoleDto? userRoleDto;

  /// 로그인 상태 복사 함수
  LoginState copyWith({
    LoginDto? loginDto,
    // UserRoleDto? userRoleDto,
  }) =>
      LoginState(
        loginDto: loginDto ?? this.loginDto,
        // userRoleDto: userRoleDto ?? this.userRoleDto,
      );
}

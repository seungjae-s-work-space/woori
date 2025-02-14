import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/dto/sign_up_dto.dart';
import 'package:woori/utils/talker.dart';

/* 회원가입을 위한 프로바이더
   스크린에서 가입에 필요한 데이터를 updateDto로 업데이트하고
   최종적으로는 post요청을 서버로 전달
   아래 에러처리가 rethrow되어 있는 이유는 UI에서 에러처리를 위한 dialog를 띄우기 위함
 */

final signUpProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  // <상태관리클래스,상태데이터클래스> 왼쪽껀 상태를 변경하는 역할, 오른쪽건 상태담는역할
  final apiClientRepository = ref.read(restApiClientProvider);
  return SignUpNotifier(apiClientRepository);
});

class SignUpNotifier extends StateNotifier<SignUpState> {
  final RestApiClient _apiClient;
  SignUpNotifier(this._apiClient) : super(SignUpState());

  void updateDto(SignUpDto signUpDto) {
    //state 는 StateNotifier 클래스에서 제공하는 내장 변수입니다.
    state = SignUpState(
        signUpDto:
            signUpDto); //제너릭에SignUpState, 내부적으로 state 변수를 통해 현재 상태를 관리합니다.
/*StateNotifier.state 변경  
    ↓            
Riverpod UI 리빌드  
*/
  }

  Future<void> signUp(SignUpDto signUpDto) async {
    try {
      talkerInfo("signUpProvider", signUpDto.toString());
      final signUpResponse = await _apiClient.post('auth/signup', signUpDto);
      talkerInfo("signUpProvider", signUpResponse.toString());
    } catch (e) {
      // 에러처리는 스크린에서 errorDialog가 나오게 설정 되어있으니 여기서는 UI로 던져줍니다.
      rethrow;
    }
  }
}

class SignUpState {
  SignUpDto? signUpDto;

  SignUpState({
    this.signUpDto,
  });
}

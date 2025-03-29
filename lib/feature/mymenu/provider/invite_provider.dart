import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/dto/invite_dto.dart';
import 'package:woori/utils/talker.dart';
import 'package:share_plus/share_plus.dart';

final inviteProvider =
    StateNotifierProvider<InviteNotifier, AsyncValue<InviteListResponseDto>>(
        (ref) {
  final apiClient = ref.read(restApiClientProvider);
  return InviteNotifier(apiClient);
});

class InviteNotifier extends StateNotifier<AsyncValue<InviteListResponseDto>> {
  InviteNotifier(this._apiClient) : super(const AsyncValue.loading());

  final RestApiClient _apiClient;

  Future<void> loadInvitesFromMe() async {
    try {
      state = const AsyncValue.loading();
      final response = await _apiClient.get('invite/from-me', {});
      final inviteResponse = InviteListResponseDto.fromJson(response['data']);
      state = AsyncValue.data(inviteResponse);
    } catch (e) {
      talkerError('invite_provider', '내가 초대한 사람 목록 조회 실패', e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadInvitesToMe() async {
    try {
      state = const AsyncValue.loading();
      final response = await _apiClient.get('invite/to-me', {});
      final inviteResponse = InviteListResponseDto.fromJson(response['data']);
      state = AsyncValue.data(inviteResponse);
    } catch (e) {
      talkerError('invite_provider', '나를 초대한 사람 목록 조회 실패', e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createInviteLink() async {
    try {
      final response = await _apiClient.post('invite/invite-link', {});
      final inviteLinkResponse =
          InviteLinkResponseDto.fromJson(response['data']);

      try {
        await Share.share(
          inviteLinkResponse.inviteUrl,
          subject: '우리 앱 초대 링크',
        );
      } catch (shareError) {
        talkerError('invite_provider', '공유 기능 실행 실패', shareError);
        // 공유 실패 시에도 초대 링크는 생성되었으므로 에러를 던지지 않습니다
      }
    } catch (e) {
      talkerError('invite_provider', '초대 링크 생성 실패', e);
      rethrow;
    }
  }

  Future<void> deleteInvite(String inviteId) async {
    try {
      await _apiClient.delete('invite/$inviteId', {});
      await loadInvitesFromMe(); // 목록 새로고침
    } catch (e) {
      talkerError('invite_provider', '초대 삭제 실패', e);
      rethrow;
    }
  }
}

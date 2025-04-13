import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/dto/invite_dto.dart';
import 'package:woori/utils/talker.dart';
import 'package:share_plus/share_plus.dart';

/// "내가 초대한 사람" 목록을 전담
final invitesFromMeProvider = StateNotifierProvider<InvitesFromMeNotifier,
    AsyncValue<InviteListResponseDto>>(
  (ref) => InvitesFromMeNotifier(ref.watch(restApiClientProvider)),
);

/// "나를 초대한 사람" 목록을 전담
final invitesToMeProvider = StateNotifierProvider<InvitesToMeNotifier,
    AsyncValue<InviteListResponseDto>>(
  (ref) => InvitesToMeNotifier(ref.watch(restApiClientProvider)),
);

/// "내가 초대한 사람" Notifier
class InvitesFromMeNotifier
    extends StateNotifier<AsyncValue<InviteListResponseDto>> {
  final RestApiClient _apiClient;

  InvitesFromMeNotifier(this._apiClient) : super(const AsyncValue.loading()) {
    loadFromMe(); // 생성자에서 바로 불러옴
  }

  Future<void> loadFromMe() async {
    try {
      state = const AsyncValue.loading();
      final response = await _apiClient.get('invite/from-me', {});
      final inviteResponse = InviteListResponseDto.fromJson(response['data']);
      state = AsyncValue.data(inviteResponse);
    } catch (e, st) {
      talkerError('InvitesFromMeNotifier', '내가 초대한 사람 목록 조회 실패', e);
      state = AsyncValue.error(e, st);
    }
  }

  /// 예: 내가 초대코드 생성하려면?
  Future<void> createInviteCode() async {
    try {
      final response = await _apiClient.post('invite/code', {});
      final inviteCodeResponse =
          InviteCodeResponseDto.fromJson(response['data']);
      final inviteCode = inviteCodeResponse.code;

      // 공유
      await Share.share(
        inviteCode,
        subject: '우리 앱 초대 코드',
      );
    } catch (e) {
      talkerError('InvitesFromMeNotifier', '초대 코드 생성 실패', e);
      rethrow;
    }
  }

  /// 초대를 삭제한 뒤, 다시 fromMe 목록만 새로고침
  Future<void> deleteInvite(String inviteId) async {
    try {
      await _apiClient.delete('invite/$inviteId', {});
      await loadFromMe();
    } catch (e) {
      talkerError('InvitesFromMeNotifier', '초대 삭제 실패', e);
      rethrow;
    }
  }
}

/// "나를 초대한 사람" Notifier
class InvitesToMeNotifier
    extends StateNotifier<AsyncValue<InviteListResponseDto>> {
  final RestApiClient _apiClient;

  InvitesToMeNotifier(this._apiClient) : super(const AsyncValue.loading()) {
    loadToMe();
  }

  Future<void> loadToMe() async {
    try {
      state = const AsyncValue.loading();
      final response = await _apiClient.get('invite/to-me', {});
      final inviteResponse = InviteListResponseDto.fromJson(response['data']);
      state = AsyncValue.data(inviteResponse);
    } catch (e, st) {
      talkerError('InvitesToMeNotifier', '나를 초대한 사람 목록 조회 실패', e);
      state = AsyncValue.error(e, st);
    }
  }

  /// 초대코드 수락 (toMe 목록 업데이트)
  Future<void> acceptInviteCode(String code) async {
    try {
      await _apiClient.post('invite/code/accept', {'code': code});
      // 다시 "나를 초대한 사람" 목록만 새로고침
      await loadToMe();
    } catch (e) {
      talkerError('InvitesToMeNotifier', '초대 코드 수락 실패', e);
      rethrow;
    }
  }
}

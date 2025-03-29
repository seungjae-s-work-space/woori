import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:woori/models/invite_model.dart';

part 'generated/invite_dto.freezed.dart';
part 'generated/invite_dto.g.dart';

@freezed
class CreateInviteDto with _$CreateInviteDto {
  const factory CreateInviteDto({
    required String toUserEmail,
  }) = _CreateInviteDto;

  factory CreateInviteDto.fromJson(Map<String, dynamic> json) =>
      _$CreateInviteDtoFromJson(json);
}

@freezed
class InviteListResponseDto with _$InviteListResponseDto {
  const factory InviteListResponseDto({
    required List<InviteModel> invites,
    required int totalCount,
  }) = _InviteListResponseDto;

  factory InviteListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InviteListResponseDtoFromJson(json);
}

@freezed
class InviteLinkResponseDto with _$InviteLinkResponseDto {
  const factory InviteLinkResponseDto({
    required String inviteUrl,
  }) = _InviteLinkResponseDto;

  factory InviteLinkResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InviteLinkResponseDtoFromJson(json);
}

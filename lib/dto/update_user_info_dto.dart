import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/update_user_info_dto.freezed.dart';
part 'generated/update_user_info_dto.g.dart';

@freezed

/// 유저 정보를 수정할 때 사용하는 DTO 모델입니다.
class UpdateUserInfoDTO with _$UpdateUserInfoDTO {
  /// 유저 정보 수정 DTO 생성자
  const factory UpdateUserInfoDTO({
    String? email,
    String? nickname,
  }) = _UpdateUserInfoDTO;

  /// to/from json 처리를 위한 메서드
  factory UpdateUserInfoDTO.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserInfoDTOFromJson(json);
}

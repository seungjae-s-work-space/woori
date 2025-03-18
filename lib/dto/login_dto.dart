import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/login_dto.freezed.dart';
part 'generated/login_dto.g.dart';

@freezed

/// 로그인 로직을 사용할 때 사용하는 DTO 모델입니다.
/// totalTableCount는 실제 서버로 전송되지는 않지만
/// 로그인시 테이블 정보를 그리고 이후 로그인을 시도할 때 사용하기 위해 추가하였습니다.
class LoginDto with _$LoginDto {
  /// 로그인 DTO 생성자
  const factory LoginDto({
    String? nickname,
    String? password,
  }) = _LoginDto;

  /// to/from json 처리를 위한 메서드
  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/sign_up_dto.freezed.dart';
part 'generated/sign_up_dto.g.dart';

@freezed
class SignUpDto with _$SignUpDto {
  const factory SignUpDto({
    String? email,
    String? password,
    String? nickname,
  }) = _SignUpDto;

  factory SignUpDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpDtoFromJson(json);
}

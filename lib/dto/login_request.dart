// lib/data/auth/dto/login_request.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/login_request.freezed.dart';
part 'generated/login_request.g.dart';

@freezed
class LoginRequest with _$LoginRequest {
  @JsonSerializable(explicitToJson: true) // <-- 추가
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

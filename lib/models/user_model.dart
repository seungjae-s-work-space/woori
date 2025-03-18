import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/user_model.freezed.dart';
part 'generated/user_model.g.dart';

@freezed

/// 유저 모델입니다.
class UserModel with _$UserModel {
  /// 유저 모델 생성자
  const factory UserModel({
    required String nickname,
    required String email,
  }) = _UserModel;

  /// to/from json 처리를 위한 메서드
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

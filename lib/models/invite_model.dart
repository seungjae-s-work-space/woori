import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/invite_model.freezed.dart';
part 'generated/invite_model.g.dart';

@freezed
class InviteModel with _$InviteModel {
  const factory InviteModel({
    required String id,
    required DateTime createdAt,
    required UserModel fromUser,
    required UserModel toUser,
  }) = _InviteModel;

  factory InviteModel.fromJson(Map<String, dynamic> json) =>
      _$InviteModelFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String nickname,
    required String email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

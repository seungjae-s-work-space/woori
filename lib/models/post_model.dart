import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/post_model.freezed.dart';
part 'generated/post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String userId,
    String? imageUrl,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    UserModel? user, // explore API에서만 사용
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String nickname,
    required String id,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

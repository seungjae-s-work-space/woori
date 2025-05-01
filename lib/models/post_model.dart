import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/post_model.freezed.dart';
part 'generated/post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String userId,
    required String content,
    String? imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    UserModel? user,
    @Default(false) bool isLiked,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
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

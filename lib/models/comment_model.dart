import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:woori/models/user_model.dart';

part 'generated/comment_model.freezed.dart';
part 'generated/comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String postId,
    required String userId,
    required String content,
    required DateTime createdAt,
    UserModel? user,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

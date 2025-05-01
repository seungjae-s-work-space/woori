import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/comment_create_dto.freezed.dart';
part 'generated/comment_create_dto.g.dart';

@freezed
class CommentCreateDto with _$CommentCreateDto {
  const factory CommentCreateDto({
    required String postId,
    required String content,
  }) = _CommentCreateDto;

  factory CommentCreateDto.fromJson(Map<String, dynamic> json) =>
      _$CommentCreateDtoFromJson(json);
}

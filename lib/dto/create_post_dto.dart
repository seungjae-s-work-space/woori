import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/create_post_dto.freezed.dart';
part 'generated/create_post_dto.g.dart';

@freezed
class CreatePostDto with _$CreatePostDto {
  const factory CreatePostDto({
    required String content,
    // required String imagePath,
  }) = _CreatePostDto;

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);
}

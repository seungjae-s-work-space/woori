import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:woori/models/post_model.dart';

part 'generated/explore_response_dto.freezed.dart';
part 'generated/explore_response_dto.g.dart';

@freezed
class ExploreResponseDto with _$ExploreResponseDto {
  const factory ExploreResponseDto({
    required List<PostModel> posts,
    required int totalCount,
    required int currentPage,
    required int totalPages,
  }) = _ExploreResponseDto;

  factory ExploreResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ExploreResponseDtoFromJson(json);
}

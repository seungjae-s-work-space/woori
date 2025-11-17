import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/dto/create_post_dto.dart';
import 'package:woori/utils/talker.dart';

final postProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  final apiClientRepository = ref.read(restApiClientProvider);
  return PostNotifier(apiClientRepository);
});

class PostNotifier extends StateNotifier<PostState> {
  PostNotifier(this._apiClient) : super(PostState());
  final RestApiClient _apiClient;

  Future<void> createPost(CreatePostDto createPostDto,
      {File? imageFile}) async {
    try {
      state = state.copyWith(isLoading: true);
      talkerInfo('post', 'Creating post: ${createPostDto.content}');

      dynamic response;

      if (imageFile != null) {
        // 이미지가 있는 경우 - FormData 생성
        final formData = FormData();

        // 텍스트 content 추가
        formData.fields.add(MapEntry('content', createPostDto.content));

        // 이미지 파일 추가
        final fileName = imageFile.path.split('/').last;
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'), // JPEG mimetype 명시
            ),
          ),
        );
        talkerInfo('post', 'Image attached: $fileName');

        // multipart/form-data로 전송
        response =
            await _apiClient.postMultipart('posts/create-post', formData);
      } else {
        // 이미지가 없는 경우 - 일반 JSON 전송
        response = await _apiClient.post('posts/create-post', createPostDto);
      }

      talkerInfo('post', 'Response: ${jsonEncode(response)}');

      if (response['message'] == 'Success') {
        state = state.copyWith(isSuccess: true);
      }
    } catch (e) {
      talkerError('post', '게시물 생성 실패', e);
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class PostState {
  PostState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  bool isLoading;
  bool isSuccess;
  String? error;

  PostState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) =>
      PostState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        error: error ?? this.error,
      );
}

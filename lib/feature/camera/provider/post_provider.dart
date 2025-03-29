import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> createPost(CreatePostDto createPostDto) async {
    try {
      state = state.copyWith(isLoading: true);
      talkerInfo('post', createPostDto.toString());

      final response =
          await _apiClient.post('posts/create-post', createPostDto);
      talkerInfo('post', jsonEncode(response));

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

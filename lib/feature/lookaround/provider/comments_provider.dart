import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/dto/comment_create_dto.dart';
import 'package:woori/models/comment_model.dart';
import 'package:woori/utils/talker.dart';

final commentsProvider = StateNotifierProvider.family<CommentsNotifier,
    AsyncValue<List<CommentModel>>, String>((ref, postId) {
  final apiClient = ref.read(restApiClientProvider);
  return CommentsNotifier(apiClient, postId);
});

class CommentsNotifier extends StateNotifier<AsyncValue<List<CommentModel>>> {
  final RestApiClient _apiClient;
  final String _postId;

  CommentsNotifier(this._apiClient, this._postId)
      : super(const AsyncValue.loading()) {
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      state = const AsyncValue.loading();

      final response = await _apiClient.get('comments/post/$_postId', {});
      final List<dynamic> commentsData = response['data'];
      final comments =
          commentsData.map((item) => CommentModel.fromJson(item)).toList();

      state = AsyncValue.data(comments);
    } catch (e, st) {
      talkerError('comments_provider', '댓글 목록 조회 실패', e);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addComment(String content) async {
    try {
      // API 요청 준비
      final dto = CommentCreateDto(
        postId: _postId,
        content: content,
      );

      // API 호출
      final response = await _apiClient.post('comments', dto.toJson());
      final newComment = CommentModel.fromJson(response['data']);

      // 상태 업데이트
      if (state is AsyncData<List<CommentModel>>) {
        final currentComments = (state as AsyncData<List<CommentModel>>).value;
        state = AsyncValue.data([...currentComments, newComment]);
      }
    } catch (e) {
      talkerError('comments_provider', '댓글 추가 실패', e);
    }
  }

  Future<void> deleteComment(String commentId) async {
    // 현재 댓글 목록 저장
    if (state is! AsyncData<List<CommentModel>>) return;

    final currentComments = (state as AsyncData<List<CommentModel>>).value;

    try {
      // 낙관적 UI 업데이트
      state = AsyncValue.data(
        currentComments.where((comment) => comment.id != commentId).toList(),
      );

      // API 호출
      await _apiClient.delete('comments/$commentId', {});
    } catch (e) {
      talkerError('comments_provider', '댓글 삭제 실패', e);

      // 실패 시 원래 상태로 복원
      state = AsyncValue.data(currentComments);
    }
  }
}

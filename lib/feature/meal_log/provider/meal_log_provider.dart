import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/models/post_model.dart';
import 'package:woori/utils/talker.dart';

final mealLogPostsProvider =
    StateNotifierProvider<MealLogPostsNotifier, AsyncValue<List<PostModel>>>(
        (ref) {
  final apiClient = ref.read(restApiClientProvider);
  return MealLogPostsNotifier(apiClient);
});

class MealLogPostsNotifier extends StateNotifier<AsyncValue<List<PostModel>>> {
  MealLogPostsNotifier(this._apiClient) : super(const AsyncValue.loading()) {
    loadPosts();
  }

  final RestApiClient _apiClient;

  Future<void> loadPosts() async {
    try {
      state = const AsyncValue.loading();
      final response = await _apiClient.get('posts/get-post', {});

      final List<dynamic> postsJson = response['data'];
      final List<PostModel> posts =
          postsJson.map((json) => PostModel.fromJson(json)).toList();

      state = AsyncValue.data(posts);
    } catch (e) {
      talkerError('meal_log_provider', '내 게시물 목록 조회 실패', e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/dto/explore_response_dto.dart';
import 'package:woori/models/post_model.dart';
import 'package:woori/utils/talker.dart';

final explorePostsProvider =
    StateNotifierProvider<ExplorePostsNotifier, AsyncValue<List<PostModel>>>(
        (ref) {
  final apiClient = ref.read(restApiClientProvider);
  return ExplorePostsNotifier(apiClient);
});

class ExplorePostsNotifier extends StateNotifier<AsyncValue<List<PostModel>>> {
  ExplorePostsNotifier(this._apiClient) : super(const AsyncValue.loading()) {
    loadPosts();
  }

  final RestApiClient _apiClient;
  static const int _limit = 10;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  Future<void> loadPosts({bool refresh = false}) async {
    if (_isLoading || (!refresh && !_hasMore)) return;

    try {
      _isLoading = true;
      if (refresh) {
        _currentPage = 1;
        _hasMore = true;
        state = const AsyncValue.loading();
      }

      final response = await _apiClient.get(
        'explore',
        {'page': _currentPage, 'limit': _limit},
      );

      final exploreResponse = ExploreResponseDto.fromJson(response['data']);
      final List<PostModel> newPosts = exploreResponse.posts;

      print('📦 받아온 게시물: ${newPosts.length}');

      _hasMore = newPosts.length >= _limit;
      _currentPage++;

      if (refresh) {
        state = AsyncValue.data(newPosts);
      } else {
        final prevPosts = state.value ?? [];
        state = AsyncValue.data([...prevPosts, ...newPosts]);
      }
    } catch (e, st) {
      talkerError('explore_provider', '게시물 목록 조회 실패', e);
      state = AsyncValue.error(e, st);
    } finally {
      _isLoading = false;
    }
  }
}

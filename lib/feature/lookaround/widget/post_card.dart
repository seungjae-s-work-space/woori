import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/models/post_model.dart';
import 'package:woori/utils/localization_extension.dart';
import 'package:woori/utils/talker.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel post;
  final VoidCallback? onRefresh;

  const PostCard({
    super.key,
    required this.post,
    this.onRefresh,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  late PostModel _post;
  bool _isLiking = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post != widget.post) {
      setState(() {
        _post = widget.post;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return;

    setState(() {
      _isLiking = true;
      // 낙관적 UI 업데이트
      _post = _post.copyWith(
        isLiked: !_post.isLiked,
      );
    });

    try {
      final apiClient = ref.read(restApiClientProvider);
      await apiClient.post('likes/toggle', {'postId': _post.id});
    } catch (e) {
      talkerError('post_card', '좋아요 토글 실패', e);

      // 에러 발생 시 원래 상태로 되돌림
      setState(() {
        _post = _post.copyWith(
          isLiked: !_post.isLiked,
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.like_error_message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    }
  }

  void _showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.add_comment_title),
        content: TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: context.l10n.write_comment_hint,
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel_button),
          ),
          TextButton(
            onPressed: () {
              if (_commentController.text.trim().isNotEmpty) {
                _addComment();
                Navigator.pop(context);
              }
            },
            child: Text(context.l10n.submit_button),
          ),
        ],
      ),
    );
  }

  Future<void> _addComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    try {
      final apiClient = ref.read(restApiClientProvider);
      await apiClient.post('comments', {
        'postId': _post.id,
        'content': content,
      });

      _commentController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.comment_add_success_message)),
        );
      }

      // 목록 새로고침 (옵션)
      if (widget.onRefresh != null) {
        widget.onRefresh!();
      }
    } catch (e) {
      talkerError('post_card', '댓글 추가 실패', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.comment_add_error_message)),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 작성자 정보 및 날짜
            Row(
              children: [
                CircleAvatar(
                  child: Text(_post.user?.nickname.substring(0, 1) ?? '?'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _post.user?.nickname ?? context.l10n.unknown_user,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _formatDate(_post.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),

            // 게시글 내용
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(_post.content),
            ),

            // 이미지가 있는 경우
            if (_post.imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // 좋아요, 댓글 버튼
            Row(
              children: [
                InkWell(
                  onTap: _toggleLike,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _post.isLiked ? Colors.red : null,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: _showCommentDialog,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.comment_outlined, size: 20),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

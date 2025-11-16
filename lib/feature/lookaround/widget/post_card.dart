import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/models/post_model.dart';
import 'package:woori/utils/app_theme.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 작성자 정보 및 날짜
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacing16,
              AppTheme.spacing16,
              AppTheme.spacing16,
              AppTheme.spacing12,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primarySkyLight,
                  foregroundColor: AppTheme.primarySkyDark,
                  radius: 20,
                  child: Text(
                    _post.user?.nickname.substring(0, 1).toUpperCase() ?? '?',
                    style: AppTheme.heading2.copyWith(
                      fontSize: 16,
                      color: AppTheme.primarySkyDark,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _post.user?.nickname ?? context.l10n.unknown_user,
                        style: AppTheme.body1.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(_post.createdAt),
                        style: AppTheme.caption.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 게시글 내용
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
            decoration: const BoxDecoration(
              color: AppTheme.backgroundWhite,
            ),
            child: Text(
              _post.content,
              style: AppTheme.body1.copyWith(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),

          // 이미지가 있는 경우
          if (_post.imageUrl != null)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                child: Image.network(
                  _post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 좋아요, 댓글 버튼
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing8,
              vertical: AppTheme.spacing12,
            ),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.divider,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: _toggleLike,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _post.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _post.isLiked ? AppTheme.accentRed : AppTheme.textSecondary,
                          size: 20,
                        ),
                        if (_post.likeCount > 0) ...[
                          const SizedBox(width: AppTheme.spacing4),
                          Text(
                            '${_post.likeCount}',
                            style: AppTheme.caption.copyWith(
                              color: _post.isLiked ? AppTheme.accentRed : AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                InkWell(
                  onTap: _showCommentDialog,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.comment_outlined,
                          size: 20,
                          color: AppTheme.textSecondary,
                        ),
                        if (_post.commentCount > 0) ...[
                          const SizedBox(width: AppTheme.spacing4),
                          Text(
                            '${_post.commentCount}',
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

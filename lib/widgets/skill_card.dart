import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../models/post_model.dart';

class SkillCard extends StatelessWidget {
  final PostModel post;
  final String currentUid;
  final VoidCallback onLike;
  final VoidCallback onTap;

  const SkillCard({
    super.key,
    required this.post,
    required this.currentUid,
    required this.onLike,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLiked = post.likedBy.contains(currentUid);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : AppColors.primary.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkInput
                          : AppColors.lightAccent.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: post.userImage.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        post.userImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _avatarFallback(isDark),
                      ),
                    )
                        : _avatarFallback(isDark),
                  ),

                  const SizedBox(width: 12),

                  // Name + University
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isDark
                                ? AppColors.textLight
                                : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.school_outlined,
                                size: 12,
                                color: isDark
                                    ? AppColors.lightAccent
                                    : AppColors.textGrey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                post.university,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.lightAccent
                                      : AppColors.textGrey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Time ago
                  Text(
                    _timeAgo(post.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.lightAccent
                          : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),

            // ── Title ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Text(
                post.title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textLight
                      : AppColors.textDark,
                ),
              ),
            ),

            // ── Description ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                post.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.lightAccent
                      : AppColors.textGrey,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ── Skill Tags ──────────────────────────────
            if (post.skillTags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: post.skillTags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.accent.withValues(alpha: 0.2)
                            : AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // ── Divider ─────────────────────────────────
            Divider(
              height: 1,
              color: isDark
                  ? AppColors.darkDivider
                  : AppColors.textGrey.withValues(alpha: 0.1),
            ),

            // ── Footer ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  // Like
                  TextButton.icon(
                    onPressed: onLike,
                    icon: Icon(
                      isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isLiked
                          ? Colors.redAccent
                          : isDark
                          ? AppColors.lightAccent
                          : AppColors.textGrey,
                      size: 20,
                    ),
                    label: Text(
                      '${post.likes}',
                      style: TextStyle(
                        color: isLiked
                            ? Colors.redAccent
                            : isDark
                            ? AppColors.lightAccent
                            : AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  // Connect
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.handshake_outlined,
                      color: isDark
                          ? AppColors.lightAccent
                          : AppColors.textGrey,
                      size: 20,
                    ),
                    label: Text(
                      'Connect',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.lightAccent
                            : AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Share
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.share_outlined,
                      color: isDark
                          ? AppColors.lightAccent
                          : AppColors.textGrey,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback(bool isDark) {
    return Center(
      child: Text(
        post.userName.isNotEmpty
            ? post.userName[0].toUpperCase()
            : '?',
        style: TextStyle(
          color: isDark ? AppColors.lightAccent : AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
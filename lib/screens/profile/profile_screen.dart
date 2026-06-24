import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../models/post_model.dart';
import '../../models/student_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/skill_card.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'package:provider/provider.dart';
import '../../core/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final FirestoreService firestoreService = FirestoreService();
    final String currentUid =
        FirebaseAuth.instance.currentUser?.uid ?? '';
    final bool isOwnProfile = uid == currentUid;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      body: FutureBuilder<StudentModel?>(
        future: authService.getStudentData(uid),
        builder: (context, snapshot) {
          // Add isDark at the top of FutureBuilder
          final bool isDark = Theme.of(context).brightness == Brightness.dark;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.accent),
            );
          }
          final student = snapshot.data;
          if (student == null) {
            return const Center(child: Text('Student not found'));
          }

          return CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────
              SliverToBoxAdapter(
                child: FadeInDown(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    padding:
                    const EdgeInsets.fromLTRB(20, 60, 20, 28),
                    child: Column(
                      children: [
                        // Top row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isOwnProfile)
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.arrow_back_ios,
                                    color: AppColors.textLight, size: 20),
                              )
                            else
                              const SizedBox(width: 20),

                            const Text(
                              'Profile',
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (isOwnProfile)
                              Row(
                                children: [
                                  // Dark Mode Toggle
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<ThemeProvider>(context, listen: false)
                                          .toggleTheme();
                                    },
                                    child: Consumer<ThemeProvider>(
                                      builder: (context, themeProvider, _) {
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            themeProvider.isDarkMode
                                                ? Icons.light_mode_rounded
                                                : Icons.dark_mode_rounded,
                                            color: AppColors.textLight,
                                            size: 20,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Logout Button
                                  GestureDetector(
                                    onTap: () async {
                                      await authService.logout();
                                      if (context.mounted) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const LoginScreen()),
                                              (route) => false,
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.logout_rounded,
                                          color: Colors.redAccent, size: 20),
                                    ),
                                  ),
                                ],
                              )
                            else
                              const SizedBox(width: 20),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Avatar
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.accent
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                                color: AppColors.accent, width: 2),
                          ),
                          child: student.profileImage.isNotEmpty
                              ? ClipRRect(
                            borderRadius:
                            BorderRadius.circular(24),
                            child: Image.network(
                              student.profileImage,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Center(
                            child: Text(
                              student.name.isNotEmpty
                                  ? student.name[0]
                                  .toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          student.name,
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.school_outlined,
                                size: 14,
                                color: AppColors.lightAccent),
                            const SizedBox(width: 4),
                            Text(
                              student.university,
                              style: const TextStyle(
                                color: AppColors.lightAccent,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        if (student.bio.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            student.bio,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textLight
                                  .withValues(alpha: 0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Stats
                        StreamBuilder<List<PostModel>>(
                          stream: firestoreService.getUserPosts(uid),
                          builder: (context, postSnap) {
                            final postCount =
                                postSnap.data?.length ?? 0;
                            return Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatItem(
                                    label: 'Skills',
                                    value:
                                    '${student.skills.length}'),
                                Container(
                                    width: 1,
                                    height: 30,
                                    color: AppColors.lightAccent
                                        .withValues(alpha: 0.3)),
                                _StatItem(
                                    label: 'Connections',
                                    value:
                                    '${student.connections.length}'),
                                Container(
                                    width: 1,
                                    height: 30,
                                    color: AppColors.lightAccent
                                        .withValues(alpha: 0.3)),
                                _StatItem(
                                    label: 'Posts',
                                    value: '$postCount'),
                              ],
                            );
                          },
                        ),

                        // Edit Profile Button
                        if (isOwnProfile) ...[
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfileScreen(student: student),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // ── Skills ───────────────────────────────────
              if (student.skills.isNotEmpty)
                SliverToBoxAdapter(
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Skills',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.textLight : AppColors.textDark)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: student.skills.map((skill) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.accent.withValues(alpha: 0.2)
                                      : AppColors.accent.withValues(alpha: 0.1),
                                  borderRadius:
                                  BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.accent
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(skill,
                                    style: const TextStyle(
                                        color: AppColors.accent,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Posts ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text('Posts',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textLight : AppColors.textDark)),
                ),
              ),

              StreamBuilder<List<PostModel>>(
                stream: firestoreService.getUserPosts(uid),
                builder: (context, postSnap) {
                  if (postSnap.connectionState ==
                      ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.accent)),
                    );
                  }
                  final posts = postSnap.data ?? [];
                  if (posts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Icon(Icons.post_add_outlined,
                                  size: 50,
                                  color: AppColors.lightAccent
                                      .withValues(alpha: 0.4)),
                              const SizedBox(height: 10),
                              Text('No posts yet',
                                  style: TextStyle(
                                      color: isDark ? AppColors.lightAccent : AppColors.textGrey)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => SkillCard(
                        post: posts[index],
                        currentUid: currentUid,
                        onLike: () => firestoreService.toggleLike(
                            posts[index].postId, currentUid),
                        onTap: () {},
                      ),
                      childCount: posts.length,
                    ),
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                color: AppColors.lightAccent, fontSize: 12)),
      ],
    );
  }
}
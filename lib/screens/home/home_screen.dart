import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../models/post_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/shimmer_card.dart';
import '../../widgets/skill_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final String currentUid =
      FirebaseAuth.instance.currentUser?.uid ?? '';
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All', 'Flutter', 'Python', 'UI/UX',
    'Machine Learning', 'Web Dev', 'Data Science',
    'Android', 'iOS', 'React', 'Firebase',
  ];


  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            snap: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeInDown(
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'LearnLoop',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Discover student skills',
                            style: TextStyle(
                              color: AppColors.lightAccent,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.textLight,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Filter Chips ──────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primary,
              child: Container(
                decoration:  BoxDecoration(
                  color: isDark ? AppColors.darkBg : AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 8),
                  child: SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filters.length,
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = _selectedFilter == filter;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedFilter = filter),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accent
                                  : isDark
                                  ? AppColors.darkCard
                                  : AppColors.cardLight,

                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isSelected
                                  ? [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                                  : [],
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.textLight
                                    : isDark
                                    ? AppColors.lightAccent
                                    : AppColors.textGrey,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Posts Feed ────────────────────────────────
          StreamBuilder<List<PostModel>>(
            stream: _firestoreService.getAllPosts(),
            builder: (context, snapshot) {
              // Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => const ShimmerCard(),
                    childCount: 4,
                  ),
                );
              }

              // Empty
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 80,
                          color: AppColors.lightAccent.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No posts yet!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Be the first to share your skills',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Filter posts
              List<PostModel> posts = snapshot.data!;
              if (_selectedFilter != 'All') {
                posts = posts
                    .where((p) => p.skillTags.any((tag) => tag
                    .toLowerCase()
                    .contains(_selectedFilter.toLowerCase())))
                    .toList();
              }

              if (posts.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_list_off,
                            size: 60,
                            color:
                            AppColors.lightAccent.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text(
                          'No posts for "$_selectedFilter"',
                          style: const TextStyle(
                              color: AppColors.textGrey, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => FadeInUp(
                    delay: Duration(milliseconds: index * 80),
                    child: SkillCard(
                      post: posts[index],
                      currentUid: currentUid,
                      onLike: () => _firestoreService.toggleLike(
                        posts[index].postId,
                        currentUid,
                      ),
                      onTap: () {},
                    ),
                  ),
                  childCount: posts.length,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
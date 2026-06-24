import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../models/student_model.dart';
import '../../services/firestore_service.dart';
import '../profile/profile_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final String currentUid =
      FirebaseAuth.instance.currentUser?.uid ?? '';
  final TextEditingController _searchController =
  TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primary,
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: const Text(
                      'Discover Students',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FadeInDown(
                    delay: const Duration(milliseconds: 150),
                    child: const Text(
                      'Find and connect with other students',
                      style: TextStyle(
                        color: AppColors.lightAccent,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                            color: AppColors.textLight, fontSize: 14),
                        onChanged: (val) =>
                            setState(() => _searchQuery = val.toLowerCase()),
                        decoration: InputDecoration(
                          hintText: 'Search by name, skill or university...',
                          hintStyle: TextStyle(
                              color: AppColors.lightAccent.withValues(alpha: 0.7),
                              fontSize: 13),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.lightAccent, size: 20),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Students List ─────────────────────────────
          StreamBuilder<List<StudentModel>>(
            stream: _firestoreService.getAllStudents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.accent),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                      child: Text('No students yet',
                          style: TextStyle(
                              color: isDark ? AppColors.lightAccent : AppColors.textGrey))),
                );
              }

              List<StudentModel> students = snapshot.data!
                  .where((s) => s.uid != currentUid)
                  .toList();

              if (_searchQuery.isNotEmpty) {
                students = students.where((s) {
                  return s.name
                      .toLowerCase()
                      .contains(_searchQuery) ||
                      s.university
                          .toLowerCase()
                          .contains(_searchQuery) ||
                      s.skills.any((skill) =>
                          skill.toLowerCase().contains(_searchQuery));
                }).toList();
              }

              if (students.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 60,
                            color: AppColors.lightAccent
                                .withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text('No students found',
                            style: TextStyle(
                                color: isDark ? AppColors.lightAccent : AppColors.textGrey,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }

              return SliverToBoxAdapter(
                child: Container(
                  color: AppColors.primary,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBg : AppColors.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: index * 80),
                          child: _StudentCard(
                            student: student,
                            currentUid: currentUid,
                            firestoreService: _firestoreService,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final StudentModel student;
  final String currentUid;
  final FirestoreService firestoreService;

  const _StudentCard({
    required this.student,
    required this.currentUid,
    required this.firestoreService,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isConnected = student.connections.contains(currentUid);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProfileScreen(uid: student.uid)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.lightAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: student.profileImage.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  student.profileImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _avatarFallback(student.name),
                ),
              )
                  : _avatarFallback(student.name),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.school_outlined,
                          size: 12, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          student.university,
                          style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.lightAccent : AppColors.textGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (student.skills.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: student.skills.take(3).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Connect Button
            GestureDetector(
              onTap: () async {
                if (isConnected) {
                  await firestoreService.disconnect(
                      currentUid, student.uid);
                } else {
                  await firestoreService.connect(
                      currentUid, student.uid);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isConnected
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isConnected
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
                child: Text(
                  isConnected ? 'Connected ✓' : 'Connect',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isConnected
                        ? AppColors.success
                        : AppColors.textLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
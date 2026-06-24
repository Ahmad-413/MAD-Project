import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/colors.dart';
import '../../models/post_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_button.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _tagController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  List<String> _tags = [];
  bool _isLoading = false;

  final List<String> _suggestedTags = [
    'Flutter', 'Python', 'UI/UX', 'Machine Learning',
    'Web Dev', 'Data Science', 'Android', 'iOS',
    'React', 'Node.js', 'Firebase', 'Figma',
    'Java', 'C++', 'Deep Learning', 'Blockchain',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final clean = tag.trim().replaceAll('#', '');
    if (clean.isNotEmpty &&
        !_tags.contains(clean) &&
        _tags.length < 5) {
      setState(() => _tags.add(clean));
    }
    _tagController.clear();
  }

  void _removeTag(String tag) => setState(() => _tags.remove(tag));

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add at least one skill tag'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser!;
    final studentData = await _authService.getStudentData(user.uid);

    final post = PostModel(
      postId: const Uuid().v4(),
      uid: user.uid,
      userName: studentData?.name ?? 'Unknown',
      userImage: studentData?.profileImage ?? '',
      university: studentData?.university ?? '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      skillTags: _tags,
      likes: 0,
      likedBy: [],
      createdAt: DateTime.now(),
    );

    await _firestoreService.createPost(post);
    setState(() => _isLoading = false);

    if (!mounted) return;
    _titleController.clear();
    _descController.clear();
    setState(() => _tags = []);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Skill post shared!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            floating: true,
            snap: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
                child: FadeInDown(
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share Your Skill',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Let others discover what you know',
                        style: TextStyle(
                          color: AppColors.lightAccent,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
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
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Title
                      FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        child: Text('Skill Title',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isDark ? AppColors.textLight : AppColors.textDark)),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        delay: const Duration(milliseconds: 150),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText:
                            'e.g. I can teach Flutter from scratch',
                            prefixIcon: Icon(Icons.lightbulb_outline,
                                color: AppColors.accent),
                          ),
                          validator: (val) =>
                          val == null || val.isEmpty
                              ? 'Enter a title'
                              : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: Text('Description',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isDark ? AppColors.textLight : AppColors.textDark)),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        delay: const Duration(milliseconds: 250),
                        child: TextFormField(
                          controller: _descController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText:
                            'Describe what you can teach, your experience and what others will learn...',
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child: Icon(Icons.description_outlined,
                                  color: AppColors.accent),
                            ),
                          ),
                          validator: (val) =>
                          val == null || val.isEmpty
                              ? 'Add a description'
                              : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Skill Tags
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: Text('Skill Tags (max 5)',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isDark ? AppColors.textLight : AppColors.textDark)),
                      ),
                      const SizedBox(height: 8),

                      FadeInUp(
                        delay: const Duration(milliseconds: 350),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _tagController,
                                decoration: const InputDecoration(
                                  hintText: 'Type a skill tag...',
                                  prefixIcon: Icon(Icons.tag,
                                      color: AppColors.accent),
                                ),
                                onFieldSubmitted: _addTag,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () =>
                                  _addTag(_tagController.text),
                              child: Container(
                                width: 50,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Suggested Tags
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: _suggestedTags.map((tag) {
                            final isAdded = _tags.contains(tag);
                            return GestureDetector(
                              onTap: () => isAdded
                                  ? _removeTag(tag)
                                  : _addTag(tag),
                              child: AnimatedContainer(
                                duration:
                                const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isAdded
                                      ? AppColors.accent
                                      : isDark
                                      ? AppColors.darkCard
                                      : AppColors.cardLight,
                                  borderRadius:
                                  BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isAdded
                                        ? AppColors.accent
                                        : AppColors.lightAccent
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isAdded
                                        ? Colors.white
                                        : AppColors.textGrey,
                                    fontWeight: isAdded
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // Selected Tags
                      if (_tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('Selected:',
                            style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.lightAccent : AppColors.textGrey)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: _tags.map((tag) {
                            return Chip(
                              label: Text('#$tag',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12)),
                              backgroundColor: AppColors.primary,
                              deleteIcon: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                              onDeleted: () => _removeTag(tag),
                              padding: EdgeInsets.zero,
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 32),

                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: CustomButton(
                          text: 'Share Skill Post',
                          onTap: _submitPost,
                          isLoading: _isLoading,
                          color: AppColors.accent,
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
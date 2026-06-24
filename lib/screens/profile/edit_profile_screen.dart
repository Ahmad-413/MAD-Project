import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import '../../core/colors.dart';
import '../../models/student_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  final StudentModel student;
  const EditProfileScreen({super.key, required this.student});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _universityController;
  final TextEditingController _skillController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  List<String> _skills = [];
  Uint8List? _imageBytes;
  bool _isLoading = false;

  final List<String> _suggestedSkills = [
    'Flutter', 'Python', 'UI/UX', 'Machine Learning',
    'Web Dev', 'Data Science', 'Android', 'iOS',
    'React', 'Node.js', 'Firebase', 'Figma',
    'Java', 'C++', 'Deep Learning', 'Blockchain',
    'Swift', 'Kotlin', 'Django', 'MongoDB',
  ];

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.student.name);
    _bioController =
        TextEditingController(text: widget.student.bio);
    _universityController =
        TextEditingController(text: widget.student.university);
    _skills = List.from(widget.student.skills);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _universityController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  Future<String?> _uploadImage(String uid) async {
    if (_imageBytes == null) return null;
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');
      await ref.putData(
        _imageBytes!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  void _addSkill(String skill) {
    final clean = skill.trim();
    if (clean.isNotEmpty &&
        !_skills.contains(clean) &&
        _skills.length < 10) {
      setState(() => _skills.add(clean));
    }
    _skillController.clear();
  }

  void _removeSkill(String skill) =>
      setState(() => _skills.remove(skill));

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    String? newImageUrl = await _uploadImage(uid);

    await _firestoreService.updateProfile(uid, {
      'name': _nameController.text.trim(),
      'bio': _bioController.text.trim(),
      'university': _universityController.text.trim(),
      'skills': _skills,
      if (newImageUrl != null) 'profileImage': newImageUrl,
    });

    setState(() => _isLoading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Profile updated!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ─────────────────────────────────
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            snap: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: AppColors.textLight),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 40),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
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

                      // ── Profile Picture ──────────────
                      FadeInDown(
                        child: Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightAccent
                                        .withValues(alpha: 0.2),
                                    borderRadius:
                                    BorderRadius.circular(28),
                                    border: Border.all(
                                        color: AppColors.accent,
                                        width: 2),
                                  ),
                                  child: _imageBytes != null
                                      ? ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(26),
                                    child: Image.memory(
                                      _imageBytes!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : widget.student.profileImage
                                      .isNotEmpty
                                      ? ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(
                                        26),
                                    child: Image.network(
                                      widget.student
                                          .profileImage,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : Center(
                                    child: Text(
                                      widget.student.name
                                          .isNotEmpty
                                          ? widget.student
                                          .name[0]
                                          .toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight:
                                        FontWeight.bold,
                                        color:
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          'Tap to change photo',
                          style: TextStyle(
                              color: isDark ? AppColors.lightAccent : AppColors.textGrey,
                              fontSize: 12),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Name ─────────────────────────
                      FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          child: _label('Full Name', isDark)),
                      const SizedBox(height: 8),
                      FadeInUp(
                        delay: const Duration(milliseconds: 150),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline,
                                color: AppColors.accent),
                          ),
                          validator: (val) =>
                          val == null || val.isEmpty
                              ? 'Name is required'
                              : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── University ───────────────────
                      FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: _label('University', isDark)),
                      const SizedBox(height: 8),
                      FadeInUp(
                        delay: const Duration(milliseconds: 250),
                        child: TextFormField(
                          controller: _universityController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.school_outlined,
                                color: AppColors.accent),
                          ),
                          validator: (val) =>
                          val == null || val.isEmpty
                              ? 'University is required'
                              : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Bio ──────────────────────────
                      FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: _label('Bio', isDark)),
                      const SizedBox(height: 8),
                      FadeInUp(
                        delay: const Duration(milliseconds: 350),
                        child: TextFormField(
                          controller: _bioController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Tell others about yourself...',
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: Icon(Icons.info_outline,
                                  color: AppColors.accent),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Skills ───────────────────────
                      FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: _label('Your Skills (max 10)', isDark)),
                      const SizedBox(height: 8),

                      FadeInUp(
                        delay: const Duration(milliseconds: 450),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _skillController,
                                decoration: const InputDecoration(
                                  hintText: 'Add a skill...',
                                  prefixIcon: Icon(
                                      Icons.add_circle_outline,
                                      color: AppColors.accent),
                                ),
                                onFieldSubmitted: _addSkill,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () =>
                                  _addSkill(_skillController.text),
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

                      // Suggested Skills
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: _suggestedSkills.map((skill) {
                            final isAdded = _skills.contains(skill);
                            return GestureDetector(
                              onTap: () => isAdded
                                  ? _removeSkill(skill)
                                  : _addSkill(skill),
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
                                  skill,
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

                      // Added Skills
                      if (_skills.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('Added Skills:',
                            style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.lightAccent : AppColors.textGrey)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: _skills.map((skill) {
                            return Chip(
                              label: Text(skill,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12)),
                              backgroundColor: AppColors.primary,
                              deleteIcon: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                              onDeleted: () => _removeSkill(skill),
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 36),

                      // Save Button
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        child: CustomButton(
                          text: 'Save Profile',
                          onTap: _saveProfile,
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

  Widget _label(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: isDark ? AppColors.textLight : AppColors.textDark,
      ),
    );
  }
}
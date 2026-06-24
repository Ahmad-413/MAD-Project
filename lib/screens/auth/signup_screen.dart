import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../main_navigation.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _universityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _universityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    String? error = await _authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      university: _universityController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (error == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    bool? showObscure,
    VoidCallback? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.accent),
        suffixIcon: toggleObscure != null
            ? IconButton(
          icon: Icon(
            (showObscure ?? true)
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textGrey,
          ),
          onPressed: toggleObscure,
        )
            : null,
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────
            FadeInDown(
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(height: 40),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Join thousands of students',
                      style: TextStyle(
                        color: AppColors.lightAccent,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Form ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: _buildField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Enter your name'
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: _buildField(
                        controller: _emailController,
                        label: 'University Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter your email';
                          }
                          if (!val.contains('@')) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: _buildField(
                        controller: _universityController,
                        label: 'University Name',
                        icon: Icons.school_outlined,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Enter your university'
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: _buildField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscure: _obscurePassword,
                        showObscure: _obscurePassword,
                        toggleObscure: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter password';
                          }
                          if (val.length < 6) {
                            return 'Minimum 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: _buildField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscure: _obscureConfirm,
                        showObscure: _obscureConfirm,
                        toggleObscure: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                        validator: (val) {
                          if (val != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: CustomButton(
                        text: 'Create Account',
                        onTap: _signup,
                        isLoading: _isLoading,
                      ),
                    ),

                    const SizedBox(height: 16),

                    FadeInUp(
                      delay: const Duration(milliseconds: 750),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? ',
                              style:
                              TextStyle(color: AppColors.textGrey)),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
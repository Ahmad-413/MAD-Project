import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../main_navigation.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    String? error = await _authService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
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
                height: 300,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Icon(
                          Icons.loop_rounded,
                          color: AppColors.textLight,
                          size: 56,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'LearnLoop',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Connect. Learn. Grow.',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: const Text(
                        'Login to continue learning',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textGrey),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'University Email',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: AppColors.accent),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!val.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: AppColors.accent),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textGrey,
                            ),
                            onPressed: () => setState(() =>
                            _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (val.length < 6) {
                            return 'Minimum 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Forgot Password
                    FadeInUp(
                      delay: const Duration(milliseconds: 550),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Login Button
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: CustomButton(
                        text: 'Login',
                        onTap: _login,
                        isLoading: _isLoading,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Divider
                    FadeInUp(
                      delay: const Duration(milliseconds: 650),
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: AppColors.textGrey
                                      .withOpacity(0.3))),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 12),
                            child: Text('or',
                                style: TextStyle(
                                    color: AppColors.textGrey)),
                          ),
                          Expanded(
                              child: Divider(
                                  color: AppColors.textGrey
                                      .withOpacity(0.3))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Sign Up Button
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: CustomButton(
                        text: 'Create Account',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupScreen()),
                        ),
                        color: AppColors.cardLight,
                        textColor: AppColors.primary,
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
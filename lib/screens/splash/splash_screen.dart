import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../auth/login_screen.dart';
import '../main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    User? user = FirebaseAuth.instance.currentUser;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user != null
            ? const MainNavigation()
            : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
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

            const SizedBox(height: 24),

            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: const Text(
                'LearnLoop',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 8),

            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: const Text(
                'Connect. Learn. Grow.',
                style: TextStyle(
                  color: AppColors.lightAccent,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 60),

            FadeIn(
              delay: const Duration(milliseconds: 800),
              child: const CircularProgressIndicator(
                color: AppColors.accent,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
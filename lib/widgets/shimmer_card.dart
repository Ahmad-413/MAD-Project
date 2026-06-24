import 'package:flutter/material.dart';
import '../core/colors.dart';

class ShimmerCard extends StatefulWidget {
  const ShimmerCard({super.key});

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.cardLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _box(48, 48, isDark, radius: 14),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(120, 14, isDark),
                        const SizedBox(height: 6),
                        _box(80, 11, isDark),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _box(double.infinity, 16, isDark),
                const SizedBox(height: 8),
                _box(double.infinity, 13, isDark),
                const SizedBox(height: 6),
                _box(200, 13, isDark),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _box(60, 26, isDark, radius: 20),
                    const SizedBox(width: 8),
                    _box(60, 26, isDark, radius: 20),
                    const SizedBox(width: 8),
                    _box(60, 26, isDark, radius: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _box(double width, double height, bool isDark,
      {double radius = 8}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkInput.withValues(alpha: 0.8)
            : AppColors.lightAccent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
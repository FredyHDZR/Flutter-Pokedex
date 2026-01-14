import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/core/theme/app_theme.dart';

class BlurAppBar extends StatelessWidget implements PreferredSizeWidget {

  const BlurAppBar({
    required this.title,
    this.isScrolled = false,
    super.key,
  });

  final String title;
  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppTheme.gradientStart,
      elevation: 0,
      flexibleSpace: isScrolled
          ? ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

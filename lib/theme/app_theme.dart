import 'package:flutter/material.dart';

enum HealthQuestTheme { deepNavy, cyberpunkNeon, forestMint }

class ThemeProvider extends ChangeNotifier {
  HealthQuestTheme _selected = HealthQuestTheme.deepNavy;
  HealthQuestTheme get selected => _selected;

  void setTheme(HealthQuestTheme value) {
    if (_selected == value) return;
    _selected = value;
    notifyListeners();
  }

  ThemeData get themeData => AppTheme.themeFor(_selected);
}

class AppTheme {
  // Brand Colors
  static const Color background = Color(0xFF0F172A); // Deep Navy Blue
  static const Color surface = Color(0xFF1E293B);    // Slate Dark Surface
  static const Color surfaceLight = Color(0xFF334155);
  static const Color cyan = Color(0xFF06B6D4);       // Cyan Vibrant
  static const Color mint = Color(0xFF10B981);       // Neon Mint
  static const Color amber = Color(0xFFF59E0B);      // Health Gold / Coins
  static const Color purple = Color(0xFF8B5CF6);     // Pro / Magic MP
  static const Color rose = Color(0xFFF43F5E);       // HP / Alert
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Glassmorphic Decoration
  static BoxDecoration glassBox({
    Color? color,
    double radius = 20,
    Border? border,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: color ?? surface.withOpacity(0.85),
      borderRadius: BorderRadius.circular(radius),
      border: border ??
          Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1.2,
          ),
      boxShadow: shadows ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
    );
  }

  // Cyan Glow Decoration
  static BoxDecoration cyanGlowBox({
    double radius = 20,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF0E7490), Color(0xFF06B6D4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: cyan.withOpacity(0.35),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  // Pro Gold/Purple Glow
  static BoxDecoration proGlowBox({
    double radius = 20,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFFEC4899), Color(0xFFF59E0B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: purple.withOpacity(0.35),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return themeFor(HealthQuestTheme.deepNavy);
  }

  static ThemeData themeFor(HealthQuestTheme theme) {
    final (backgroundColor, surfaceColor, primaryColor, secondaryColor) = switch (theme) {
      HealthQuestTheme.deepNavy => (background, surface, cyan, mint),
      HealthQuestTheme.cyberpunkNeon => (const Color(0xFF100B1F), const Color(0xFF211533), const Color(0xFF00E5FF), const Color(0xFFFF2BD6)),
      HealthQuestTheme.forestMint => (const Color(0xFF0B1F1A), const Color(0xFF17382E), const Color(0xFF6EE7B7), const Color(0xFFA3E635)),
    };
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      useMaterial3: true,
    );
  }
}


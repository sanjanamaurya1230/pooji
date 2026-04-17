import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary brand — warm saffron (toned down, not neon)
  static const Color primary      = Color(0xFFCC5500);   // burnt saffron
  static const Color primaryLight = Color(0xFFE87722);   // marigold
  static const Color primaryPale  = Color(0xFFFFF0E0);   // very light peach

  // Gold
  static const Color gold         = Color(0xFFD4920A);
  static const Color goldDeep     = Color(0xFFB8770B);
  static const Color goldLight    = Color(0xFFFFBF47);

  // Deep jewel for hero / navbar
  static const Color deepMaroon   = Color(0xFF7B1530);
  static const Color maroon       = Color(0xFF9B2335);

  // Backgrounds — soft warm cream, not stark white
  static const Color bgDeep       = Color(0xFFFFE5C8);
  static const Color bgMid        = Color(0xFFFFF3E5);
  static const Color bgLight      = Color(0xFFFFFAF5);
  static const Color surface      = Color(0xFFFFF8F2);

  // Text
  static const Color textDark     = Color(0xFF2C1200);
  static const Color textMid      = Color(0xFF5C2E0A);
  static const Color textLight    = Color(0xFF9B5A2E);

  static const Color white        = Color(0xFFFFFFFF);
  static const Color whatsapp     = Color(0xFF25D366);
  static const Color divider      = Color(0xFFEDD5B0);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bgLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );
}
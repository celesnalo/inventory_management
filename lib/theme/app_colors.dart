import 'package:flutter/material.dart';

// One place for every colour in the app.
class AppColors {
  static const primary = Color(0xFF16A34A);
  static const primaryDark = Color(0xFF166534);
  static const primarySoft = Color(0xFFDCFCE7);

  static const background = Color(0xFFF3F6F4); //page background
  static const surface = Colors.white;
  static const ink = Color(0xFF0F172A); // main text
  static const muted = Color(0xFF64748B); // secondary text
  static const border = Color(0xFFE2E8F0);

  static const warning = Color(0xFFB45309);
  static const warningSoft = Color(0xFFFEF3C7);
  static const danger = Color(0xFFDC2626);
  static const dangerSoft = Color(0xFFFEE2E2);

  static const softShadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 5)),
  ];
}

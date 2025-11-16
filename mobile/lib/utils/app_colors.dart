import 'package:flutter/material.dart';

class AppColors {
  // FluxShorts Brand Colors
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color primaryBlue = Color(0xFF74B9FF);
  static const Color primaryCyan = Color(0xFF00CEC9);
  
  // Netflix Colors
  static const Color netflixRed = Color(0xFFE50914);
  
  // Background Colors
  static const Color backgroundDark = Color(0xFF0D0D0D);
  static const Color cardBackground = Color(0xFF1A1A1A);
  
  // Gradient Collections
  static const LinearGradient fluxBrandGradient = LinearGradient(
    colors: [primaryPurple, primaryBlue, primaryCyan],
  );
  
  static const LinearGradient cardGradient1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF6C5CE7), Color(0xFF74B9FF)],
    stops: [0.0, 0.3, 0.7, 1.0],
  );
  
  static const LinearGradient cardGradient2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2c1810), Color(0xFF8B0000), Color(0xFF000000)],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient cardGradient3 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C2C54), Color(0xFF40407A), Color(0xFF706FD3)],
    stops: [0.0, 0.5, 1.0],
  );
}
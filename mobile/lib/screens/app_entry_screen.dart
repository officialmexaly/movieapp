import 'package:flutter/material.dart';
import 'home_screen.dart';

class AppEntryScreen extends StatefulWidget {
  const AppEntryScreen({super.key});

  @override
  State<AppEntryScreen> createState() => _AppEntryScreenState();
}

class _AppEntryScreenState extends State<AppEntryScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationMethod();
  }

  Future<void> _checkAuthenticationMethod() async {
    // Add a small delay for splash effect
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;

    // Navigate directly to home screen (biometric login available in profile settings)
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // D-eyeturn Logo with Animation
            Hero(
              tag: 'flux_logo',
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF6C5CE7),
                    Color(0xFF74B9FF),
                    Color(0xFF00CEC9),
                  ],
                ).createShader(bounds),
                child: const Text(
                  'D-eyeturn',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Loading Indicator
            const CircularProgressIndicator(
              color: Color(0xFF6C5CE7),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            
            Text(
              'Loading your experience...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
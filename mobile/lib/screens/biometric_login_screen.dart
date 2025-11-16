import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../services/biometric_service.dart';
import 'home_screen.dart';

class BiometricLoginScreen extends StatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  State<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  
  bool _isAuthenticating = false;
  String _statusMessage = 'Tap to unlock with biometric authentication';
  List<BiometricType> _availableBiometrics = [];
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _fadeController.forward();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _checkBiometricAvailability() async {
    final biometrics = await BiometricService.getAvailableBiometrics();
    if (mounted) {
      setState(() {
        _availableBiometrics = biometrics;
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _hasError = false;
      _statusMessage = 'Authenticating...';
    });

    HapticFeedback.lightImpact();

    final result = await BiometricService.authenticate(
      localizedReason: 'Unlock D-eyeturn with your biometric credentials',
      useErrorDialogs: false,
      stickyAuth: true,
    );

    if (mounted) {
      if (result.success) {
        HapticFeedback.lightImpact();
        setState(() {
          _statusMessage = 'Authentication successful!';
          _hasError = false;
        });
        
        // Navigate to home screen
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                  const HomeScreen(),
              transitionDuration: const Duration(milliseconds: 800),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.8,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutQuart,
                    )),
                    child: child,
                  ),
                );
              },
            ),
          );
        }
      } else {
        HapticFeedback.heavyImpact();
        _shakeController.forward().then((_) {
          _shakeController.reset();
        });
        
        setState(() {
          _hasError = true;
          _statusMessage = _getErrorMessage(result);
        });
      }
      
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  String _getErrorMessage(BiometricAuthResult result) {
    if (result.error != null) {
      // Handle specific error cases
      if (result.error!.contains('FragmentActivity')) {
        return 'Please restart the app to enable biometric authentication.';
      }
      return result.error!;
    }
    return 'Authentication failed. Please try again.';
  }

  IconData _getBiometricIcon() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return Icons.face;
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    } else {
      return Icons.security;
    }
  }

  String _getBiometricLabel() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else {
      return 'Biometric';
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildBiometricSection(),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
      child: Column(
        children: [
          // D-eyeturn Logo
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
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome Back',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Secure login with ${_getBiometricLabel()}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Biometric Icon
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  _shakeAnimation.value * 10 * ((_shakeAnimation.value * 4).round() % 2 == 0 ? 1 : -1),
                  0,
                ),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isAuthenticating ? 1.0 : _pulseAnimation.value,
                      child: GestureDetector(
                        onTap: _authenticateWithBiometrics,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _hasError 
                                  ? [Colors.red.withOpacity(0.3), Colors.red.withOpacity(0.1)]
                                  : [
                                      const Color(0xFF6C5CE7).withOpacity(0.3),
                                      const Color(0xFF74B9FF).withOpacity(0.1),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: _hasError 
                                  ? Colors.red.withOpacity(0.5)
                                  : const Color(0xFF6C5CE7).withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: _hasError ? null : [
                              BoxShadow(
                                color: const Color(0xFF6C5CE7).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: _isAuthenticating
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF6C5CE7),
                                    strokeWidth: 3,
                                  ),
                                )
                              : Icon(
                                  _getBiometricIcon(),
                                  size: 48,
                                  color: _hasError 
                                      ? Colors.red
                                      : const Color(0xFF6C5CE7),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          const SizedBox(height: 40),
          
          // Status Message
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _statusMessage,
              key: ValueKey(_statusMessage),
              style: TextStyle(
                color: _hasError 
                    ? Colors.red
                    : Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          if (_hasError) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _authenticateWithBiometrics,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              // Navigate to regular login or bypass biometric
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: Text(
              'Skip Biometric Login',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                color: Colors.white.withOpacity(0.4),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Your biometric data is stored securely on your device',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
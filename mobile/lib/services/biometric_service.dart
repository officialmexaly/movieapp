import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  
  /// Check if biometric authentication is available on the device
  static Future<bool> isAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      return isAvailable;
    } catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }
  
  /// Get available biometric types (fingerprint, face, etc.)
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics;
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }
  
  /// Check if device supports biometric authentication
  static Future<bool> isDeviceSupported() async {
    try {
      final bool isSupported = await _localAuth.isDeviceSupported();
      return isSupported;
    } catch (e) {
      print('Error checking device support: $e');
      return false;
    }
  }
  
  /// Authenticate using biometrics
  static Future<BiometricAuthResult> authenticate({
    String localizedReason = 'Please verify your identity to access D-eyeturn',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      // Check if biometrics are available
      final bool isAvailable = await BiometricService.isAvailable();
      if (!isAvailable) {
        return BiometricAuthResult(
          success: false, 
          error: 'Biometric authentication is not available on this device',
          errorType: BiometricAuthError.notAvailable,
        );
      }
      
      // Check if biometrics are enrolled
      final List<BiometricType> availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return BiometricAuthResult(
          success: false, 
          error: 'No biometrics are enrolled on this device. Please set up fingerprint or face recognition in your device settings.',
          errorType: BiometricAuthError.notEnrolled,
        );
      }
      
      // Attempt authentication
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );
      
      if (didAuthenticate) {
        return BiometricAuthResult(
          success: true,
          biometricTypes: availableBiometrics,
        );
      } else {
        return BiometricAuthResult(
          success: false, 
          error: 'Authentication was cancelled or failed',
          errorType: BiometricAuthError.authFailed,
        );
      }
    } on PlatformException catch (e) {
      String errorMessage = 'An error occurred during biometric authentication';
      BiometricAuthError errorType = BiometricAuthError.unknown;
      
      switch (e.code) {
        case 'NotAvailable':
          errorMessage = 'Biometric authentication is not available';
          errorType = BiometricAuthError.notAvailable;
          break;
        case 'NotEnrolled':
          errorMessage = 'No biometrics are enrolled. Please set up fingerprint or face recognition.';
          errorType = BiometricAuthError.notEnrolled;
          break;
        case 'LockedOut':
          errorMessage = 'Too many failed attempts. Biometric authentication is temporarily disabled.';
          errorType = BiometricAuthError.lockedOut;
          break;
        case 'PermanentlyLockedOut':
          errorMessage = 'Biometric authentication is permanently disabled. Please use your device passcode.';
          errorType = BiometricAuthError.permanentlyLockedOut;
          break;
        case 'UserCancel':
          errorMessage = 'Authentication was cancelled by the user';
          errorType = BiometricAuthError.userCancel;
          break;
        case 'UserFallback':
          errorMessage = 'User chose to use fallback authentication';
          errorType = BiometricAuthError.userFallback;
          break;
        case 'SystemCancel':
          errorMessage = 'Authentication was cancelled by the system';
          errorType = BiometricAuthError.systemCancel;
          break;
        case 'InvalidContext':
          errorMessage = 'Invalid authentication context';
          errorType = BiometricAuthError.invalidContext;
          break;
        case 'NotInteractive':
          errorMessage = 'Authentication requires user interaction';
          errorType = BiometricAuthError.notInteractive;
          break;
        default:
          // Handle FragmentActivity error specifically
          if (e.message?.contains('FragmentActivity') == true) {
            errorMessage = 'App configuration issue. Please restart the app to enable biometric authentication.';
            errorType = BiometricAuthError.invalidContext;
          } else {
            errorMessage = e.message ?? 'Unknown biometric error: ${e.code}';
            errorType = BiometricAuthError.unknown;
          }
      }
      
      return BiometricAuthResult(
        success: false, 
        error: errorMessage,
        errorType: errorType,
      );
    } catch (e) {
      return BiometricAuthResult(
        success: false, 
        error: 'Unexpected error: $e',
        errorType: BiometricAuthError.unknown,
      );
    }
  }
  
  /// Check if biometric login is enabled by user
  static Future<bool> isBiometricLoginEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_login') ?? false;
  }
  
  /// Enable or disable biometric login
  static Future<void> setBiometricLoginEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_login', enabled);
  }
  
  /// Get a human-readable description of available biometrics
  static String getBiometricDescription(List<BiometricType> biometrics) {
    if (biometrics.isEmpty) return 'No biometrics available';
    
    List<String> descriptions = [];
    
    if (biometrics.contains(BiometricType.fingerprint)) {
      descriptions.add('fingerprint');
    }
    if (biometrics.contains(BiometricType.face)) {
      descriptions.add('face recognition');
    }
    if (biometrics.contains(BiometricType.iris)) {
      descriptions.add('iris scan');
    }
    if (biometrics.contains(BiometricType.strong)) {
      descriptions.add('strong biometrics');
    }
    if (biometrics.contains(BiometricType.weak)) {
      descriptions.add('weak biometrics');
    }
    
    if (descriptions.length == 1) {
      return descriptions.first;
    } else if (descriptions.length == 2) {
      return '${descriptions.first} or ${descriptions.last}';
    } else {
      return '${descriptions.sublist(0, descriptions.length - 1).join(', ')}, or ${descriptions.last}';
    }
  }
  
  /// Prompt user to enable biometric authentication
  static Future<BiometricAuthResult> promptForBiometricSetup() async {
    return await authenticate(
      localizedReason: 'Enable biometric authentication for secure and convenient access to D-eyeturn',
      useErrorDialogs: true,
      stickyAuth: true,
    );
  }
  
  /// Quick authentication for app access
  static Future<BiometricAuthResult> quickAuth() async {
    return await authenticate(
      localizedReason: 'Unlock D-eyeturn',
      useErrorDialogs: false,
      stickyAuth: false,
    );
  }
}

/// Result of biometric authentication
class BiometricAuthResult {
  final bool success;
  final String? error;
  final BiometricAuthError? errorType;
  final List<BiometricType>? biometricTypes;
  
  const BiometricAuthResult({
    required this.success,
    this.error,
    this.errorType,
    this.biometricTypes,
  });
  
  /// Check if the error is recoverable (user can try again)
  bool get isRecoverable {
    return errorType == BiometricAuthError.authFailed ||
           errorType == BiometricAuthError.userCancel ||
           errorType == BiometricAuthError.systemCancel;
  }
  
  /// Check if the error requires user action (like enrolling biometrics)
  bool get requiresUserAction {
    return errorType == BiometricAuthError.notEnrolled;
  }
  
  /// Check if biometric auth is permanently unavailable
  bool get isPermanentlyUnavailable {
    return errorType == BiometricAuthError.permanentlyLockedOut ||
           errorType == BiometricAuthError.notAvailable;
  }
}

/// Types of biometric authentication errors
enum BiometricAuthError {
  notAvailable,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
  userCancel,
  userFallback,
  systemCancel,
  authFailed,
  invalidContext,
  notInteractive,
  unknown,
}
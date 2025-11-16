import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../services/biometric_service.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // Privacy Settings
  bool _dataCollection = true;
  bool _personalizedAds = false;
  bool _analyticsTracking = true;
  bool _crashReporting = true;
  bool _profileVisibility = false;
  bool _watchHistoryVisible = true;
  
  // Security Settings
  bool _twoFactorAuth = false;
  bool _biometricLogin = false;
  bool _biometricAvailable = false;
  bool _sessionTimeout = true;
  bool _deviceNotifications = true;
  bool _emailSecurityAlerts = true;
  List<BiometricType> _availableBiometrics = [];
  
  // Data Management
  DateTime? _lastDataExport;
  String _dataRetentionPeriod = '2 years';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
    _loadSettings();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  Future<void> _checkBiometricAvailability() async {
    final isAvailable = await BiometricService.isAvailable();
    final biometrics = await BiometricService.getAvailableBiometrics();
    
    if (mounted) {
      setState(() {
        _biometricAvailable = isAvailable && biometrics.isNotEmpty;
        _availableBiometrics = biometrics;
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dataCollection = prefs.getBool('data_collection') ?? true;
      _personalizedAds = prefs.getBool('personalized_ads') ?? false;
      _analyticsTracking = prefs.getBool('analytics_tracking') ?? true;
      _crashReporting = prefs.getBool('crash_reporting') ?? true;
      _profileVisibility = prefs.getBool('profile_visibility') ?? false;
      _watchHistoryVisible = prefs.getBool('watch_history_visible') ?? true;
      
      _twoFactorAuth = prefs.getBool('two_factor_auth') ?? false;
      _biometricLogin = prefs.getBool('biometric_login') ?? false;
      _sessionTimeout = prefs.getBool('session_timeout') ?? true;
      _deviceNotifications = prefs.getBool('device_notifications') ?? true;
      _emailSecurityAlerts = prefs.getBool('email_security_alerts') ?? true;
      
      _dataRetentionPeriod = prefs.getString('data_retention_period') ?? '2 years';
      final exportTimestamp = prefs.getInt('last_data_export');
      if (exportTimestamp != null) {
        _lastDataExport = DateTime.fromMillisecondsSinceEpoch(exportTimestamp);
      }
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('data_collection', _dataCollection);
    await prefs.setBool('personalized_ads', _personalizedAds);
    await prefs.setBool('analytics_tracking', _analyticsTracking);
    await prefs.setBool('crash_reporting', _crashReporting);
    await prefs.setBool('profile_visibility', _profileVisibility);
    await prefs.setBool('watch_history_visible', _watchHistoryVisible);
    
    await prefs.setBool('two_factor_auth', _twoFactorAuth);
    await prefs.setBool('biometric_login', _biometricLogin);
    await prefs.setBool('session_timeout', _sessionTimeout);
    await prefs.setBool('device_notifications', _deviceNotifications);
    await prefs.setBool('email_security_alerts', _emailSecurityAlerts);
    
    await prefs.setString('data_retention_period', _dataRetentionPeriod);
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildAccountSecurity(),
                      const SizedBox(height: 32),
                      _buildPrivacySettings(),
                      const SizedBox(height: 32),
                      _buildDataManagement(),
                      const SizedBox(height: 32),
                      _buildSecurityLogs(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0D0D0D).withOpacity(0.98),
            const Color(0xFF0D0D0D).withOpacity(0.0),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
          ),
          const Expanded(
            child: Text(
              'Privacy & Security',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAccountSecurity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Color(0xFF6C5CE7),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Account Security',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            _buildSecurityOption(
              'Change Password',
              'Update your account password',
              Icons.lock_outline,
              () => _showChangePasswordDialog(),
            ),
            _buildDivider(),
            _buildToggleOption(
              'Two-Factor Authentication',
              'Add an extra layer of security to your account',
              Icons.verified_user_outlined,
              _twoFactorAuth,
              (value) {
                setState(() => _twoFactorAuth = value);
                _saveSettings();
                if (value) {
                  _showTwoFactorSetupDialog();
                }
              },
            ),
            _buildDivider(),
            _buildBiometricOption(),
            _buildDivider(),
            _buildToggleOption(
              'Automatic Session Timeout',
              'Sign out after 30 minutes of inactivity',
              Icons.timer_outlined,
              _sessionTimeout,
              (value) {
                setState(() => _sessionTimeout = value);
                _saveSettings();
              },
            ),
            _buildDivider(),
            _buildToggleOption(
              'New Device Notifications',
              'Get notified when your account is accessed from a new device',
              Icons.devices_outlined,
              _deviceNotifications,
              (value) {
                setState(() => _deviceNotifications = value);
                _saveSettings();
              },
            ),
            _buildDivider(),
            _buildToggleOption(
              'Email Security Alerts',
              'Receive security alerts via email',
              Icons.email_outlined,
              _emailSecurityAlerts,
              (value) {
                setState(() => _emailSecurityAlerts = value);
                _saveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: Color(0xFF74B9FF),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Privacy Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            _buildToggleOption(
              'Data Collection',
              'Allow D-eyeturn to collect usage data to improve services',
              Icons.analytics_outlined,
              _dataCollection,
              (value) {
                setState(() => _dataCollection = value);
                _saveSettings();
              },
            ),
            _buildDivider(),
            _buildToggleOption(
              'Personalized Ads',
              'Show ads based on your interests and viewing history',
              Icons.ads_click_outlined,
              _personalizedAds,
              (value) {
                setState(() => _personalizedAds = value);
                _saveSettings();
              },
            ),
            _buildDivider(),
            _buildToggleOption(
              'Analytics Tracking',
              'Help us understand how you use D-eyeturn',
              Icons.track_changes_outlined,
              _analyticsTracking,
              (value) {
                setState(() => _analyticsTracking = value);
                _saveSettings();
              },
            ),
            _buildDivider(),
            _buildToggleOption(
              'Crash Reporting',
              'Automatically send crash reports to help fix issues',
              Icons.bug_report_outlined,
              _crashReporting,
              (value) {
                setState(() => _crashReporting = value);
                _saveSettings();
              },
            ),
            _buildDivider(),
            _buildToggleOption(
              'Public Profile',
              'Make your profile visible to other users',
              Icons.public,
              _profileVisibility,
              (value) {
                setState(() => _profileVisibility = value);
                _saveSettings();
              },
            ),
            _buildDivider(),
            _buildToggleOption(
              'Watch History Visibility',
              'Show your watch history on your profile',
              Icons.history,
              _watchHistoryVisible,
              (value) {
                setState(() => _watchHistoryVisible = value);
                _saveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataManagement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.storage,
                    color: Color(0xFF00D2D3),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Data Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            _buildDataOption(
              'Export Your Data',
              _lastDataExport != null
                  ? 'Last export: ${_formatDate(_lastDataExport!)}'
                  : 'Download a copy of your D-eyeturn data',
              Icons.download_outlined,
              () => _exportData(),
            ),
            _buildDivider(),
            _buildDataOption(
              'Data Retention',
              'Your data is kept for: $_dataRetentionPeriod',
              Icons.schedule,
              () => _showDataRetentionDialog(),
            ),
            _buildDivider(),
            _buildDataOption(
              'Clear Watch History',
              'Remove all your viewing history',
              Icons.clear_all,
              () => _showClearHistoryDialog(),
            ),
            _buildDivider(),
            _buildDataOption(
              'Clear Search History',
              'Remove all your search queries',
              Icons.search_off,
              () => _clearSearchHistory(),
            ),
            _buildDivider(),
            _buildDataOption(
              'Delete Account',
              'Permanently delete your D-eyeturn account',
              Icons.delete_forever_outlined,
              () => _showDeleteAccountDialog(),
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityLogs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.list_alt,
                    color: Color(0xFFE17055),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Security Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            _buildSecurityOption(
              'Login Activity',
              'View recent login attempts and locations',
              Icons.login,
              () => _showLoginActivity(),
            ),
            _buildDivider(),
            _buildSecurityOption(
              'Connected Devices',
              'Manage devices connected to your account',
              Icons.devices,
              () => _showConnectedDevices(),
            ),
            _buildDivider(),
            _buildSecurityOption(
              'Privacy Policy',
              'Read our privacy policy and terms',
              Icons.policy_outlined,
              () => _showPrivacyPolicy(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF74B9FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF74B9FF),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6C5CE7),
            activeTrackColor: const Color(0xFF6C5CE7).withOpacity(0.3),
            inactiveThumbColor: Colors.white.withOpacity(0.8),
            inactiveTrackColor: Colors.white.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF6C5CE7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.4),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (textColor ?? const Color(0xFF00D2D3)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: textColor ?? const Color(0xFF00D2D3),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.4),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricOption() {
    final String subtitle = _biometricAvailable
        ? _availableBiometrics.isNotEmpty
            ? 'Use ${BiometricService.getBiometricDescription(_availableBiometrics)}'
            : 'No biometrics enrolled on this device'
        : 'Biometric authentication not available';

    return Opacity(
      opacity: _biometricAvailable ? 1.0 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF74B9FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getBiometricIcon(),
                color: const Color(0xFF74B9FF),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biometric Login',
                    style: TextStyle(
                      color: _biometricAvailable ? Colors.white : Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!_biometricAvailable && _availableBiometrics.isEmpty)
                    GestureDetector(
                      onTap: _showBiometricSetupDialog,
                      child: Text(
                        'Set up in device settings',
                        style: TextStyle(
                          color: const Color(0xFF6C5CE7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Switch(
              value: _biometricLogin && _biometricAvailable,
              onChanged: _biometricAvailable ? _handleBiometricToggle : null,
              activeColor: const Color(0xFF6C5CE7),
              activeTrackColor: const Color(0xFF6C5CE7).withOpacity(0.3),
              inactiveThumbColor: Colors.white.withOpacity(0.8),
              inactiveTrackColor: Colors.white.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
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

  Future<void> _handleBiometricToggle(bool value) async {
    if (value) {
      // Enable biometric login - require authentication first
      final result = await BiometricService.promptForBiometricSetup();
      
      if (result.success) {
        setState(() => _biometricLogin = true);
        await BiometricService.setBiometricLoginEnabled(true);
        await _saveSettings();
        _showSnackBar('Biometric login enabled successfully!');
      } else {
        _showBiometricErrorDialog(result);
      }
    } else {
      // Disable biometric login
      _showDisableBiometricDialog();
    }
  }

  void _showBiometricSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              _getBiometricIcon(),
              color: const Color(0xFF6C5CE7),
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Biometric Setup',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'To use biometric authentication, you need to set up fingerprint or face recognition in your device settings first.\n\nGo to Settings > Security > Biometrics to set up your preferred authentication method.',
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showBiometricErrorDialog(BiometricAuthResult result) {
    String title = 'Authentication Failed';
    String message = result.error ?? 'Unable to enable biometric authentication.';
    
    if (result.errorType == BiometricAuthError.notEnrolled) {
      title = 'No Biometrics Enrolled';
      message = 'Please set up fingerprint or face recognition in your device settings first.';
    } else if (result.errorType == BiometricAuthError.lockedOut) {
      title = 'Biometric Locked';
      message = 'Too many failed attempts. Please try again later or use your device passcode.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(color: Colors.red)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisableBiometricDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Disable Biometric Login', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to disable biometric login? You will need to use your regular login credentials.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _biometricLogin = false);
              await BiometricService.setBiometricLoginEnabled(false);
              await _saveSettings();
              _showSnackBar('Biometric login disabled');
            },
            child: const Text(
              'Disable',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Dialog and action methods
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => ChangePasswordDialog(),
    );
  }

  void _showTwoFactorSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => TwoFactorSetupDialog(),
    );
  }

  void _showDataRetentionDialog() {
    showDialog(
      context: context,
      builder: (context) => DataRetentionDialog(
        currentPeriod: _dataRetentionPeriod,
        onChanged: (period) {
          setState(() => _dataRetentionPeriod = period);
          _saveSettings();
        },
      ),
    );
  }

  Future<void> _exportData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_data_export', DateTime.now().millisecondsSinceEpoch);
    setState(() {
      _lastDataExport = DateTime.now();
    });
    _showSnackBar('Data export initiated. You\'ll receive an email when ready.');
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Watch History', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will permanently delete your entire watch history. This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white.withOpacity(0.7))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Watch history cleared');
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearSearchHistory() {
    _showSnackBar('Search history cleared');
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => DeleteAccountDialog(),
    );
  }

  void _showLoginActivity() {
    _showSnackBar('Opening login activity...');
  }

  void _showConnectedDevices() {
    _showSnackBar('Opening connected devices...');
  }

  void _showPrivacyPolicy() {
    _showSnackBar('Opening privacy policy...');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF74B9FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// Supporting Dialog Widgets
class ChangePasswordDialog extends StatefulWidget {
  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Change Password', style: TextStyle(color: Colors.white)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPasswordField(_currentPasswordController, 'Current Password'),
            const SizedBox(height: 16),
            _buildPasswordField(_newPasswordController, 'New Password'),
            const SizedBox(height: 16),
            _buildPasswordField(_confirmPasswordController, 'Confirm New Password'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.white.withOpacity(0.7))),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully')),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C5CE7)),
          child: const Text('Change', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.white.withOpacity(0.7),
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (label.contains('New') && value.length < 8) return 'Must be at least 8 characters';
        if (label.contains('Confirm') && value != _newPasswordController.text) {
          return 'Passwords don\'t match';
        }
        return null;
      },
    );
  }
}

class TwoFactorSetupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Setup Two-Factor Authentication', style: TextStyle(color: Colors.white)),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Two-factor authentication adds an extra layer of security to your account.',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 16),
          Text(
            '1. Download an authenticator app\n2. Scan the QR code\n3. Enter the verification code',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.white.withOpacity(0.7))),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Two-factor authentication will be set up')),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C5CE7)),
          child: const Text('Continue', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class DataRetentionDialog extends StatefulWidget {
  final String currentPeriod;
  final Function(String) onChanged;

  const DataRetentionDialog({
    super.key,
    required this.currentPeriod,
    required this.onChanged,
  });

  @override
  State<DataRetentionDialog> createState() => _DataRetentionDialogState();
}

class _DataRetentionDialogState extends State<DataRetentionDialog> {
  late String _selectedPeriod;
  final List<String> _periods = ['1 year', '2 years', '3 years', '5 years', 'Indefinite'];

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.currentPeriod;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Data Retention Period', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _periods.map((period) {
          return RadioListTile<String>(
            value: period,
            groupValue: _selectedPeriod,
            onChanged: (value) => setState(() => _selectedPeriod = value!),
            title: Text(period, style: const TextStyle(color: Colors.white)),
            activeColor: const Color(0xFF6C5CE7),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.white.withOpacity(0.7))),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onChanged(_selectedPeriod);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C5CE7)),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class DeleteAccountDialog extends StatefulWidget {
  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _confirmationController = TextEditingController();
  bool _canDelete = false;

  @override
  void initState() {
    super.initState();
    _confirmationController.addListener(() {
      setState(() {
        _canDelete = _confirmationController.text == 'DELETE';
      });
    });
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This action cannot be undone. This will permanently delete your account and all associated data.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          const Text(
            'Type "DELETE" to confirm:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _confirmationController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.white.withOpacity(0.7))),
        ),
        ElevatedButton(
          onPressed: _canDelete
              ? () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deletion initiated'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            disabledBackgroundColor: Colors.red.withOpacity(0.3),
          ),
          child: const Text('Delete Account', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AppBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF0D0D0D).withOpacity(0.95),
            const Color(0xFF0D0D0D),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF74B9FF).withOpacity(0.2),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCustomNavItem(Icons.home_rounded, 'Home', 0),
                  _buildCustomNavItem(Icons.explore_rounded, 'Discover', 1),
                  _buildCustomNavItem(Icons.notifications_rounded, 'Inbox', 2),
                  _buildCustomNavItem(Icons.person_rounded, 'Profile', 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomNavItem(IconData icon, String label, int index) {
    final isSelected = widget.selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap(index);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final scale = isSelected ? _scaleAnimation.value : 1.0;
          final glow = isSelected ? _glowAnimation.value : 0.0;
          
          return Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with glow effect
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? RadialGradient(
                              colors: [
                                const Color(0xFF74B9FF).withOpacity(0.3),
                                const Color(0xFF74B9FF).withOpacity(0.1),
                                Colors.transparent,
                              ],
                            )
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF74B9FF).withOpacity(0.4 * glow),
                                blurRadius: 15 * glow,
                                spreadRadius: 2 * glow,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF74B9FF).withOpacity(0.2)
                              : Colors.transparent,
                        ),
                        child: Icon(
                          icon,
                          size: 20,
                          color: isSelected
                              ? const Color(0xFF74B9FF)
                              : const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Label with animation
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: isSelected ? 12 : 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF74B9FF)
                          : const Color(0xFF666666),
                      letterSpacing: 0.2,
                    ),
                    child: Text(label),
                  ),
                  
                  // Selection indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 6 : 0,
                    height: 2,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF74B9FF),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
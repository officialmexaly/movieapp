import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/featured_movie.dart';
import '../widgets/genre_chip.dart';

class FeaturedCard extends StatelessWidget {
  final FeaturedMovie movie;
  final Animation<double> scaleAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> pulseAnimation;

  const FeaturedCard({
    super.key,
    required this.movie,
    required this.scaleAnimation,
    required this.slideAnimation,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Container(
            height: 420,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Enhanced background with animated gradients
                  Container(
                    decoration: BoxDecoration(
                      gradient: movie.gradient,
                    ),
                  ),
                  // Animated overlay effects
                  AnimatedBuilder(
                    animation: pulseAnimation,
                    builder: (context, child) {
                      return Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(
                                0.3 * pulseAnimation.value,
                                -0.4 * pulseAnimation.value,
                              ),
                              radius: 2.0 * pulseAnimation.value,
                              colors: [
                                const Color(0xFF00CEC9).withOpacity(0.3),
                                const Color(0xFF74B9FF).withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Dark overlay with better gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0x22000000),
                          Color(0x44000000),
                          Color(0xDD000000),
                        ],
                        stops: [0.0, 0.3, 0.6, 1.0],
                      ),
                    ),
                  ),
                  // Netflix Series badge
                  if (movie.isNetflixSeries)
                    Positioned(
                      top: 24,
                      left: 24,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE50914),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'N',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'SERIES',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Content
                  Positioned(
                    bottom: 100,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                              height: 1.1,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: movie.genres
                                .map<Widget>((genre) => GenreChip(text: genre))
                                .toList(),
                          ),
                        ),
                        if (movie.subtitle != null) ...[ 
                          const SizedBox(height: 12),
                          Text(
                            movie.subtitle!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Enhanced action buttons
                  Positioned(
                    bottom: 16,
                    left: 24,
                    right: 24,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildNetflixButton(
                            icon: Icons.play_arrow_rounded,
                            label: 'Play',
                            isPrimary: true,
                            onTap: () {
                              HapticFeedback.mediumImpact();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildNetflixButton(
                            icon: Icons.add_rounded,
                            label: 'My List',
                            isPrimary: false,
                            onTap: () {
                              HapticFeedback.lightImpact();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetflixButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.white : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.black : Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.black : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
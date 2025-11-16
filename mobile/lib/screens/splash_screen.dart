import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'app_entry_screen.dart';
import '../services/tmdb_service.dart';
import '../models/movie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _postersAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _buttonAnimationController;

  late Animation<double> _postersOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _buttonScaleAnimation;

  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadMovies();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _postersAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _postersOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _postersAnimationController,
      curve: Curves.easeInOut,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOutQuart,
    ));

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _loadMovies() async {
    try {
      final movies = await TMDBService.getPopularMovies();
      if (mounted) {
        setState(() {
          _movies = movies.take(6).toList();
        });
      }
    } catch (e) {
      // Use fallback if API fails
      print('Failed to load movies for splash: $e');
    }
  }

  void _startSplashSequence() {
    _postersAnimationController.forward();
    
    Timer(const Duration(milliseconds: 500), () {
      _textAnimationController.forward();
    });

    Timer(const Duration(milliseconds: 1000), () {
      _buttonAnimationController.forward();
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AppEntryScreen(),
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
  void dispose() {
    _postersAnimationController.dispose();
    _textAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _postersAnimationController,
          _textAnimationController,
          _buttonAnimationController,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              // Movie posters background with parallax effect
              FadeTransition(
                opacity: _postersOpacityAnimation,
                child: _buildMoviePostersBackground(),
              ),
              
              // Floating engagement elements
              ..._buildFloatingElements(),
              
              // Dark gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.95),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
              
              // Simple Modern Content Layout
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      
                      // Clean Logo Section
                      SlideTransition(
                        position: _textSlideAnimation,
                        child: FadeTransition(
                          opacity: _textOpacityAnimation,
                          child: Column(
                            children: [
                              // Minimal App Icon
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF74B9FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Clean Brand Name
                              const Text(
                                'D-eyeturn',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Simple tagline
                              Text(
                                'Gateway to Unlimited Movie Magic!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.8),
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              Text(
                                'Seamless streaming on-the-go',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const Spacer(flex: 3),
                      
                      // Clean Action Buttons
                      ScaleTransition(
                        scale: _buttonScaleAnimation,
                        child: Column(
                          children: [
                            // Primary Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () => _navigateToHome(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF74B9FF),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "Let's start",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Secondary Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton(
                                onPressed: () => _navigateToHome(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Visit Website',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildFloatingElements() {
    return List.generate(8, (index) {
      final random = Random(index * 13);
      return Positioned(
        left: random.nextDouble() * 300,
        top: 50 + (random.nextDouble() * 400),
        child: AnimatedBuilder(
          animation: _postersAnimationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                sin(_postersOpacityAnimation.value * pi * 2 + index) * 15,
                cos(_postersOpacityAnimation.value * pi * 1.5 + index) * 20,
              ),
              child: Opacity(
                opacity: 0.3 + (0.2 * sin(_postersOpacityAnimation.value * pi * 2 + index)),
                child: Container(
                  width: 30 + (index % 3) * 10,
                  height: 30 + (index % 3) * 10,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF74B9FF).withOpacity(0.2),
                        const Color(0xFF00D2D3).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildMoviePostersBackground() {
    if (_movies.isEmpty) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C5CE7),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // First row - 3 posters
          Positioned(
            top: 60,
            left: -20,
            child: AnimatedBuilder(
              animation: _postersAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -0.1 + (0.02 * sin(_postersOpacityAnimation.value * pi * 2)),
                  child: _buildPosterCard(_movies[0], 120, 160),
                );
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 120,
            child: AnimatedBuilder(
              animation: _postersAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: 0.05 + (0.03 * cos(_postersOpacityAnimation.value * pi * 1.5)),
                  child: _buildPosterCard(_movies[1], 140, 180),
                );
              },
            ),
          ),
          Positioned(
            top: 80,
            right: -10,
            child: AnimatedBuilder(
              animation: _postersAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: 0.1 + (0.02 * sin(_postersOpacityAnimation.value * pi * 3)),
                  child: _buildPosterCard(_movies[2], 110, 150),
                );
              },
            ),
          ),
          
          // Second row - 3 posters
          Positioned(
            top: 280,
            left: 40,
            child: AnimatedBuilder(
              animation: _postersAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: 0.08 + (0.02 * cos(_postersOpacityAnimation.value * pi * 2.5)),
                  child: _buildPosterCard(_movies[3], 130, 170),
                );
              },
            ),
          ),
          Positioned(
            top: 300,
            right: 30,
            child: AnimatedBuilder(
              animation: _postersAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -0.08 + (0.03 * sin(_postersOpacityAnimation.value * pi * 1.8)),
                  child: _buildPosterCard(_movies[4], 125, 165),
                );
              },
            ),
          ),
          if (_movies.length > 5)
            Positioned(
              top: 240,
              left: 160,
              child: AnimatedBuilder(
                animation: _postersAnimationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: 0.12 + (0.02 * cos(_postersOpacityAnimation.value * pi * 3.2)),
                    child: _buildPosterCard(_movies[5], 100, 140),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPosterCard(Movie movie, double width, double height) {
    return AnimatedBuilder(
      animation: _postersAnimationController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C5CE7).withOpacity(
                  0.3 + (0.2 * sin(_postersOpacityAnimation.value * pi * 2)),
                ),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.network(
                  TMDBService.getImageUrl(movie.posterPath),
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.movie_rounded,
                        color: Colors.white54,
                        size: 40,
                      ),
                    );
                  },
                ),
                // FluxShorts glow overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF74B9FF).withOpacity(0.1),
                        Colors.transparent,
                        const Color(0xFF00D2D3).withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
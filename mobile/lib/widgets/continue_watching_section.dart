import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import 'movie_card.dart';

class ContinueWatchingSection extends StatefulWidget {
  final AnimationController scrollAnimation;

  const ContinueWatchingSection({
    super.key,
    required this.scrollAnimation,
  });

  @override
  State<ContinueWatchingSection> createState() => _ContinueWatchingSectionState();
}

class _ContinueWatchingSectionState extends State<ContinueWatchingSection> {
  List<Movie> _continueWatchingMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContinueWatchingMovies();
  }

  Future<void> _loadContinueWatchingMovies() async {
    try {
      final movies = await TMDBService.getNowPlayingMovies();
      if (mounted) {
        setState(() {
          _continueWatchingMovies = movies.take(8).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (_continueWatchingMovies.isEmpty) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: widget.scrollAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: widget.scrollAnimation,
          curve: Curves.easeOutQuart,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Pick Up Where You Left Off',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _continueWatchingMovies.length,
                itemBuilder: (context, index) {
                  return _buildContinueWatchingCard(_continueWatchingMovies[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueWatchingCard(Movie movie, int index) {
    // Generate a random progress between 0.2 and 0.8
    final progress = 0.2 + (index % 3) * 0.2 + 0.1;
    
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          MovieCard(
            movie: movie,
            width: 140,
            height: 200,
            showTitle: true,
            showRating: false,
          ),
          // Progress bar overlay at bottom
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF74B9FF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          // Play button overlay
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF74B9FF),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_card.dart';
import '../widgets/app_header.dart';
import '../widgets/category_filters.dart';
import '../widgets/todays_top_picks.dart';
import '../widgets/continue_watching_section.dart';
import '../widgets/movie_category_section.dart';
import '../widgets/bottom_navigation.dart';
import 'search_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _currentMovieIndex = 0;
  Timer? _slideTimer;
  
  List<Movie> _featuredMovies = [];
  Map<String, List<Movie>> _movieCategories = {};
  List<Movie> _filteredMovies = [];
  String _selectedGenre = 'All';
  bool _isLoading = true;
  
  late AnimationController _headerAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _scrollAnimationController;
  late AnimationController _pulseAnimationController;
  
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      // Load featured movies first
      final featuredMovies = await TMDBService.getTrendingMovies();
      
      if (mounted) {
        setState(() {
          _featuredMovies = featuredMovies;
        });
      }

      // Define all movie categories with modern titles
      final categoryFutures = <String, Future<List<Movie>>>{
        'Editor\'s Picks': TMDBService.getTopPicks(),
        'Viral Right Now': TMDBService.getViralContent(),
        'Trending This Week': TMDBService.getTrendingThisWeek(),
        'What\'s Hot': TMDBService.getPopularMovies(),
        'Award Winners': TMDBService.getAwardWinningMovies(),
        'Blockbuster Hits': TMDBService.getBlockbusterHits(),
        'Hidden Gems': TMDBService.getHiddenGems(),
        'Cult Classics': TMDBService.getCultClassics(),
        'Indie Favorites': TMDBService.getIndieFavorites(),
        'Fresh Releases': TMDBService.getRecentReleases(),
        'Classic Collection': TMDBService.getClassicMovies(),
        'Top Rated': TMDBService.getTopRatedMovies(),
        'Coming Soon': TMDBService.getUpcomingMovies(),
        'Now Playing': TMDBService.getNowPlayingMovies(),
        'Highly Rated': TMDBService.getHighRatedMovies(),
        
        // Genre Categories
        'Action & Adventure': TMDBService.getActionMovies(),
        'Epic Adventures': TMDBService.getAdventureMovies(),
        'Laugh Out Loud': TMDBService.getComedyMovies(),
        'Heart & Soul': TMDBService.getDramaMovies(),
        'Love Stories': TMDBService.getRomanceMovies(),
        'Mind Benders': TMDBService.getThrillerMovies(),
        'Criminal Minds': TMDBService.getCrimeMovies(),
        'Chills & Thrills': TMDBService.getHorrorMovies(),
        'Mystery & Suspense': TMDBService.getMysteryMovies(),
        'Future Worlds': TMDBService.getSciFiMovies(),
        'Magic & Fantasy': TMDBService.getFantasyMovies(),
        'Family Fun': TMDBService.getFamilyMovies(),
        'Animated Adventures': TMDBService.getAnimationMovies(),
        'Real Stories': TMDBService.getDocumentaryMovies(),
        'Music & Rhythm': TMDBService.getMusicMovies(),
        'Historical Tales': TMDBService.getHistoryMovies(),
        'War Stories': TMDBService.getWarMovies(),
        'Wild West': TMDBService.getWesternMovies(),
        
        // Special My List category
        'My List': TMDBService.getMyListMovies(),
      };

      // Load categories in batches to avoid overwhelming the API
      final categoryEntries = categoryFutures.entries.toList();
      const batchSize = 5;
      
      for (int i = 0; i < categoryEntries.length; i += batchSize) {
        final batch = categoryEntries.skip(i).take(batchSize);
        final batchFutures = {
          for (var entry in batch) entry.key: entry.value
        };
        
        final batchResults = await Future.wait(batchFutures.values);
        final batchKeys = batchFutures.keys.toList();
        
        if (mounted) {
          setState(() {
            for (int j = 0; j < batchResults.length; j++) {
              _movieCategories[batchKeys[j]] = batchResults[j];
            }
          });
        }
        
        // Small delay between batches to respect API rate limits
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _filterMoviesByGenre();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('Error loading movies: $e');
      }
    }
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    
    _scrollAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutExpo,
    ));

    _cardScaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOutQuart,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations with delay to ensure proper mounting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerAnimationController.forward();
      _pulseAnimationController.repeat(reverse: true);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _cardAnimationController.forward();
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _scrollAnimationController.forward();
      });
      _startAutoSlide();
    });
  }

  void _startAutoSlide() {
    _slideTimer = Timer.periodic(const Duration(minutes: 3), (timer) {
      if (mounted && _featuredMovies.isNotEmpty) {
        setState(() {
          _currentMovieIndex = (_currentMovieIndex + 1) % _featuredMovies.length;
        });
        // Restart card animation for smooth transition
        _cardAnimationController.reset();
        _cardAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    _headerAnimationController.dispose();
    _cardAnimationController.dispose();
    _scrollAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C5CE7),
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            FadeTransition(
              opacity: _headerFadeAnimation,
              child: const AppHeader(),
            ),
            FadeTransition(
              opacity: _headerFadeAnimation,
              child: CategoryFilters(
                onCategoryChanged: _onCategoryChanged,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_featuredMovies.isNotEmpty)
                      FeaturedMovieCard(
                        movie: _featuredMovies[_currentMovieIndex],
                        scaleAnimation: _cardScaleAnimation,
                        slideAnimation: _cardSlideAnimation,
                        pulseAnimation: _pulseAnimation,
                      ),
                    const SizedBox(height: 16),
                    
                    // Show first category as Top Picks if available
                    if (_movieCategories.containsKey('Editor\'s Picks') && _movieCategories['Editor\'s Picks']!.isNotEmpty)
                      TodaysTopPicks(
                        movies: _movieCategories['Editor\'s Picks']!.take(10).toList(),
                        scrollAnimation: _scrollAnimationController,
                      ),
                    const SizedBox(height: 32),
                    
                    // Show second category as Top 10 if available
                    if (_movieCategories.containsKey('Viral Right Now') && _movieCategories['Viral Right Now']!.isNotEmpty)
                      Top10Section(
                        movies: _movieCategories['Viral Right Now']!.take(10).toList(),
                        scrollAnimation: _scrollAnimationController,
                      ),
                    const SizedBox(height: 32),
                    
                    ContinueWatchingSection(
                      scrollAnimation: _scrollAnimationController,
                    ),
                    const SizedBox(height: 32),
                    
                    // Filtered movies by genre
                    if (_selectedGenre != 'All' && _filteredMovies.isNotEmpty)
                      Column(
                        children: [
                          MovieCategorySection(
                            title: _selectedGenre == 'All' ? 'All Movies' : '$_selectedGenre Movies',
                            movies: _filteredMovies.take(20).toList(),
                            scrollAnimation: _scrollAnimationController,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    
                    // Display all movie categories except My List
                    ..._movieCategories.entries.where((entry) => 
                      entry.key != 'Editor\'s Picks' && 
                      entry.key != 'Viral Right Now' && 
                      entry.key != 'My List' &&
                      entry.value.isNotEmpty
                    ).map((entry) => Column(
                      children: [
                        MovieCategorySection(
                          title: entry.key,
                          movies: entry.value,
                          scrollAnimation: _scrollAnimationController,
                        ),
                        const SizedBox(height: 32),
                      ],
                    )).toList(),
                    
                    // Display My List section with real TMDB movies
                    if (_movieCategories.containsKey('My List') && _movieCategories['My List']!.isNotEmpty)
                      MyListSection(
                        scrollAnimation: _scrollAnimationController,
                        myListMovies: _movieCategories['My List']!,
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedIndex = index;
          });
          
          // Navigate to search screen when "Discover" is tapped
          if (index == 1) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => 
                    const SearchScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          }
          
          // Navigate to profile screen when "Profile" is tapped
          if (index == 3) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => 
                    const ProfileScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutQuart,
                    )),
                    child: child,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedGenre = category;
    });
    _filterMoviesByGenre();
  }

  void _filterMoviesByGenre() {
    if (_selectedGenre == 'All') {
      // Show all movies from all categories
      final allMovies = <Movie>[];
      _movieCategories.values.forEach((movies) {
        allMovies.addAll(movies);
      });
      // Remove duplicates
      final uniqueMovies = <Movie>[];
      final seenIds = <int>{};
      for (final movie in allMovies) {
        if (!seenIds.contains(movie.id)) {
          uniqueMovies.add(movie);
          seenIds.add(movie.id);
        }
      }
      setState(() {
        _filteredMovies = uniqueMovies;
      });
      return;
    }

    // Filter by genre
    final genreIdMap = <String, int>{
      'Action': 28,
      'Adventure': 12,
      'Animation': 16,
      'Comedy': 35,
      'Crime': 80,
      'Documentary': 99,
      'Drama': 18,
      'Family': 10751,
      'Fantasy': 14,
      'Horror': 27,
      'Music': 10402,
      'Mystery': 9648,
      'Romance': 10749,
      'Sci-Fi': 878,
      'Thriller': 53,
      'War': 10752,
      'Western': 37,
    };

    final genreId = genreIdMap[_selectedGenre];
    if (genreId == null) {
      setState(() {
        _filteredMovies = [];
      });
      return;
    }

    // Get movies from all categories and filter by genre
    final allMovies = <Movie>[];
    _movieCategories.values.forEach((movies) {
      allMovies.addAll(movies);
    });

    final filteredMovies = allMovies.where((movie) {
      return movie.genreIds.contains(genreId);
    }).toList();

    // Remove duplicates
    final uniqueMovies = <Movie>[];
    final seenIds = <int>{};
    for (final movie in filteredMovies) {
      if (!seenIds.contains(movie.id)) {
        uniqueMovies.add(movie);
        seenIds.add(movie.id);
      }
    }

    setState(() {
      _filteredMovies = uniqueMovies;
    });
  }
}
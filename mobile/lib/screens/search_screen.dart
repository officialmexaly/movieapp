import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _filterAnimationController;
  late Animation<double> _filterSlideAnimation;
  
  Timer? _debounceTimer;
  bool _isSearching = false;
  bool _showFilters = false;
  
  // Search results
  List<Movie> _searchResults = [];
  List<Movie> _filteredResults = [];
  
  // Filter states
  final List<String> _selectedGenres = [];
  double _minYear = 1990;
  double _maxYear = 2024;
  double _minRating = 0.0;
  String _sortBy = 'popularity.desc';
  
  // Available filter options
  final List<Map<String, dynamic>> _genres = [
    {'id': 28, 'name': 'Action'},
    {'id': 12, 'name': 'Adventure'},
    {'id': 16, 'name': 'Animation'},
    {'id': 35, 'name': 'Comedy'},
    {'id': 80, 'name': 'Crime'},
    {'id': 99, 'name': 'Documentary'},
    {'id': 18, 'name': 'Drama'},
    {'id': 10751, 'name': 'Family'},
    {'id': 14, 'name': 'Fantasy'},
    {'id': 27, 'name': 'Horror'},
    {'id': 10402, 'name': 'Music'},
    {'id': 9648, 'name': 'Mystery'},
    {'id': 10749, 'name': 'Romance'},
    {'id': 878, 'name': 'Sci-Fi'},
    {'id': 53, 'name': 'Thriller'},
    {'id': 10752, 'name': 'War'},
    {'id': 37, 'name': 'Western'},
  ];
  
  final List<String> _sortOptions = [
    'popularity.desc',
    'popularity.asc',
    'release_date.desc',
    'release_date.asc',
    'vote_average.desc',
    'vote_average.asc',
    'original_title.asc',
    'original_title.desc',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeAnimations();
    _loadPopularMovies();
  }

  void _initializeAnimations() {
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _filterSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeOutQuart,
    ));
  }

  Future<void> _loadPopularMovies() async {
    setState(() {
      _isSearching = true;
    });

    try {
      final movies = await TMDBService.getPopularMovies();
      if (mounted) {
        setState(() {
          _searchResults = movies;
          _filteredResults = movies;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    
    if (query.isEmpty) {
      _loadPopularMovies();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await TMDBService.searchMovies(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _applyFilters();
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _applyFilters() {
    List<Movie> filtered = List.from(_searchResults);

    // Apply genre filter
    if (_selectedGenres.isNotEmpty) {
      final selectedGenreIds = _genres
          .where((genre) => _selectedGenres.contains(genre['name']))
          .map((genre) => genre['id'] as int)
          .toList();
      
      filtered = filtered.where((movie) {
        return movie.genreIds.any((id) => selectedGenreIds.contains(id));
      }).toList();
    }

    // Apply year filter
    filtered = filtered.where((movie) {
      if (movie.releaseDate == null) return false;
      final year = movie.releaseDate!.year;
      return year >= _minYear && year <= _maxYear;
    }).toList();

    // Apply rating filter
    filtered = filtered.where((movie) {
      return movie.voteAverage >= _minRating;
    }).toList();

    // Apply sorting
    _sortMovies(filtered);

    setState(() {
      _filteredResults = filtered;
    });
  }

  void _sortMovies(List<Movie> movies) {
    switch (_sortBy) {
      case 'popularity.desc':
        movies.sort((a, b) => b.popularity.compareTo(a.popularity));
        break;
      case 'popularity.asc':
        movies.sort((a, b) => a.popularity.compareTo(b.popularity));
        break;
      case 'release_date.desc':
        movies.sort((a, b) => (b.releaseDate ?? DateTime(1900))
            .compareTo(a.releaseDate ?? DateTime(1900)));
        break;
      case 'release_date.asc':
        movies.sort((a, b) => (a.releaseDate ?? DateTime(1900))
            .compareTo(b.releaseDate ?? DateTime(1900)));
        break;
      case 'vote_average.desc':
        movies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
        break;
      case 'vote_average.asc':
        movies.sort((a, b) => a.voteAverage.compareTo(b.voteAverage));
        break;
      case 'original_title.asc':
        movies.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'original_title.desc':
        movies.sort((a, b) => b.title.compareTo(a.title));
        break;
    }
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
    
    if (_showFilters) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedGenres.clear();
      _minYear = 1990;
      _maxYear = 2024;
      _minRating = 0.0;
      _sortBy = 'popularity.desc';
    });
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _filterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_showFilters) _buildFiltersSection(),
          _buildResultsHeader(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0D0D0D),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Search Movies',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
            color: _showFilters ? const Color(0xFF74B9FF) : Colors.white,
          ),
          onPressed: _toggleFilters,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search movies...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF74B9FF),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white54,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _loadPopularMovies();
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return AnimatedBuilder(
      animation: _filterSlideAnimation,
      builder: (context, child) {
        return Container(
          height: _filterSlideAnimation.value * 320,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          color: Color(0xFF74B9FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Genre filter
                _buildGenreFilter(),
                
                const SizedBox(height: 20),
                
                // Year filter
                _buildYearFilter(),
                
                const SizedBox(height: 20),
                
                // Rating filter
                _buildRatingFilter(),
                
                const SizedBox(height: 20),
                
                // Sort filter
                _buildSortFilter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenreFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genres',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _genres.map((genre) {
            final isSelected = _selectedGenres.contains(genre['name']);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedGenres.remove(genre['name']);
                  } else {
                    _selectedGenres.add(genre['name']);
                  }
                });
                _applyFilters();
                HapticFeedback.lightImpact();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF74B9FF)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF74B9FF)
                        : Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  genre['name'],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildYearFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Release Year: ${_minYear.round()} - ${_maxYear.round()}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(_minYear, _maxYear),
          min: 1970,
          max: 2024,
          divisions: 54,
          activeColor: const Color(0xFF74B9FF),
          inactiveColor: Colors.white.withOpacity(0.3),
          onChanged: (RangeValues values) {
            setState(() {
              _minYear = values.start;
              _maxYear = values.end;
            });
          },
          onChangeEnd: (RangeValues values) {
            _applyFilters();
            HapticFeedback.lightImpact();
          },
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating: ${_minRating.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _minRating,
          min: 0.0,
          max: 10.0,
          divisions: 20,
          activeColor: const Color(0xFF74B9FF),
          inactiveColor: Colors.white.withOpacity(0.3),
          onChanged: (double value) {
            setState(() {
              _minRating = value;
            });
          },
          onChangeEnd: (double value) {
            _applyFilters();
            HapticFeedback.lightImpact();
          },
        ),
      ],
    );
  }

  Widget _buildSortFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: DropdownButton<String>(
            value: _sortBy,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _sortBy = newValue;
                });
                _applyFilters();
                HapticFeedback.lightImpact();
              }
            },
            dropdownColor: const Color(0xFF1A1A1A),
            underline: const SizedBox(),
            isExpanded: true,
            style: const TextStyle(color: Colors.white),
            items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(_getSortDisplayName(value)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _getSortDisplayName(String sortValue) {
    switch (sortValue) {
      case 'popularity.desc': return 'Most Popular';
      case 'popularity.asc': return 'Least Popular';
      case 'release_date.desc': return 'Newest First';
      case 'release_date.asc': return 'Oldest First';
      case 'vote_average.desc': return 'Highest Rated';
      case 'vote_average.asc': return 'Lowest Rated';
      case 'original_title.asc': return 'Title A-Z';
      case 'original_title.desc': return 'Title Z-A';
      default: return 'Most Popular';
    }
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _searchController.text.isEmpty
                ? 'Popular Movies'
                : 'Search Results',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${_filteredResults.length} movies',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF74B9FF),
        ),
      );
    }

    if (_filteredResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No movies found'
                  : 'No results for "${_searchController.text}"',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredResults.length,
      itemBuilder: (context, index) {
        return MovieCard(
          movie: _filteredResults[index],
          width: double.infinity,
          height: double.infinity,
          showTitle: true,
          showRating: true,
        );
      },
    );
  }
}
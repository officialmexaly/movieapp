import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'cache_service.dart';

class TMDBService {
  static const String _apiKey = 'a56f77a7b09079e46ec3c1718b3bed27';
  static const String _accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNTZmNzdhN2IwOTA3OWU0NmVjM2MxNzE4YjNiZWQyNyIsIm5iZiI6MTc1NzU1MjMxNS4yNTIsInN1YiI6IjY4YzIxZWJiYTBhODBhZDExMTRlNzE1ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dBczU5ytaUlCJCsTGaq81VLZm88DcjmzIJfBLYBCxE0';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static Map<String, String> get _headers => {
    'Authorization': 'Bearer $_accessToken',
    'Content-Type': 'application/json',
  };

  static Future<List<Movie>> getPopularMovies() async {
    // Try to get from cache first
    final cachedMovies = await CacheService.getCachedMovies(CacheService.popularMoviesKey);
    if (cachedMovies != null) {
      return cachedMovies;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final movies = results.map((json) => Movie.fromJson(json)).toList();
        
        // Cache the results
        await CacheService.cacheMovies(CacheService.popularMoviesKey, movies);
        
        return movies;
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      throw Exception('Error fetching popular movies: $e');
    }
  }

  static Future<List<Movie>> getTrendingMovies() async {
    // Try to get from cache first
    final cachedMovies = await CacheService.getCachedMovies(CacheService.trendingMoviesKey);
    if (cachedMovies != null) {
      return cachedMovies;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/trending/movie/day'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final movies = results.map((json) => Movie.fromJson(json)).toList();
        
        // Cache the results
        await CacheService.cacheMovies(CacheService.trendingMoviesKey, movies);
        
        return movies;
      } else {
        throw Exception('Failed to load trending movies');
      }
    } catch (e) {
      throw Exception('Error fetching trending movies: $e');
    }
  }

  static Future<List<Movie>> getTopRatedMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/top_rated'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top rated movies');
      }
    } catch (e) {
      throw Exception('Error fetching top rated movies: $e');
    }
  }

  static Future<List<Movie>> getNowPlayingMovies() async {
    // Try to get from cache first
    final cachedMovies = await CacheService.getCachedMovies(CacheService.nowPlayingMoviesKey);
    if (cachedMovies != null) {
      return cachedMovies;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/now_playing'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final movies = results.map((json) => Movie.fromJson(json)).toList();
        
        // Cache the results
        await CacheService.cacheMovies(CacheService.nowPlayingMoviesKey, movies);
        
        return movies;
      } else {
        throw Exception('Failed to load now playing movies');
      }
    } catch (e) {
      throw Exception('Error fetching now playing movies: $e');
    }
  }

  static Future<List<Movie>> getUpcomingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/upcoming'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      throw Exception('Error fetching upcoming movies: $e');
    }
  }

  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return ''; // Return empty string - widget will handle with errorWidget
    }
    return '$_imageBaseUrl$imagePath';
  }

  static String getBackdropUrl(String? backdropPath) {
    if (backdropPath == null || backdropPath.isEmpty) {
      return ''; // Return empty string - widget will handle with errorWidget
    }
    return 'https://image.tmdb.org/t/p/w1280$backdropPath';
  }

  // Movie Detail Screen Methods
  static Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }

  static Future<List<dynamic>> getMovieCast(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/credits'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['cast'] ?? [];
      } else {
        throw Exception('Failed to load movie cast');
      }
    } catch (e) {
      throw Exception('Error fetching movie cast: $e');
    }
  }

  static Future<List<dynamic>> getMovieReviews(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/reviews'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else {
        throw Exception('Failed to load movie reviews');
      }
    } catch (e) {
      throw Exception('Error fetching movie reviews: $e');
    }
  }

  static Future<List<dynamic>> getMovieVideos(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/videos'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else {
        throw Exception('Failed to load movie videos');
      }
    } catch (e) {
      throw Exception('Error fetching movie videos: $e');
    }
  }

  static Future<List<Movie>> getSimilarMovies(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/similar'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load similar movies');
      }
    } catch (e) {
      throw Exception('Error fetching similar movies: $e');
    }
  }

  // Search functionality
  static Future<List<Movie>> searchMovies(String query) async {
    // Try to get from cache first
    final cacheKey = 'search_${query.toLowerCase().replaceAll(' ', '_')}';
    final cachedMovies = await CacheService.getCachedMovies(cacheKey);
    if (cachedMovies != null) {
      return cachedMovies;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search/movie?query=${Uri.encodeComponent(query)}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final movies = results.map((json) => Movie.fromJson(json)).toList();
        
        // Cache the results
        await CacheService.cacheMovies(cacheKey, movies);
        
        return movies;
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  static Future<List<Movie>> discoverMovies({
    List<int>? genreIds,
    int? minYear,
    int? maxYear,
    double? minRating,
    String sortBy = 'popularity.desc',
  }) async {
    try {
      final queryParams = <String, String>{
        'sort_by': sortBy,
      };
      
      if (genreIds != null && genreIds.isNotEmpty) {
        queryParams['with_genres'] = genreIds.join(',');
      }
      
      if (minYear != null) {
        queryParams['primary_release_date.gte'] = '$minYear-01-01';
      }
      
      if (maxYear != null) {
        queryParams['primary_release_date.lte'] = '$maxYear-12-31';
      }
      
      if (minRating != null) {
        queryParams['vote_average.gte'] = minRating.toString();
      }
      
      final uri = Uri.parse('$_baseUrl/discover/movie').replace(queryParameters: queryParams);
      
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to discover movies');
      }
    } catch (e) {
      throw Exception('Error discovering movies: $e');
    }
  }

  // Genre-based movie categories
  static Future<List<Movie>> getActionMovies() async => await _getMoviesByGenre(28);
  static Future<List<Movie>> getAdventureMovies() async => await _getMoviesByGenre(12);
  static Future<List<Movie>> getAnimationMovies() async => await _getMoviesByGenre(16);
  static Future<List<Movie>> getComedyMovies() async => await _getMoviesByGenre(35);
  static Future<List<Movie>> getCrimeMovies() async => await _getMoviesByGenre(80);
  static Future<List<Movie>> getDocumentaryMovies() async => await _getMoviesByGenre(99);
  static Future<List<Movie>> getDramaMovies() async => await _getMoviesByGenre(18);
  static Future<List<Movie>> getFamilyMovies() async => await _getMoviesByGenre(10751);
  static Future<List<Movie>> getFantasyMovies() async => await _getMoviesByGenre(14);
  static Future<List<Movie>> getHistoryMovies() async => await _getMoviesByGenre(36);
  static Future<List<Movie>> getHorrorMovies() async => await _getMoviesByGenre(27);
  static Future<List<Movie>> getMusicMovies() async => await _getMoviesByGenre(10402);
  static Future<List<Movie>> getMysteryMovies() async => await _getMoviesByGenre(9648);
  static Future<List<Movie>> getRomanceMovies() async => await _getMoviesByGenre(10749);
  static Future<List<Movie>> getSciFiMovies() async => await _getMoviesByGenre(878);
  static Future<List<Movie>> getThrillerMovies() async => await _getMoviesByGenre(53);
  static Future<List<Movie>> getTVMovies() async => await _getMoviesByGenre(10770);
  static Future<List<Movie>> getWarMovies() async => await _getMoviesByGenre(10752);
  static Future<List<Movie>> getWesternMovies() async => await _getMoviesByGenre(37);

  // Special collections and curated lists
  static Future<List<Movie>> getHighRatedMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?sort_by=vote_average.desc&vote_count.gte=1000'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load high rated movies');
      }
    } catch (e) {
      throw Exception('Error fetching high rated movies: $e');
    }
  }

  static Future<List<Movie>> getRecentReleases() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?primary_release_date.gte=2024-01-01&sort_by=release_date.desc'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recent releases');
      }
    } catch (e) {
      throw Exception('Error fetching recent releases: $e');
    }
  }

  static Future<List<Movie>> getClassicMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?primary_release_date.lte=1990-12-31&vote_average.gte=7.5&sort_by=vote_average.desc'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load classic movies');
      }
    } catch (e) {
      throw Exception('Error fetching classic movies: $e');
    }
  }

  static Future<List<Movie>> getAwardWinningMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?vote_average.gte=8.0&vote_count.gte=2000&sort_by=vote_average.desc'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load award winning movies');
      }
    } catch (e) {
      throw Exception('Error fetching award winning movies: $e');
    }
  }

  static Future<List<Movie>> getBlockbusterHits() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?sort_by=revenue.desc&revenue.gte=100000000'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load blockbuster hits');
      }
    } catch (e) {
      throw Exception('Error fetching blockbuster hits: $e');
    }
  }

  static Future<List<Movie>> getIndieFavorites() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?with_companies=7505|711|25|420&sort_by=vote_average.desc'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load indie favorites');
      }
    } catch (e) {
      throw Exception('Error fetching indie favorites: $e');
    }
  }

  static Future<List<Movie>> getCultClassics() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?primary_release_date.lte=2000-12-31&vote_average.gte=7.0&vote_count.gte=500&sort_by=popularity.desc'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cult classics');
      }
    } catch (e) {
      throw Exception('Error fetching cult classics: $e');
    }
  }

  static Future<List<Movie>> getHiddenGems() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?vote_average.gte=7.5&vote_count.lte=1000&sort_by=vote_average.desc'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hidden gems');
      }
    } catch (e) {
      throw Exception('Error fetching hidden gems: $e');
    }
  }

  static Future<List<Movie>> getTrendingThisWeek() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/trending/movie/week'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trending this week');
      }
    } catch (e) {
      throw Exception('Error fetching trending this week: $e');
    }
  }

  static Future<List<Movie>> getViralContent() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?sort_by=popularity.desc&primary_release_date.gte=2023-01-01'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load viral content');
      }
    } catch (e) {
      throw Exception('Error fetching viral content: $e');
    }
  }

  static Future<List<Movie>> getTopPicks() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?sort_by=vote_average.desc&vote_count.gte=500'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top picks');
      }
    } catch (e) {
      throw Exception('Error fetching top picks: $e');
    }
  }

  static Future<List<Movie>> getMyListMovies() async {
    try {
      // Get a curated mix of highly rated movies from different genres for "My List"
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?sort_by=vote_average.desc&vote_count.gte=1500&page=1'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load my list movies');
      }
    } catch (e) {
      throw Exception('Error fetching my list movies: $e');
    }
  }

  // Helper method to get movies by genre
  static Future<List<Movie>> _getMoviesByGenre(int genreId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/discover/movie?with_genres=$genreId&sort_by=popularity.desc'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies for genre $genreId');
      }
    } catch (e) {
      throw Exception('Error fetching movies for genre $genreId: $e');
    }
  }

  static Future<List<Movie>> getWatchHistory() async {
    // For now, return a sample of popular movies as watch history
    // In a real app, this would be stored user data
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/top_rated?page=1'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.take(8).map((json) => Movie.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
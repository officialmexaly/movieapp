import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class CacheService {
  static const String _keyPrefix = 'tmdb_cache_';
  static const String _timestampPrefix = 'tmdb_timestamp_';
  static const Duration _cacheExpiry = Duration(hours: 6); // Cache for 6 hours

  // Cache keys for different movie categories
  static const String popularMoviesKey = 'popular_movies';
  static const String trendingMoviesKey = 'trending_movies';
  static const String nowPlayingMoviesKey = 'now_playing_movies';
  static const String topRatedMoviesKey = 'top_rated_movies';
  static const String upcomingMoviesKey = 'upcoming_movies';
  static const String myListMoviesKey = 'my_list_movies';
  static const String editorPicksKey = 'editor_picks';
  static const String viralContentKey = 'viral_content';
  static const String trendingWeekKey = 'trending_week';
  static const String actionMoviesKey = 'action_movies';
  static const String comedyMoviesKey = 'comedy_movies';
  static const String dramaMoviesKey = 'drama_movies';
  static const String horrorMoviesKey = 'horror_movies';
  static const String scifiMoviesKey = 'scifi_movies';

  static Future<void> cacheMovies(String key, List<Movie> movies) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final moviesJson = movies.map((movie) => movie.toJson()).toList();
      final jsonString = jsonEncode(moviesJson);
      
      await prefs.setString('$_keyPrefix$key', jsonString);
      await prefs.setInt('$_timestampPrefix$key', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching movies for $key: $e');
    }
  }

  static Future<List<Movie>?> getCachedMovies(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if cache exists
      final jsonString = prefs.getString('$_keyPrefix$key');
      final timestamp = prefs.getInt('$_timestampPrefix$key');
      
      if (jsonString == null || timestamp == null) {
        return null;
      }
      
      // Check if cache is expired
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheExpiry) {
        // Cache expired, remove it
        await clearCache(key);
        return null;
      }
      
      // Parse cached data
      final List<dynamic> moviesJson = jsonDecode(jsonString);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      print('Error retrieving cached movies for $key: $e');
      return null;
    }
  }

  static Future<bool> isCacheValid(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('$_timestampPrefix$key');
      
      if (timestamp == null) return false;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(cacheTime) < _cacheExpiry;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_keyPrefix$key');
      await prefs.remove('$_timestampPrefix$key');
    } catch (e) {
      print('Error clearing cache for $key: $e');
    }
  }

  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => 
        key.startsWith(_keyPrefix) || key.startsWith(_timestampPrefix)
      ).toList();
      
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      print('Error clearing all cache: $e');
    }
  }

  // Helper method to get cache info for debugging
  static Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final info = <String, dynamic>{};
      
      final keys = prefs.getKeys().where((key) => 
        key.startsWith(_timestampPrefix)
      ).toList();
      
      for (final key in keys) {
        final timestamp = prefs.getInt(key);
        if (timestamp != null) {
          final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final age = DateTime.now().difference(cacheTime);
          final isValid = age < _cacheExpiry;
          
          info[key.replaceFirst(_timestampPrefix, '')] = {
            'cached_at': cacheTime.toIso8601String(),
            'age_minutes': age.inMinutes,
            'is_valid': isValid,
          };
        }
      }
      
      return info;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
import 'package:flutter/material.dart';
import '../models/featured_movie.dart';
import '../models/video_card.dart';

class MovieDataService {
  static List<FeaturedMovie> getFeaturedMovies() {
    return [
      const FeaturedMovie(
        title: 'WEDNESDAY',
        subtitle: 'A Netflix Series',
        genres: ['Deadpan', 'Chilling', 'Dark Comedy', 'Psychic Power', 'Imaginative'],
        isNetflixSeries: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      const FeaturedMovie(
        title: 'STRANGER THINGS',
        subtitle: 'A Netflix Series',
        genres: ['Supernatural', 'Sci-Fi', 'Horror', 'Nostalgic', 'Teen'],
        isNetflixSeries: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2c1810), Color(0xFF8B0000), Color(0xFF000000)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      const FeaturedMovie(
        title: 'THE WITCHER',
        subtitle: 'A Netflix Series',
        genres: ['Fantasy', 'Action', 'Adventure', 'Dark', 'Epic'],
        isNetflixSeries: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C2C54), Color(0xFF40407A), Color(0xFF706FD3)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      const FeaturedMovie(
        title: 'OZARK',
        subtitle: 'A Netflix Series',
        genres: ['Crime', 'Drama', 'Thriller', 'Dark', 'Intense'],
        isNetflixSeries: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B262C), Color(0xFF0F4C75), Color(0xFF3282B8)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      const FeaturedMovie(
        title: 'MONEY HEIST',
        subtitle: 'A Netflix Series',
        genres: ['Crime', 'Thriller', 'Spanish', 'Heist', 'Drama'],
        isNetflixSeries: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8B0000), Color(0xFF2C1810), Color(0xFF000000)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    ];
  }

  static List<ContinueWatchingCard> getContinueWatchingContent() {
    return const [
      ContinueWatchingCard(
        title: 'Crime Scene',
        progress: 0.3,
        gradient: LinearGradient(
          colors: [Color(0xFF2C1810), Color(0xFF8B0000)],
        ),
      ),
      ContinueWatchingCard(
        title: 'The Chef Show',
        progress: 0.7,
        gradient: LinearGradient(
          colors: [Color(0xFFFF7675), Color(0xFFE17055)],
        ),
      ),
      ContinueWatchingCard(
        title: 'Anime Series',
        progress: 0.5,
        gradient: LinearGradient(
          colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
        ),
      ),
    ];
  }

  static List<VideoCard> getDanceContent() {
    return const [
      VideoCard(
        title: 'Hip Hop Battle',
        creator: '@dance_king',
        likes: '4.2M',
        gradient: LinearGradient(colors: [Color(0xFF74B9FF), Color(0xFF0984E3)]),
        category: 'Dance',
      ),
      VideoCard(
        title: 'Salsa Moves',
        creator: '@latin_dancer',
        likes: '2.1M',
        gradient: LinearGradient(colors: [Color(0xFFFF7675), Color(0xFFE17055)]),
        category: 'Dance',
      ),
      VideoCard(
        title: 'K-Pop Choreo',
        creator: '@kpop_crew',
        likes: '5.8M',
        gradient: LinearGradient(colors: [Color(0xFFFD79A8), Color(0xFFE84393)]),
        category: 'Dance',
      ),
      VideoCard(
        title: 'Ballet Fusion',
        creator: '@modern_ballet',
        likes: '1.7M',
        gradient: LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)]),
        category: 'Dance',
      ),
      VideoCard(
        title: 'Breakdance Pro',
        creator: '@bboy_legend',
        likes: '3.4M',
        gradient: LinearGradient(colors: [Color(0xFF00CEC9), Color(0xFF55EFC4)]),
        category: 'Dance',
      ),
    ];
  }

  static List<VideoCard> getFoodContent() {
    return const [
      VideoCard(
        title: 'Pasta Perfection',
        creator: '@italian_chef',
        likes: '2.8M',
        gradient: LinearGradient(colors: [Color(0xFFFFD93D), Color(0xFFF39C12)]),
        category: 'Food',
      ),
      VideoCard(
        title: 'Sushi Art',
        creator: '@sushi_master',
        likes: '1.9M',
        gradient: LinearGradient(colors: [Color(0xFF00CEC9), Color(0xFF55EFC4)]),
        category: 'Food',
      ),
      VideoCard(
        title: 'Dessert Magic',
        creator: '@sweet_treats',
        likes: '3.5M',
        gradient: LinearGradient(colors: [Color(0xFFFD79A8), Color(0xFFE84393)]),
        category: 'Food',
      ),
      VideoCard(
        title: 'Street Food',
        creator: '@food_explorer',
        likes: '4.1M',
        gradient: LinearGradient(colors: [Color(0xFFFF7675), Color(0xFFE17055)]),
        category: 'Food',
      ),
      VideoCard(
        title: 'Healthy Bowl',
        creator: '@nutrition_guru',
        likes: '2.3M',
        gradient: LinearGradient(colors: [Color(0xFF74B9FF), Color(0xFF0984E3)]),
        category: 'Food',
      ),
    ];
  }
}
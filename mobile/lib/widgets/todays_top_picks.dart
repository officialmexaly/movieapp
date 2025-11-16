import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/movie.dart';
import 'movie_card.dart';

class TodaysTopPicks extends StatelessWidget {
  final List<Movie> movies;
  final AnimationController scrollAnimation;

  const TodaysTopPicks({
    super.key,
    required this.movies,
    required this.scrollAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: scrollAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: scrollAnimation,
          curve: Curves.easeOutQuart,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "Editor's Choice",
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: movies
                    .map((movie) => MovieCard(
                          movie: movie,
                          width: 140,
                          height: 200,
                          showTitle: true,
                          showRating: true,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class Top10Section extends StatelessWidget {
  final List<Movie> movies;
  final AnimationController scrollAnimation;

  const Top10Section({
    super.key,
    required this.movies,
    required this.scrollAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: scrollAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: scrollAnimation,
          curve: Curves.easeOutQuart,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Trending Top 10',
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
                itemCount: movies.length > 10 ? 10 : movies.length,
                itemBuilder: (context, index) {
                  return _buildTop10Card(
                    number: '${index + 1}',
                    movie: movies[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTop10Card({
    required String number,
    required Movie movie,
  }) {
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
          Positioned(
            top: -5,
            left: -5,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyListSection extends StatelessWidget {
  final AnimationController scrollAnimation;
  final List<Movie> myListMovies;

  const MyListSection({
    super.key,
    required this.scrollAnimation,
    required this.myListMovies,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: scrollAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: scrollAnimation,
          curve: Curves.easeOutQuart,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Watchlist',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: myListMovies.length > 10 ? 10 : myListMovies.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    movie: myListMovies[index],
                    width: 140,
                    height: 200,
                    showTitle: true,
                    showRating: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
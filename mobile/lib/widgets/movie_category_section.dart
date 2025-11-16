import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class MovieCategorySection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final AnimationController scrollAnimation;

  const MovieCategorySection({
    super.key,
    required this.title,
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
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    movie: movies[index],
                    width: 160,
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
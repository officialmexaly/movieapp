import 'package:flutter/material.dart';

class FeaturedMovie {
  final String title;
  final String? subtitle;
  final List<String> genres;
  final bool isNetflixSeries;
  final Gradient gradient;

  const FeaturedMovie({
    required this.title,
    this.subtitle,
    required this.genres,
    this.isNetflixSeries = false,
    required this.gradient,
  });

  factory FeaturedMovie.fromMap(Map<String, dynamic> map) {
    return FeaturedMovie(
      title: map['title'] as String,
      subtitle: map['subtitle'] as String?,
      genres: List<String>.from(map['genres'] as List),
      isNetflixSeries: map['isNetflixSeries'] as bool? ?? false,
      gradient: map['gradient'] as Gradient,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'genres': genres,
      'isNetflixSeries': isNetflixSeries,
      'gradient': gradient,
    };
  }
}
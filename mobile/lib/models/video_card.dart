import 'package:flutter/material.dart';

class VideoCard {
  final String title;
  final String creator;
  final String likes;
  final Gradient gradient;
  final String category;

  const VideoCard({
    required this.title,
    required this.creator,
    required this.likes,
    required this.gradient,
    required this.category,
  });

  factory VideoCard.fromMap(Map<String, dynamic> map) {
    return VideoCard(
      title: map['title'] as String,
      creator: map['creator'] as String,
      likes: map['likes'] as String,
      gradient: map['gradient'] as Gradient,
      category: map['category'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'creator': creator,
      'likes': likes,
      'gradient': gradient,
      'category': category,
    };
  }
}

class ContinueWatchingCard {
  final String title;
  final double progress;
  final Gradient gradient;

  const ContinueWatchingCard({
    required this.title,
    required this.progress,
    required this.gradient,
  });

  factory ContinueWatchingCard.fromMap(Map<String, dynamic> map) {
    return ContinueWatchingCard(
      title: map['title'] as String,
      progress: map['progress'] as double,
      gradient: map['gradient'] as Gradient,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'progress': progress,
      'gradient': gradient,
    };
  }
}
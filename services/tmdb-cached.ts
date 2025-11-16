import { unstable_cache } from 'next/cache'
import { cache } from 'react'
import * as tmdb from './tmdb'
import type { Movie, MovieDetails, Credits, Review, Video } from '@/types/movie'

// Cache configuration
const CACHE_TAGS = {
  POPULAR: 'movies-popular',
  TRENDING: 'movies-trending',
  TOP_RATED: 'movies-top-rated',
  NOW_PLAYING: 'movies-now-playing',
  UPCOMING: 'movies-upcoming',
  GENRE: 'movies-genre',
  MOVIE_DETAILS: 'movie-details',
  MOVIE_CREDITS: 'movie-credits',
  MOVIE_REVIEWS: 'movie-reviews',
  MOVIE_VIDEOS: 'movie-videos',
  SIMILAR: 'movies-similar',
  RECOMMENDED: 'movies-recommended',
}

// Revalidation times (in seconds)
const REVALIDATE_TIMES = {
  SHORT: 60 * 5, // 5 minutes
  MEDIUM: 60 * 30, // 30 minutes
  LONG: 60 * 60 * 24, // 24 hours
}

// Popular Movies - cached with medium revalidation
export const getPopularMovies = unstable_cache(
  cache(async (page: number = 1) => tmdb.getPopularMovies(page)),
  ['popular-movies'],
  {
    tags: [CACHE_TAGS.POPULAR],
    revalidate: REVALIDATE_TIMES.MEDIUM,
  }
)

// Trending Movies - cached with short revalidation (changes frequently)
export const getTrendingMovies = unstable_cache(
  cache(async (timeWindow: 'day' | 'week' = 'week') => tmdb.getTrendingMovies(timeWindow)),
  ['trending-movies'],
  {
    tags: [CACHE_TAGS.TRENDING],
    revalidate: REVALIDATE_TIMES.SHORT,
  }
)

// Top Rated Movies - cached with long revalidation (rarely changes)
export const getTopRatedMovies = unstable_cache(
  cache(async (page: number = 1) => tmdb.getTopRatedMovies(page)),
  ['top-rated-movies'],
  {
    tags: [CACHE_TAGS.TOP_RATED],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

// Now Playing Movies - cached with short revalidation
export const getNowPlayingMovies = unstable_cache(
  cache(async (page: number = 1) => tmdb.getNowPlayingMovies(page)),
  ['now-playing-movies'],
  {
    tags: [CACHE_TAGS.NOW_PLAYING],
    revalidate: REVALIDATE_TIMES.SHORT,
  }
)

// Upcoming Movies - cached with medium revalidation
export const getUpcomingMovies = unstable_cache(
  cache(async (page: number = 1) => tmdb.getUpcomingMovies(page)),
  ['upcoming-movies'],
  {
    tags: [CACHE_TAGS.UPCOMING],
    revalidate: REVALIDATE_TIMES.MEDIUM,
  }
)

// Genre-based movies - cached with long revalidation
export const getActionMovies = unstable_cache(
  cache(async () => tmdb.getActionMovies()),
  ['action-movies'],
  {
    tags: [CACHE_TAGS.GENRE, 'genre-28'],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

export const getComedyMovies = unstable_cache(
  cache(async () => tmdb.getComedyMovies()),
  ['comedy-movies'],
  {
    tags: [CACHE_TAGS.GENRE, 'genre-35'],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

export const getDramaMovies = unstable_cache(
  cache(async () => tmdb.getDramaMovies()),
  ['drama-movies'],
  {
    tags: [CACHE_TAGS.GENRE, 'genre-18'],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

export const getHorrorMovies = unstable_cache(
  cache(async () => tmdb.getHorrorMovies()),
  ['horror-movies'],
  {
    tags: [CACHE_TAGS.GENRE, 'genre-27'],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

export const getSciFiMovies = unstable_cache(
  cache(async () => tmdb.getSciFiMovies()),
  ['scifi-movies'],
  {
    tags: [CACHE_TAGS.GENRE, 'genre-878'],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

export const getRomanceMovies = unstable_cache(
  cache(async () => tmdb.getRomanceMovies()),
  ['romance-movies'],
  {
    tags: [CACHE_TAGS.GENRE, 'genre-10749'],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

export const getThrillerMovies = unstable_cache(
  cache(async () => tmdb.getThrillerMovies()),
  ['thriller-movies'],
  {
    tags: [CACHE_TAGS.GENRE, 'genre-53'],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

export const getAnimationMovies = unstable_cache(
  cache(async () => tmdb.getAnimationMovies()),
  ['animation-movies'],
  {
    tags: [CACHE_TAGS.GENRE, 'genre-16'],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

export const getFamilyMovies = unstable_cache(
  cache(async () => tmdb.getFamilyMovies()),
  ['family-movies'],
  {
    tags: [CACHE_TAGS.GENRE, 'genre-10751'],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

// Special collections
export const getAwardWinningMovies = unstable_cache(
  cache(async () => tmdb.getAwardWinningMovies()),
  ['award-winning-movies'],
  {
    tags: [CACHE_TAGS.TOP_RATED],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

export const getClassicMovies = unstable_cache(
  cache(async () => tmdb.getClassicMovies()),
  ['classic-movies'],
  {
    tags: [CACHE_TAGS.TOP_RATED],
    revalidate: REVALIDATE_TIMES.LONG,
  }
)

// Movie details - cached per movie ID
export const getMovieDetails = (movieId: number) =>
  unstable_cache(
    cache(async () => tmdb.getMovieDetails(movieId)),
    [`movie-details-${movieId}`],
    {
      tags: [CACHE_TAGS.MOVIE_DETAILS, `movie-${movieId}`],
      revalidate: REVALIDATE_TIMES.LONG,
    }
  )()

export const getMovieCredits = (movieId: number) =>
  unstable_cache(
    cache(async () => tmdb.getMovieCredits(movieId)),
    [`movie-credits-${movieId}`],
    {
      tags: [CACHE_TAGS.MOVIE_CREDITS, `movie-${movieId}`],
      revalidate: REVALIDATE_TIMES.LONG,
    }
  )()

export const getMovieReviews = (movieId: number) =>
  unstable_cache(
    cache(async () => tmdb.getMovieReviews(movieId)),
    [`movie-reviews-${movieId}`],
    {
      tags: [CACHE_TAGS.MOVIE_REVIEWS, `movie-${movieId}`],
      revalidate: REVALIDATE_TIMES.MEDIUM,
    }
  )()

export const getMovieVideos = (movieId: number) =>
  unstable_cache(
    cache(async () => tmdb.getMovieVideos(movieId)),
    [`movie-videos-${movieId}`],
    {
      tags: [CACHE_TAGS.MOVIE_VIDEOS, `movie-${movieId}`],
      revalidate: REVALIDATE_TIMES.LONG,
    }
  )()

export const getSimilarMovies = (movieId: number) =>
  unstable_cache(
    cache(async () => tmdb.getSimilarMovies(movieId)),
    [`similar-movies-${movieId}`],
    {
      tags: [CACHE_TAGS.SIMILAR, `movie-${movieId}`],
      revalidate: REVALIDATE_TIMES.LONG,
    }
  )()

export const getRecommendedMovies = (movieId: number) =>
  unstable_cache(
    cache(async () => tmdb.getRecommendedMovies(movieId)),
    [`recommended-movies-${movieId}`],
    {
      tags: [CACHE_TAGS.RECOMMENDED, `movie-${movieId}`],
      revalidate: REVALIDATE_TIMES.LONG,
    }
  )()

// Re-export non-API utilities from original service
export { getImageUrl, POSTER_SIZE, BACKDROP_SIZE, PROFILE_SIZE, GENRES, IMAGE_BASE_URL } from './tmdb'

// Search is intentionally not cached as it's user-specific
export const searchMovies = tmdb.searchMovies
export const discoverMovies = tmdb.discoverMovies

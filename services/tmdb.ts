import axios from 'axios'
import type { Movie, MovieDetails, Credits, Review, Video, Genre } from '@/types/movie'

const BASE_URL = 'https://api.themoviedb.org/3'
const API_KEY = process.env.NEXT_PUBLIC_TMDB_API_KEY
const ACCESS_TOKEN = process.env.NEXT_PUBLIC_TMDB_ACCESS_TOKEN

export const IMAGE_BASE_URL = 'https://image.tmdb.org/t/p'
export const POSTER_SIZE = 'w500'
export const BACKDROP_SIZE = 'w1280'
export const PROFILE_SIZE = 'w185'

// Create axios instance with default config
const tmdbApi = axios.create({
  baseURL: BASE_URL,
  headers: {
    Authorization: `Bearer ${ACCESS_TOKEN}`,
    'Content-Type': 'application/json',
  },
})

// Helper to get image URL
export const getImageUrl = (path: string | null, size: string = POSTER_SIZE): string => {
  if (!path) return '/placeholder-movie.png'
  return `${IMAGE_BASE_URL}/${size}${path}`
}

// Genre mapping
export const GENRES: Genre[] = [
  { id: 28, name: 'Action' },
  { id: 12, name: 'Adventure' },
  { id: 16, name: 'Animation' },
  { id: 35, name: 'Comedy' },
  { id: 80, name: 'Crime' },
  { id: 99, name: 'Documentary' },
  { id: 18, name: 'Drama' },
  { id: 10751, name: 'Family' },
  { id: 14, name: 'Fantasy' },
  { id: 36, name: 'History' },
  { id: 27, name: 'Horror' },
  { id: 10402, name: 'Music' },
  { id: 9648, name: 'Mystery' },
  { id: 10749, name: 'Romance' },
  { id: 878, name: 'Science Fiction' },
  { id: 10770, name: 'TV Movie' },
  { id: 53, name: 'Thriller' },
  { id: 10752, name: 'War' },
  { id: 37, name: 'Western' },
]

interface TMDBResponse<T> {
  page: number
  results: T[]
  total_pages: number
  total_results: number
}

// Popular Movies
export async function getPopularMovies(page: number = 1): Promise<Movie[]> {
  const response = await tmdbApi.get<TMDBResponse<Movie>>('/movie/popular', {
    params: { page },
  })
  return response.data.results
}

// Trending Movies
export async function getTrendingMovies(timeWindow: 'day' | 'week' = 'week'): Promise<Movie[]> {
  const response = await tmdbApi.get<TMDBResponse<Movie>>(`/trending/movie/${timeWindow}`)
  return response.data.results
}

// Top Rated Movies
export async function getTopRatedMovies(page: number = 1): Promise<Movie[]> {
  const response = await tmdbApi.get<TMDBResponse<Movie>>('/movie/top_rated', {
    params: { page },
  })
  return response.data.results
}

// Now Playing Movies
export async function getNowPlayingMovies(page: number = 1): Promise<Movie[]> {
  const response = await tmdbApi.get<TMDBResponse<Movie>>('/movie/now_playing', {
    params: { page },
  })
  return response.data.results
}

// Upcoming Movies
export async function getUpcomingMovies(page: number = 1): Promise<Movie[]> {
  const response = await tmdbApi.get<TMDBResponse<Movie>>('/movie/upcoming', {
    params: { page },
  })
  return response.data.results
}

// Search Movies
export async function searchMovies(query: string, page: number = 1): Promise<Movie[]> {
  const response = await tmdbApi.get<TMDBResponse<Movie>>('/search/movie', {
    params: { query, page },
  })
  return response.data.results
}

// Discover Movies with filters
interface DiscoverParams {
  page?: number
  genres?: number[]
  year?: number
  sortBy?: string
  voteAverageGte?: number
  voteAverageLte?: number
  releaseYearGte?: number
  releaseYearLte?: number
}

export async function discoverMovies(params: DiscoverParams = {}): Promise<Movie[]> {
  const {
    page = 1,
    genres,
    year,
    sortBy = 'popularity.desc',
    voteAverageGte,
    voteAverageLte,
    releaseYearGte,
    releaseYearLte,
  } = params

  const apiParams: any = {
    page,
    sort_by: sortBy,
  }

  if (genres && genres.length > 0) {
    apiParams.with_genres = genres.join(',')
  }

  if (year) {
    apiParams.primary_release_year = year
  }

  if (voteAverageGte) {
    apiParams['vote_average.gte'] = voteAverageGte
  }

  if (voteAverageLte) {
    apiParams['vote_average.lte'] = voteAverageLte
  }

  if (releaseYearGte) {
    apiParams['primary_release_date.gte'] = `${releaseYearGte}-01-01`
  }

  if (releaseYearLte) {
    apiParams['primary_release_date.lte'] = `${releaseYearLte}-12-31`
  }

  const response = await tmdbApi.get<TMDBResponse<Movie>>('/discover/movie', {
    params: apiParams,
  })
  return response.data.results
}

// Get Movies by Genre
export async function getMoviesByGenre(genreId: number, page: number = 1): Promise<Movie[]> {
  return discoverMovies({ genres: [genreId], page })
}

// Movie Details
export async function getMovieDetails(movieId: number): Promise<MovieDetails> {
  const response = await tmdbApi.get<MovieDetails>(`/movie/${movieId}`)
  return response.data
}

// Movie Credits (Cast & Crew)
export async function getMovieCredits(movieId: number): Promise<Credits> {
  const response = await tmdbApi.get<Credits>(`/movie/${movieId}/credits`)
  return response.data
}

// Movie Reviews
export async function getMovieReviews(movieId: number): Promise<Review[]> {
  const response = await tmdbApi.get<TMDBResponse<Review>>(`/movie/${movieId}/reviews`)
  return response.data.results
}

// Movie Videos (Trailers, Teasers)
export async function getMovieVideos(movieId: number): Promise<Video[]> {
  const response = await tmdbApi.get<{ results: Video[] }>(`/movie/${movieId}/videos`)
  return response.data.results
}

// Similar Movies
export async function getSimilarMovies(movieId: number): Promise<Movie[]> {
  const response = await tmdbApi.get<TMDBResponse<Movie>>(`/movie/${movieId}/similar`)
  return response.data.results
}

// Recommended Movies
export async function getRecommendedMovies(movieId: number): Promise<Movie[]> {
  const response = await tmdbApi.get<TMDBResponse<Movie>>(`/movie/${movieId}/recommendations`)
  return response.data.results
}

// Special Collections
export async function getHighRatedMovies(): Promise<Movie[]> {
  return discoverMovies({
    sortBy: 'vote_average.desc',
    voteAverageGte: 8.0,
  })
}

export async function getRecentReleases(): Promise<Movie[]> {
  return discoverMovies({
    sortBy: 'release_date.desc',
    releaseYearGte: 2024,
  })
}

export async function getClassicMovies(): Promise<Movie[]> {
  return discoverMovies({
    sortBy: 'vote_average.desc',
    releaseYearLte: 1990,
    voteAverageGte: 7.5,
  })
}

export async function getAwardWinningMovies(): Promise<Movie[]> {
  return discoverMovies({
    sortBy: 'vote_average.desc',
    voteAverageGte: 8.0,
  })
}

export async function getBlockbusterHits(): Promise<Movie[]> {
  return discoverMovies({
    sortBy: 'revenue.desc',
  })
}

export async function getActionMovies(): Promise<Movie[]> {
  return getMoviesByGenre(28)
}

export async function getComedyMovies(): Promise<Movie[]> {
  return getMoviesByGenre(35)
}

export async function getDramaMovies(): Promise<Movie[]> {
  return getMoviesByGenre(18)
}

export async function getHorrorMovies(): Promise<Movie[]> {
  return getMoviesByGenre(27)
}

export async function getSciFiMovies(): Promise<Movie[]> {
  return getMoviesByGenre(878)
}

export async function getRomanceMovies(): Promise<Movie[]> {
  return getMoviesByGenre(10749)
}

export async function getThrillerMovies(): Promise<Movie[]> {
  return getMoviesByGenre(53)
}

export async function getAnimationMovies(): Promise<Movie[]> {
  return getMoviesByGenre(16)
}

export async function getFamilyMovies(): Promise<Movie[]> {
  return getMoviesByGenre(10751)
}

export async function getFantasyMovies(): Promise<Movie[]> {
  return getMoviesByGenre(14)
}

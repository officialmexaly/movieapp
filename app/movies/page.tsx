'use client'

import { useState, useEffect, useRef } from 'react'
import { useQuery } from '@tanstack/react-query'
import { motion } from 'framer-motion'
import Link from 'next/link'
import { Grid, List, SlidersHorizontal } from 'lucide-react'
import { AppLayout } from '@/components/AppLayout'
import { Footer } from '@/components/Footer'
import { MovieCard } from '@/components/MovieCard'
import { useSidebar } from '@/contexts/SidebarContext'
import * as tmdb from '@/services/tmdb'

type ViewMode = 'grid' | 'list'
type SortOption = 'popularity' | 'rating' | 'release_date' | 'title'
type GenreFilter = 'all' | 'action' | 'comedy' | 'drama' | 'horror' | 'scifi' | 'romance' | 'thriller' | 'animation'

const GENRES = [
  { value: 'all' as const, label: 'All Genres' },
  { value: 'action' as const, label: 'Action' },
  { value: 'comedy' as const, label: 'Comedy' },
  { value: 'drama' as const, label: 'Drama' },
  { value: 'horror' as const, label: 'Horror' },
  { value: 'scifi' as const, label: 'Sci-Fi' },
  { value: 'romance' as const, label: 'Romance' },
  { value: 'thriller' as const, label: 'Thriller' },
  { value: 'animation' as const, label: 'Animation' },
]

const SORT_OPTIONS = [
  { value: 'popularity' as const, label: 'Most Popular' },
  { value: 'rating' as const, label: 'Highest Rated' },
  { value: 'release_date' as const, label: 'Latest Release' },
  { value: 'title' as const, label: 'Title (A-Z)' },
]

function MoviesPageContent() {
  const { isCollapsed } = useSidebar()
  const [viewMode, setViewMode] = useState<ViewMode>('grid')
  const [sortBy, setSortBy] = useState<SortOption>('popularity')
  const [genreFilter, setGenreFilter] = useState<GenreFilter>('all')
  const [showFilters, setShowFilters] = useState(false)
  const [currentPage, setCurrentPage] = useState(1)
  const [allMovies, setAllMovies] = useState<any[]>([])
  const [initialLoad, setInitialLoad] = useState(true)
  const loadMoreRef = useRef<HTMLDivElement>(null)

  // Fetch movies based on genre
  const getMoviesByGenre = async (page: number) => {
    switch (genreFilter) {
      case 'action':
        return tmdb.getMoviesByGenre(28, page)
      case 'comedy':
        return tmdb.getMoviesByGenre(35, page)
      case 'drama':
        return tmdb.getMoviesByGenre(18, page)
      case 'horror':
        return tmdb.getMoviesByGenre(27, page)
      case 'scifi':
        return tmdb.getMoviesByGenre(878, page)
      case 'romance':
        return tmdb.getMoviesByGenre(10749, page)
      case 'thriller':
        return tmdb.getMoviesByGenre(53, page)
      case 'animation':
        return tmdb.getMoviesByGenre(16, page)
      default:
        return tmdb.getPopularMovies(page)
    }
  }

  const { data: movies, isLoading, isFetching } = useQuery({
    queryKey: ['movies', genreFilter, currentPage],
    queryFn: () => getMoviesByGenre(currentPage),
    staleTime: 1000 * 60 * 5,
  })

  // Accumulate movies from all pages
  useEffect(() => {
    if (movies && !isFetching) {
      if (currentPage === 1) {
        setAllMovies(movies)
      } else {
        setAllMovies(prev => [...prev, ...movies])
      }
    }
  }, [movies, isFetching, currentPage])

  // Reset when genre changes
  useEffect(() => {
    setCurrentPage(1)
    setAllMovies([])
    setInitialLoad(true)
  }, [genreFilter])

  // Load first 3 pages on initial load
  useEffect(() => {
    if (initialLoad && allMovies.length > 0 && currentPage < 3) {
      setCurrentPage(prev => prev + 1)
    } else if (currentPage === 3) {
      setInitialLoad(false)
    }
  }, [initialLoad, allMovies, currentPage])

  // Infinite scroll - auto load more when scrolling to bottom
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        const firstEntry = entries[0]
        if (firstEntry.isIntersecting && !isFetching && !initialLoad) {
          setCurrentPage(prev => prev + 1)
        }
      },
      { threshold: 0.1, rootMargin: '100px' }
    )

    const currentRef = loadMoreRef.current
    if (currentRef) {
      observer.observe(currentRef)
    }

    return () => {
      if (currentRef) {
        observer.unobserve(currentRef)
      }
    }
  }, [isFetching, initialLoad])

  // Sort movies
  const sortedMovies = allMovies.length > 0 ? [...allMovies].sort((a, b) => {
    switch (sortBy) {
      case 'popularity':
        return (b.popularity || 0) - (a.popularity || 0)
      case 'rating':
        return (b.vote_average || 0) - (a.vote_average || 0)
      case 'release_date':
        return new Date(b.release_date || 0).getTime() - new Date(a.release_date || 0).getTime()
      case 'title':
        return (a.title || '').localeCompare(b.title || '')
      default:
        return 0
    }
  }) : []

  return (
    <main className={`pt-20 pb-24 md:pb-8 transition-all duration-300 ${isCollapsed ? 'md:pl-20' : 'md:pl-60'}`}>
        <div className="px-4 py-8">
          {/* Page Header */}
          <div className="mb-8">
            <motion.h1
              initial={{ opacity: 0, y: -20 }}
              animate={{ opacity: 1, y: 0 }}
              className="text-4xl md:text-5xl font-bold mb-3 bg-gradient-to-r from-brand-purple via-brand-blue to-brand-purple bg-clip-text text-transparent"
            >
              Discover Movies
            </motion.h1>
            <p className="text-white/60 text-lg">
              Browse our complete collection of movies
            </p>
          </div>

          {/* Filters & Controls */}
          <div className="mb-8 space-y-4">
            {/* Top Controls */}
            <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between">
              {/* Filter Toggle & View Mode */}
              <div className="flex items-center gap-3">
                <button
                  onClick={() => setShowFilters(!showFilters)}
                  className={`flex items-center gap-2 px-4 py-2 rounded-xl transition-all ${
                    showFilters
                      ? 'bg-gradient-to-r from-brand-purple to-brand-blue text-white'
                      : 'bg-bg-card text-white/60 hover:text-white hover:bg-white/10'
                  }`}
                >
                  <SlidersHorizontal size={18} />
                  <span className="font-semibold">Filters</span>
                </button>

                {/* View Mode Toggle */}
                <div className="flex items-center gap-1 bg-bg-card rounded-xl p-1">
                  <button
                    onClick={() => setViewMode('grid')}
                    className={`p-2 rounded-lg transition-all ${
                      viewMode === 'grid'
                        ? 'bg-gradient-to-r from-brand-purple to-brand-blue text-white'
                        : 'text-white/60 hover:text-white'
                    }`}
                    aria-label="Grid view"
                  >
                    <Grid size={18} />
                  </button>
                  <button
                    onClick={() => setViewMode('list')}
                    className={`p-2 rounded-lg transition-all ${
                      viewMode === 'list'
                        ? 'bg-gradient-to-r from-brand-purple to-brand-blue text-white'
                        : 'text-white/60 hover:text-white'
                    }`}
                    aria-label="List view"
                  >
                    <List size={18} />
                  </button>
                </div>
              </div>

              {/* Results Count */}
              <div className="text-white/60">
                {isLoading ? 'Loading...' : `${sortedMovies.length} movies`}
              </div>
            </div>

            {/* Filter Panel */}
            {showFilters && (
              <motion.div
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: 'auto' }}
                exit={{ opacity: 0, height: 0 }}
                className="bg-bg-card rounded-2xl p-6 space-y-6"
              >
                {/* Genre Filter */}
                <div>
                  <label className="text-sm font-semibold text-white/80 mb-3 block">
                    Genre
                  </label>
                  <div className="flex flex-wrap gap-2">
                    {GENRES.map((genre) => (
                      <button
                        key={genre.value}
                        onClick={() => setGenreFilter(genre.value)}
                        className={`px-4 py-2 rounded-xl text-sm font-semibold transition-all ${
                          genreFilter === genre.value
                            ? 'bg-gradient-to-r from-brand-purple to-brand-blue text-white shadow-lg'
                            : 'bg-white/5 text-white/60 hover:text-white hover:bg-white/10'
                        }`}
                      >
                        {genre.label}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Sort Options */}
                <div>
                  <label className="text-sm font-semibold text-white/80 mb-3 block">
                    Sort By
                  </label>
                  <div className="flex flex-wrap gap-2">
                    {SORT_OPTIONS.map((option) => (
                      <button
                        key={option.value}
                        onClick={() => setSortBy(option.value)}
                        className={`px-4 py-2 rounded-xl text-sm font-semibold transition-all ${
                          sortBy === option.value
                            ? 'bg-gradient-to-r from-brand-purple to-brand-blue text-white shadow-lg'
                            : 'bg-white/5 text-white/60 hover:text-white hover:bg-white/10'
                        }`}
                      >
                        {option.label}
                      </button>
                    ))}
                  </div>
                </div>
              </motion.div>
            )}
          </div>

          {/* Movies Grid/List */}
          {isLoading ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
              {Array.from({ length: 20 }).map((_, i) => (
                <div
                  key={i}
                  className="aspect-[2/3] bg-bg-card rounded-xl skeleton"
                />
              ))}
            </div>
          ) : viewMode === 'grid' ? (
            <motion.div
              layout
              className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4"
            >
              {sortedMovies.map((movie, index) => (
                <motion.div
                  key={movie.id}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.05, duration: 0.3 }}
                >
                  <MovieCard movie={movie} />
                </motion.div>
              ))}
            </motion.div>
          ) : (
            <div className="space-y-4">
              {sortedMovies.map((movie, index) => (
                <Link key={movie.id} href={`/movies/${movie.id}`}>
                  <motion.div
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: index * 0.03, duration: 0.3 }}
                    className="bg-bg-card rounded-xl p-4 flex gap-4 hover:bg-white/5 transition-all group cursor-pointer"
                  >
                    <img
                      src={`https://image.tmdb.org/t/p/w200${movie.poster_path}`}
                      alt={movie.title}
                      className="w-24 h-36 object-cover rounded-lg"
                    />
                    <div className="flex-1">
                      <h3 className="text-lg font-bold mb-2 group-hover:text-brand-purple transition-colors">
                        {movie.title}
                      </h3>
                      <p className="text-sm text-white/60 mb-2 line-clamp-2">
                        {movie.overview}
                      </p>
                      <div className="flex items-center gap-4 text-sm">
                        <div className="flex items-center gap-1">
                          <span className="text-yellow-400">★</span>
                          <span className="font-semibold">
                            {movie.vote_average?.toFixed(1)}
                          </span>
                        </div>
                        <span className="text-white/40">
                          {new Date(movie.release_date || '').getFullYear()}
                        </span>
                      </div>
                    </div>
                  </motion.div>
                </Link>
              ))}
            </div>
          )}

          {/* Infinite Scroll Sentinel */}
          <div ref={loadMoreRef} className="h-20 flex items-center justify-center">
            {isFetching && (
              <div className="flex items-center gap-2 text-white/60">
                <div className="w-6 h-6 border-2 border-brand-purple border-t-transparent rounded-full animate-spin" />
                <span>Loading more movies...</span>
              </div>
            )}
          </div>
        </div>

      <Footer />
    </main>
  )
}

export default function MoviesPage() {
  return (
    <AppLayout>
      <MoviesPageContent />
    </AppLayout>
  )
}

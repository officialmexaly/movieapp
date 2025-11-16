'use client'

import { useState, useEffect, useCallback } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Search as SearchIcon, SlidersHorizontal, X } from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import { Header } from '@/components/Header'
import { BottomNav } from '@/components/BottomNav'
import { MovieCard } from '@/components/MovieCard'
import { GenreChip } from '@/components/GenreChip'
import { LoadingSpinner } from '@/components/LoadingSpinner'
import * as tmdb from '@/services/tmdb'
import { GENRES } from '@/services/tmdb'

export default function SearchPage() {
  const [searchQuery, setSearchQuery] = useState('')
  const [debouncedQuery, setDebouncedQuery] = useState('')
  const [showFilters, setShowFilters] = useState(false)

  // Filter states
  const [selectedGenres, setSelectedGenres] = useState<number[]>([])
  const [yearRange, setYearRange] = useState({ min: 1990, max: 2024 })
  const [minRating, setMinRating] = useState(0)
  const [sortBy, setSortBy] = useState('popularity.desc')

  // Debounce search query
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedQuery(searchQuery)
    }, 300)

    return () => clearTimeout(timer)
  }, [searchQuery])

  // Search or discover movies
  const { data: movies, isLoading } = useQuery({
    queryKey: [
      'search',
      debouncedQuery,
      selectedGenres,
      yearRange,
      minRating,
      sortBy,
    ],
    queryFn: async () => {
      if (debouncedQuery.trim()) {
        return tmdb.searchMovies(debouncedQuery)
      } else {
        return tmdb.discoverMovies({
          genres: selectedGenres.length > 0 ? selectedGenres : undefined,
          releaseYearGte: yearRange.min,
          releaseYearLte: yearRange.max,
          voteAverageGte: minRating,
          sortBy,
        })
      }
    },
    enabled: true,
  })

  const handleGenreToggle = (genreId: number) => {
    setSelectedGenres((prev) =>
      prev.includes(genreId)
        ? prev.filter((id) => id !== genreId)
        : [...prev, genreId]
    )
  }

  const clearFilters = () => {
    setSelectedGenres([])
    setYearRange({ min: 1990, max: 2024 })
    setMinRating(0)
    setSortBy('popularity.desc')
  }

  const hasActiveFilters =
    selectedGenres.length > 0 ||
    yearRange.min !== 1990 ||
    yearRange.max !== 2024 ||
    minRating > 0 ||
    sortBy !== 'popularity.desc'

  return (
    <div className="min-h-screen bg-bg-main">
      <Header />

      <main className="pt-24 pb-24 md:pb-8 px-4">
        <div className="container mx-auto max-w-7xl">
          {/* Search Header */}
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            className="mb-8"
          >
            <h1 className="text-3xl md:text-4xl font-black mb-6">
              Search Movies
            </h1>

            {/* Search Bar */}
            <div className="flex gap-4">
              <div className="flex-1 relative">
                <SearchIcon
                  className="absolute left-4 top-1/2 -translate-y-1/2 text-white/50"
                  size={20}
                />
                <input
                  type="text"
                  placeholder="Search for movies..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full pl-12 pr-4 py-4 bg-bg-card rounded-xl text-white placeholder:text-white/50 focus:outline-none focus:ring-2 focus:ring-brand-purple"
                />
              </div>

              <button
                onClick={() => setShowFilters(!showFilters)}
                className={`px-6 py-4 rounded-xl font-semibold transition-all flex items-center gap-2 ${
                  showFilters || hasActiveFilters
                    ? 'bg-gradient-brand'
                    : 'bg-bg-card hover:bg-bg-hover'
                }`}
              >
                <SlidersHorizontal size={20} />
                <span className="hidden md:inline">Filters</span>
              </button>
            </div>
          </motion.div>

          {/* Filters Panel */}
          <AnimatePresence>
            {showFilters && (
              <motion.div
                initial={{ height: 0, opacity: 0 }}
                animate={{ height: 'auto', opacity: 1 }}
                exit={{ height: 0, opacity: 0 }}
                className="overflow-hidden mb-8"
              >
                <div className="bg-bg-card rounded-xl p-6 space-y-6">
                  {/* Genres */}
                  <div>
                    <div className="flex items-center justify-between mb-3">
                      <h3 className="font-semibold">Genres</h3>
                      {selectedGenres.length > 0 && (
                        <button
                          onClick={() => setSelectedGenres([])}
                          className="text-sm text-brand-purple hover:underline"
                        >
                          Clear
                        </button>
                      )}
                    </div>
                    <div className="flex flex-wrap gap-2">
                      {GENRES.map((genre) => (
                        <GenreChip
                          key={genre.id}
                          name={genre.name}
                          selected={selectedGenres.includes(genre.id)}
                          onClick={() => handleGenreToggle(genre.id)}
                        />
                      ))}
                    </div>
                  </div>

                  {/* Year Range */}
                  <div>
                    <h3 className="font-semibold mb-3">Release Year</h3>
                    <div className="flex gap-4 items-center">
                      <input
                        type="number"
                        min="1900"
                        max="2024"
                        value={yearRange.min}
                        onChange={(e) =>
                          setYearRange((prev) => ({
                            ...prev,
                            min: parseInt(e.target.value) || 1990,
                          }))
                        }
                        className="w-24 px-3 py-2 bg-bg-main rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-brand-purple"
                      />
                      <span className="text-white/50">to</span>
                      <input
                        type="number"
                        min="1900"
                        max="2024"
                        value={yearRange.max}
                        onChange={(e) =>
                          setYearRange((prev) => ({
                            ...prev,
                            max: parseInt(e.target.value) || 2024,
                          }))
                        }
                        className="w-24 px-3 py-2 bg-bg-main rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-brand-purple"
                      />
                    </div>
                  </div>

                  {/* Rating */}
                  <div>
                    <h3 className="font-semibold mb-3">
                      Minimum Rating: {minRating}+
                    </h3>
                    <input
                      type="range"
                      min="0"
                      max="10"
                      step="0.5"
                      value={minRating}
                      onChange={(e) => setMinRating(parseFloat(e.target.value))}
                      className="w-full accent-brand-purple"
                    />
                  </div>

                  {/* Sort By */}
                  <div>
                    <h3 className="font-semibold mb-3">Sort By</h3>
                    <select
                      value={sortBy}
                      onChange={(e) => setSortBy(e.target.value)}
                      className="w-full px-4 py-2 bg-bg-main rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-brand-purple"
                    >
                      <option value="popularity.desc">Most Popular</option>
                      <option value="popularity.asc">Least Popular</option>
                      <option value="vote_average.desc">Highest Rated</option>
                      <option value="vote_average.asc">Lowest Rated</option>
                      <option value="release_date.desc">Newest First</option>
                      <option value="release_date.asc">Oldest First</option>
                      <option value="title.asc">Title (A-Z)</option>
                      <option value="title.desc">Title (Z-A)</option>
                    </select>
                  </div>

                  {/* Clear All Filters */}
                  {hasActiveFilters && (
                    <button
                      onClick={clearFilters}
                      className="w-full px-4 py-3 bg-brand-netflix hover:bg-brand-netflix/90 rounded-lg font-semibold transition-colors flex items-center justify-center gap-2"
                    >
                      <X size={20} />
                      Clear All Filters
                    </button>
                  )}
                </div>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Results */}
          <div>
            {isLoading ? (
              <LoadingSpinner />
            ) : movies && movies.length > 0 ? (
              <>
                <p className="text-white/70 mb-4">
                  {searchQuery
                    ? `Found ${movies.length} results for "${searchQuery}"`
                    : `Showing ${movies.length} movies`}
                </p>
                <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                  {movies.map((movie, index) => (
                    <MovieCard key={movie.id} movie={movie} index={index} />
                  ))}
                </div>
              </>
            ) : (
              <div className="text-center py-16">
                <SearchIcon
                  size={64}
                  className="mx-auto mb-4 text-white/30"
                />
                <p className="text-xl text-white/70">
                  {searchQuery
                    ? 'No movies found. Try different keywords.'
                    : 'Start searching for your favorite movies'}
                </p>
              </div>
            )}
          </div>
        </div>
      </main>

      <BottomNav />
    </div>
  )
}

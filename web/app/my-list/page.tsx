'use client'

import { useState, useEffect } from 'react'
import { useQuery } from '@tanstack/react-query'
import { motion } from 'framer-motion'
import { Trash2 } from 'lucide-react'
import { Header } from '@/components/Header'
import { BottomNav } from '@/components/BottomNav'
import { MovieCard } from '@/components/MovieCard'
import { LoadingSpinner } from '@/components/LoadingSpinner'
import { getMyList, removeFromMyList } from '@/lib/storage'
import { getMovieDetails } from '@/services/tmdb'
import type { Movie } from '@/types/movie'

export default function MyListPage() {
  const [myListIds, setMyListIds] = useState<number[]>([])

  useEffect(() => {
    setMyListIds(getMyList())
  }, [])

  const { data: movies, isLoading } = useQuery({
    queryKey: ['myList', myListIds],
    queryFn: async () => {
      const moviePromises = myListIds.map((id) => getMovieDetails(id))
      return Promise.all(moviePromises)
    },
    enabled: myListIds.length > 0,
  })

  const handleRemove = (movieId: number) => {
    removeFromMyList(movieId)
    setMyListIds(getMyList())
  }

  return (
    <div className="min-h-screen bg-bg-main">
      <Header />

      <main className="pt-24 pb-24 md:pb-8 px-4">
        <div className="container mx-auto max-w-7xl">
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
          >
            <h1 className="text-3xl md:text-4xl font-black mb-2">My List</h1>
            <p className="text-white/70 mb-8">
              {myListIds.length} {myListIds.length === 1 ? 'movie' : 'movies'} saved
            </p>

            {isLoading ? (
              <LoadingSpinner />
            ) : movies && movies.length > 0 ? (
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                {movies.map((movie, index) => (
                  <div key={movie.id} className="relative group">
                    <MovieCard movie={movie as Movie} index={index} />
                    <button
                      onClick={() => handleRemove(movie.id)}
                      className="absolute top-2 left-2 p-2 rounded-full bg-brand-netflix/90 hover:bg-brand-netflix opacity-0 group-hover:opacity-100 transition-all duration-300 z-10"
                      title="Remove from list"
                    >
                      <Trash2 size={16} />
                    </button>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-16">
                <div className="w-24 h-24 mx-auto mb-6 rounded-full bg-bg-card flex items-center justify-center">
                  <span className="text-4xl">📝</span>
                </div>
                <h2 className="text-2xl font-bold mb-2">Your list is empty</h2>
                <p className="text-white/70 mb-6">
                  Start adding movies to watch them later
                </p>
                <a
                  href="/"
                  className="inline-block px-8 py-3 rounded-full bg-gradient-brand hover:opacity-90 transition-opacity font-semibold"
                >
                  Browse Movies
                </a>
              </div>
            )}
          </motion.div>
        </div>
      </main>

      <BottomNav />
    </div>
  )
}

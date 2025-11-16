'use client'

import Image from 'next/image'
import Link from 'next/link'
import { Star, Plus, Check } from 'lucide-react'
import { motion } from 'framer-motion'
import type { Movie } from '@/types/movie'
import { getImageUrl, POSTER_SIZE } from '@/services/tmdb'
import { formatRating, formatYear } from '@/lib/utils'
import { isInMyList, addToMyList, removeFromMyList } from '@/lib/storage'
import { useState, useEffect } from 'react'

interface MovieCardProps {
  movie: Movie
  index?: number
}

export function MovieCard({ movie, index = 0 }: MovieCardProps) {
  const [inMyList, setInMyList] = useState(false)

  useEffect(() => {
    setInMyList(isInMyList(movie.id))
  }, [movie.id])

  const handleToggleList = (e: React.MouseEvent) => {
    e.preventDefault()
    e.stopPropagation()

    if (inMyList) {
      removeFromMyList(movie.id)
      setInMyList(false)
    } else {
      addToMyList(movie.id)
      setInMyList(true)
    }
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05, duration: 0.3 }}
      className="group"
    >
      <Link href={`/movies/${movie.id}`} className="block">
        <div className="relative aspect-[2/3] rounded-lg overflow-hidden movie-card-hover">
          <Image
            src={getImageUrl(movie.poster_path, POSTER_SIZE)}
            alt={movie.title}
            fill
            className="object-cover"
            sizes="(max-width: 768px) 50vw, (max-width: 1200px) 33vw, 25vw"
          />

          {/* Overlay on hover */}
          <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300">
            <div className="absolute bottom-0 left-0 right-0 p-3">
              <h3 className="text-sm font-semibold mb-1 line-clamp-2">
                {movie.title}
              </h3>
              <div className="flex items-center justify-between text-xs">
                <div className="flex items-center gap-1">
                  <Star size={12} className="fill-yellow-500 text-yellow-500" />
                  <span>{formatRating(movie.vote_average)}</span>
                </div>
                {movie.release_date && (
                  <span className="text-white/70">
                    {formatYear(movie.release_date)}
                  </span>
                )}
              </div>
            </div>
          </div>

          {/* Add to list button */}
          <button
            onClick={handleToggleList}
            className="absolute top-2 right-2 p-2 rounded-full bg-black/70 hover:bg-black/90 opacity-0 group-hover:opacity-100 transition-all duration-300 z-10"
          >
            {inMyList ? (
              <Check size={16} className="text-brand-purple" />
            ) : (
              <Plus size={16} />
            )}
          </button>
        </div>
      </Link>
    </motion.div>
  )
}

'use client'

import Image from 'next/image'
import Link from 'next/link'
import { Play, Info, Star } from 'lucide-react'
import { motion } from 'framer-motion'
import type { Movie } from '@/types/movie'
import { getImageUrl, BACKDROP_SIZE } from '@/services/tmdb'
import { formatRating, truncateText } from '@/lib/utils'

interface FeaturedCardProps {
  movie: Movie
}

export function FeaturedCard({ movie }: FeaturedCardProps) {
  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
      className="relative w-full h-[500px] md:h-[600px] rounded-2xl overflow-hidden animate-pulse-glow"
    >
      {/* Background Image */}
      <Image
        src={getImageUrl(movie.backdrop_path, BACKDROP_SIZE)}
        alt={movie.title}
        fill
        className="object-cover"
        priority
      />

      {/* Gradient Overlay */}
      <div className="absolute inset-0 bg-gradient-to-t from-bg-main via-bg-main/60 to-transparent" />
      <div className="absolute inset-0 bg-gradient-to-r from-bg-main/80 via-transparent to-transparent" />

      {/* Content */}
      <div className="absolute bottom-0 left-0 right-0 p-6 md:p-12">
        <motion.div
          initial={{ y: 50, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.3, duration: 0.8 }}
          className="max-w-2xl"
        >
          {/* Featured Badge */}
          <div className="inline-block px-4 py-1 mb-4 rounded-full bg-gradient-brand text-xs font-semibold">
            FEATURED
          </div>

          {/* Title */}
          <h1 className="text-4xl md:text-6xl font-black mb-4 text-white drop-shadow-lg">
            {movie.title}
          </h1>

          {/* Rating & Year */}
          <div className="flex items-center gap-4 mb-4 text-sm">
            <div className="flex items-center gap-1">
              <Star size={18} className="fill-yellow-500 text-yellow-500" />
              <span className="font-semibold">{formatRating(movie.vote_average)}</span>
            </div>
            {movie.release_date && (
              <>
                <span className="text-white/50">•</span>
                <span className="text-white/90">
                  {new Date(movie.release_date).getFullYear()}
                </span>
              </>
            )}
          </div>

          {/* Overview */}
          <p className="text-white/90 text-sm md:text-base mb-6 leading-relaxed max-w-xl">
            {truncateText(movie.overview, 200)}
          </p>

          {/* Action Buttons */}
          <div className="flex flex-wrap gap-4">
            <Link
              href={`/movies/${movie.id}/watch`}
              className="inline-flex items-center gap-2 px-8 py-3 rounded-full bg-gradient-brand hover:opacity-90 transition-opacity font-semibold"
            >
              <Play size={20} fill="white" />
              Watch Now
            </Link>
            <Link
              href={`/movies/${movie.id}`}
              className="inline-flex items-center gap-2 px-8 py-3 rounded-full glass-effect hover:bg-white/20 transition-colors font-semibold"
            >
              <Info size={20} />
              More Info
            </Link>
          </div>
        </motion.div>
      </div>
    </motion.div>
  )
}

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
        unoptimized
      />

      {/* Gradient Overlay */}
      <div className="absolute inset-0 bg-gradient-to-t from-bg-main via-bg-main/60 to-transparent" />
      <div className="absolute inset-0 bg-gradient-to-r from-bg-main/80 via-transparent to-transparent" />

      {/* Content */}
      <div className="absolute bottom-0 left-0 right-0 p-4 md:p-12">
        <motion.div
          initial={{ y: 50, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.3, duration: 0.8 }}
          className="max-w-2xl"
        >
          {/* Featured Badge */}
          <div className="inline-flex items-center px-3 py-1 mb-3 rounded-full bg-gradient-to-r from-brand-purple/90 to-brand-blue/90 backdrop-blur-sm text-[10px] md:text-xs font-bold tracking-wider">
            FEATURED
          </div>

          {/* Title */}
          <h1 className="text-3xl md:text-6xl font-black mb-2 md:mb-4 text-white drop-shadow-2xl leading-tight">
            {movie.title}
          </h1>

          {/* Rating & Year */}
          <div className="flex items-center gap-3 mb-3 md:mb-4 text-xs md:text-sm">
            <div className="flex items-center gap-1 bg-black/40 backdrop-blur-sm px-2 py-1 rounded-lg">
              <Star size={14} className="fill-yellow-500 text-yellow-500" />
              <span className="font-bold">{formatRating(movie.vote_average)}</span>
            </div>
            {movie.release_date && (
              <div className="bg-black/40 backdrop-blur-sm px-2 py-1 rounded-lg">
                <span className="font-semibold">
                  {new Date(movie.release_date).getFullYear()}
                </span>
              </div>
            )}
          </div>

          {/* Overview */}
          <p className="text-white/90 text-xs md:text-base mb-4 md:mb-6 leading-relaxed max-w-xl line-clamp-2 md:line-clamp-3">
            {truncateText(movie.overview, 200)}
          </p>

          {/* Action Buttons */}
          <div className="flex flex-wrap gap-2 md:gap-4">
            <Link
              href={`/movies/${movie.id}/watch`}
              className="inline-flex items-center gap-2 px-6 md:px-8 py-2.5 md:py-3 rounded-xl md:rounded-full bg-gradient-to-r from-brand-purple to-brand-blue hover:shadow-lg hover:shadow-brand-purple/30 active:scale-95 transition-all font-bold text-sm md:text-base"
            >
              <Play size={18} fill="white" />
              <span>Watch Now</span>
            </Link>
            <Link
              href={`/movies/${movie.id}`}
              className="inline-flex items-center gap-2 px-6 md:px-8 py-2.5 md:py-3 rounded-xl md:rounded-full bg-white/10 backdrop-blur-sm hover:bg-white/20 active:scale-95 transition-all font-semibold text-sm md:text-base border border-white/20"
            >
              <Info size={18} />
              <span>More Info</span>
            </Link>
          </div>
        </motion.div>
      </div>
    </motion.div>
  )
}

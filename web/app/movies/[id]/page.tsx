'use client'

import { useQuery } from '@tanstack/react-query'
import { useParams, useRouter } from 'next/navigation'
import Image from 'next/image'
import Link from 'next/link'
import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import {
  Play,
  Star,
  Clock,
  Calendar,
  Plus,
  Check,
  ChevronLeft,
  Youtube,
} from 'lucide-react'
import { Header } from '@/components/Header'
import { BottomNav } from '@/components/BottomNav'
import { CategorySection } from '@/components/CategorySection'
import { LoadingSpinner } from '@/components/LoadingSpinner'
import * as tmdb from '@/services/tmdb'
import { getImageUrl, BACKDROP_SIZE, PROFILE_SIZE } from '@/services/tmdb'
import {
  formatRuntime,
  formatRating,
  formatDate,
  formatYear,
  truncateText,
} from '@/lib/utils'
import { isInMyList, addToMyList, removeFromMyList } from '@/lib/storage'

export default function MovieDetailPage() {
  const params = useParams()
  const router = useRouter()
  const movieId = parseInt(params.id as string)

  const [inMyList, setInMyList] = useState(false)
  const [showFullOverview, setShowFullOverview] = useState(false)

  useEffect(() => {
    setInMyList(isInMyList(movieId))
  }, [movieId])

  const { data: movie, isLoading: movieLoading } = useQuery({
    queryKey: ['movie', movieId],
    queryFn: () => tmdb.getMovieDetails(movieId),
  })

  const { data: credits } = useQuery({
    queryKey: ['credits', movieId],
    queryFn: () => tmdb.getMovieCredits(movieId),
    enabled: !!movie,
  })

  const { data: reviews } = useQuery({
    queryKey: ['reviews', movieId],
    queryFn: () => tmdb.getMovieReviews(movieId),
    enabled: !!movie,
  })

  const { data: videos } = useQuery({
    queryKey: ['videos', movieId],
    queryFn: () => tmdb.getMovieVideos(movieId),
    enabled: !!movie,
  })

  const { data: similar } = useQuery({
    queryKey: ['similar', movieId],
    queryFn: () => tmdb.getSimilarMovies(movieId),
    enabled: !!movie,
  })

  const handleToggleList = () => {
    if (inMyList) {
      removeFromMyList(movieId)
      setInMyList(false)
    } else {
      addToMyList(movieId)
      setInMyList(true)
    }
  }

  if (movieLoading) {
    return (
      <div className="min-h-screen bg-bg-main">
        <Header />
        <LoadingSpinner />
      </div>
    )
  }

  if (!movie) {
    return (
      <div className="min-h-screen bg-bg-main">
        <Header />
        <div className="flex items-center justify-center h-screen">
          <p className="text-white/70">Movie not found</p>
        </div>
      </div>
    )
  }

  const trailer = videos?.find((v) => v.type === 'Trailer' && v.site === 'YouTube')
  const mainCast = credits?.cast.slice(0, 10) || []

  return (
    <div className="min-h-screen bg-bg-main">
      <Header />

      <main className="pt-20 pb-24 md:pb-8">
        {/* Hero Section */}
        <div className="relative h-[500px] md:h-[700px]">
          {/* Backdrop Image */}
          <Image
            src={getImageUrl(movie.backdrop_path, BACKDROP_SIZE)}
            alt={movie.title}
            fill
            className="object-cover"
            priority
          />

          {/* Gradient Overlays */}
          <div className="absolute inset-0 bg-gradient-to-t from-bg-main via-bg-main/60 to-transparent" />
          <div className="absolute inset-0 bg-gradient-to-r from-bg-main/80 via-transparent to-transparent" />

          {/* Back Button */}
          <button
            onClick={() => router.back()}
            className="absolute top-24 left-4 p-3 rounded-full glass-effect hover:bg-white/20 transition-colors z-10"
          >
            <ChevronLeft size={24} />
          </button>

          {/* Content */}
          <div className="absolute bottom-0 left-0 right-0 p-6 md:p-12">
            <motion.div
              initial={{ y: 50, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ duration: 0.8 }}
              className="max-w-4xl"
            >
              {/* Title */}
              <h1 className="text-4xl md:text-6xl font-black mb-4 text-white drop-shadow-lg">
                {movie.title}
              </h1>

              {/* Meta Info */}
              <div className="flex flex-wrap items-center gap-4 mb-4 text-sm md:text-base">
                <div className="flex items-center gap-1">
                  <Star size={20} className="fill-yellow-500 text-yellow-500" />
                  <span className="font-semibold">
                    {formatRating(movie.vote_average)}
                  </span>
                  <span className="text-white/50">
                    ({movie.vote_count.toLocaleString()} votes)
                  </span>
                </div>

                {movie.release_date && (
                  <>
                    <span className="text-white/50">•</span>
                    <div className="flex items-center gap-1">
                      <Calendar size={18} />
                      <span>{formatYear(movie.release_date)}</span>
                    </div>
                  </>
                )}

                {movie.runtime && (
                  <>
                    <span className="text-white/50">•</span>
                    <div className="flex items-center gap-1">
                      <Clock size={18} />
                      <span>{formatRuntime(movie.runtime)}</span>
                    </div>
                  </>
                )}
              </div>

              {/* Genres */}
              {movie.genres && movie.genres.length > 0 && (
                <div className="flex flex-wrap gap-2 mb-6">
                  {movie.genres.map((genre) => (
                    <span
                      key={genre.id}
                      className="px-3 py-1 rounded-full bg-white/10 text-sm"
                    >
                      {genre.name}
                    </span>
                  ))}
                </div>
              )}

              {/* Action Buttons */}
              <div className="flex flex-wrap gap-4">
                <Link
                  href={`/movies/${movieId}/watch`}
                  className="inline-flex items-center gap-2 px-8 py-3 rounded-full bg-gradient-brand hover:opacity-90 transition-opacity font-semibold"
                >
                  <Play size={20} fill="white" />
                  Watch Now
                </Link>

                <button
                  onClick={handleToggleList}
                  className="inline-flex items-center gap-2 px-8 py-3 rounded-full glass-effect hover:bg-white/20 transition-colors font-semibold"
                >
                  {inMyList ? (
                    <>
                      <Check size={20} />
                      In My List
                    </>
                  ) : (
                    <>
                      <Plus size={20} />
                      Add to List
                    </>
                  )}
                </button>

                {trailer && (
                  <a
                    href={`https://www.youtube.com/watch?v=${trailer.key}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-2 px-8 py-3 rounded-full glass-effect hover:bg-white/20 transition-colors font-semibold"
                  >
                    <Youtube size={20} />
                    Watch Trailer
                  </a>
                )}
              </div>
            </motion.div>
          </div>
        </div>

        {/* Details Section */}
        <div className="container mx-auto px-4 md:px-12 mt-12 space-y-12">
          {/* Overview */}
          <motion.section
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.2 }}
          >
            <h2 className="text-2xl font-bold mb-4">Overview</h2>
            <p className="text-white/90 leading-relaxed max-w-4xl">
              {showFullOverview || movie.overview.length <= 300
                ? movie.overview
                : truncateText(movie.overview, 300)}
              {movie.overview.length > 300 && (
                <button
                  onClick={() => setShowFullOverview(!showFullOverview)}
                  className="ml-2 text-brand-purple hover:underline"
                >
                  {showFullOverview ? 'Show less' : 'Read more'}
                </button>
              )}
            </p>

            {movie.tagline && (
              <p className="mt-4 text-white/70 italic">"{movie.tagline}"</p>
            )}
          </motion.section>

          {/* Cast */}
          {mainCast.length > 0 && (
            <motion.section
              initial={{ y: 20, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.3 }}
            >
              <h2 className="text-2xl font-bold mb-4">Cast</h2>
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
                {mainCast.map((cast) => (
                  <div key={cast.id} className="text-center">
                    <div className="relative aspect-square rounded-lg overflow-hidden mb-2 bg-bg-card">
                      {cast.profile_path ? (
                        <Image
                          src={getImageUrl(cast.profile_path, PROFILE_SIZE)}
                          alt={cast.name}
                          fill
                          className="object-cover"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center">
                          <span className="text-4xl text-white/30">
                            {cast.name[0]}
                          </span>
                        </div>
                      )}
                    </div>
                    <p className="font-semibold text-sm">{cast.name}</p>
                    <p className="text-xs text-white/70">{cast.character}</p>
                  </div>
                ))}
              </div>
            </motion.section>
          )}

          {/* Reviews */}
          {reviews && reviews.length > 0 && (
            <motion.section
              initial={{ y: 20, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.4 }}
            >
              <h2 className="text-2xl font-bold mb-4">Reviews</h2>
              <div className="space-y-4">
                {reviews.slice(0, 3).map((review) => (
                  <div key={review.id} className="bg-bg-card rounded-xl p-6">
                    <div className="flex items-start gap-4 mb-3">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <p className="font-semibold">
                            {review.author_details.username}
                          </p>
                          {review.author_details.rating && (
                            <div className="flex items-center gap-1 px-2 py-1 rounded bg-bg-main text-xs">
                              <Star
                                size={12}
                                className="fill-yellow-500 text-yellow-500"
                              />
                              <span>{review.author_details.rating}</span>
                            </div>
                          )}
                        </div>
                        <p className="text-xs text-white/50">
                          {formatDate(review.created_at)}
                        </p>
                      </div>
                    </div>
                    <p className="text-white/80 text-sm leading-relaxed">
                      {truncateText(review.content, 300)}
                    </p>
                  </div>
                ))}
              </div>
            </motion.section>
          )}

          {/* Similar Movies */}
          {similar && similar.length > 0 && (
            <motion.section
              initial={{ y: 20, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.5 }}
            >
              <CategorySection title="Similar Movies" movies={similar} />
            </motion.section>
          )}
        </div>
      </main>

      <BottomNav />
    </div>
  )
}

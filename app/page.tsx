'use client'

import { useQuery } from '@tanstack/react-query'
import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Header } from '@/components/Header'
import { BottomNav } from '@/components/BottomNav'
import { FeaturedCard } from '@/components/FeaturedCard'
import { CategorySection } from '@/components/CategorySection'
import { SkeletonSection } from '@/components/SkeletonCard'
import * as tmdb from '@/services/tmdb'

export default function HomePage() {
  const [featuredIndex, setFeaturedIndex] = useState(0)

  // Query options for better caching and performance
  const queryOptions = {
    staleTime: 1000 * 60 * 5, // 5 minutes
    gcTime: 1000 * 60 * 30, // 30 minutes (previously cacheTime)
    refetchOnWindowFocus: false,
  }

  // Priority queries - load immediately
  const { data: trending } = useQuery({
    queryKey: ['trending'],
    queryFn: () => tmdb.getTrendingMovies('week'),
    ...queryOptions,
  })

  const { data: popular } = useQuery({
    queryKey: ['popular'],
    queryFn: () => tmdb.getPopularMovies(),
    ...queryOptions,
  })

  const { data: topRated } = useQuery({
    queryKey: ['topRated'],
    queryFn: () => tmdb.getTopRatedMovies(),
    ...queryOptions,
  })

  const { data: awardWinning } = useQuery({
    queryKey: ['awardWinning'],
    queryFn: () => tmdb.getAwardWinningMovies(),
    ...queryOptions,
  })

  // Deferred queries - load after priority content is visible
  const { data: nowPlaying } = useQuery({
    queryKey: ['nowPlaying'],
    queryFn: () => tmdb.getNowPlayingMovies(),
    ...queryOptions,
    enabled: !!trending, // Wait for trending to load first
  })

  const { data: upcoming } = useQuery({
    queryKey: ['upcoming'],
    queryFn: () => tmdb.getUpcomingMovies(),
    ...queryOptions,
    enabled: !!trending,
  })

  const { data: action } = useQuery({
    queryKey: ['action'],
    queryFn: () => tmdb.getActionMovies(),
    ...queryOptions,
    enabled: !!popular,
  })

  const { data: comedy } = useQuery({
    queryKey: ['comedy'],
    queryFn: () => tmdb.getComedyMovies(),
    ...queryOptions,
    enabled: !!popular,
  })

  const { data: drama } = useQuery({
    queryKey: ['drama'],
    queryFn: () => tmdb.getDramaMovies(),
    ...queryOptions,
    enabled: !!popular,
  })

  const { data: horror } = useQuery({
    queryKey: ['horror'],
    queryFn: () => tmdb.getHorrorMovies(),
    ...queryOptions,
    enabled: !!topRated,
  })

  const { data: scifi } = useQuery({
    queryKey: ['scifi'],
    queryFn: () => tmdb.getSciFiMovies(),
    ...queryOptions,
    enabled: !!topRated,
  })

  const { data: romance } = useQuery({
    queryKey: ['romance'],
    queryFn: () => tmdb.getRomanceMovies(),
    ...queryOptions,
    enabled: !!topRated,
  })

  const { data: thriller } = useQuery({
    queryKey: ['thriller'],
    queryFn: () => tmdb.getThrillerMovies(),
    ...queryOptions,
    enabled: !!awardWinning,
  })

  const { data: animation } = useQuery({
    queryKey: ['animation'],
    queryFn: () => tmdb.getAnimationMovies(),
    ...queryOptions,
    enabled: !!awardWinning,
  })

  const { data: family } = useQuery({
    queryKey: ['family'],
    queryFn: () => tmdb.getFamilyMovies(),
    ...queryOptions,
    enabled: !!awardWinning,
  })

  const { data: classics } = useQuery({
    queryKey: ['classics'],
    queryFn: () => tmdb.getClassicMovies(),
    ...queryOptions,
    enabled: !!awardWinning,
  })

  // Auto-rotate featured movies every 5 seconds
  useEffect(() => {
    if (!trending || trending.length === 0) return

    const interval = setInterval(() => {
      setFeaturedIndex((prev) => (prev + 1) % Math.min(5, trending.length))
    }, 5000)

    return () => clearInterval(interval)
  }, [trending])

  const featuredMovies = trending?.slice(0, 5) || []
  const currentFeatured = featuredMovies[featuredIndex]

  return (
    <div className="min-h-screen bg-bg-main">
      <Header />

      <main className="pt-20 pb-24 md:pb-8">
        {/* Featured Section */}
        <section className="mb-12 px-4">
          <AnimatePresence mode="wait">
            {currentFeatured ? (
              <FeaturedCard key={currentFeatured.id} movie={currentFeatured} />
            ) : (
              <div className="w-full h-[500px] md:h-[600px] bg-bg-card skeleton rounded-2xl" />
            )}
          </AnimatePresence>

          {/* Featured Indicators */}
          {featuredMovies.length > 1 && (
            <div className="flex justify-center gap-2 mt-4">
              {featuredMovies.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setFeaturedIndex(index)}
                  className={`h-1 rounded-full transition-all ${
                    index === featuredIndex
                      ? 'w-8 bg-brand-purple'
                      : 'w-4 bg-white/30 hover:bg-white/50'
                  }`}
                  aria-label={`Go to featured movie ${index + 1}`}
                />
              ))}
            </div>
          )}
        </section>

        {/* Movie Categories */}
        <div className="space-y-8">
          {popular ? (
            <CategorySection title="Popular Movies" movies={popular} />
          ) : (
            <SkeletonSection />
          )}

          {trending ? (
            <CategorySection title="Trending This Week" movies={trending} />
          ) : (
            <SkeletonSection />
          )}

          {topRated ? (
            <CategorySection title="Top Rated" movies={topRated} />
          ) : (
            <SkeletonSection />
          )}

          {awardWinning ? (
            <CategorySection title="Award Winners" movies={awardWinning} />
          ) : (
            <SkeletonSection />
          )}

          {nowPlaying && (
            <CategorySection title="Now Playing" movies={nowPlaying} />
          )}

          {upcoming && (
            <CategorySection title="Coming Soon" movies={upcoming} />
          )}

          {action && <CategorySection title="Action & Adventure" movies={action} />}

          {comedy && <CategorySection title="Comedy" movies={comedy} />}

          {drama && <CategorySection title="Drama" movies={drama} />}

          {horror && <CategorySection title="Horror" movies={horror} />}

          {scifi && <CategorySection title="Science Fiction" movies={scifi} />}

          {thriller && <CategorySection title="Thriller" movies={thriller} />}

          {romance && <CategorySection title="Romance" movies={romance} />}

          {animation && <CategorySection title="Animation" movies={animation} />}

          {family && <CategorySection title="Family" movies={family} />}

          {classics && (
            <CategorySection title="Classic Collection" movies={classics} />
          )}
        </div>
      </main>

      <BottomNav />
    </div>
  )
}

'use client'

import { useRef } from 'react'
import { ChevronLeft, ChevronRight } from 'lucide-react'
import { MovieCard } from './MovieCard'
import type { Movie } from '@/types/movie'

interface CategorySectionProps {
  title: string
  movies: Movie[]
}

export function CategorySection({ title, movies }: CategorySectionProps) {
  const scrollRef = useRef<HTMLDivElement>(null)

  const scroll = (direction: 'left' | 'right') => {
    if (scrollRef.current) {
      const scrollAmount = 400
      const newScrollLeft =
        direction === 'left'
          ? scrollRef.current.scrollLeft - scrollAmount
          : scrollRef.current.scrollLeft + scrollAmount

      scrollRef.current.scrollTo({
        left: newScrollLeft,
        behavior: 'smooth',
      })
    }
  }

  if (!movies || movies.length === 0) return null

  return (
    <div className="mb-8 md:mb-12">
      <h2 className="text-xl md:text-2xl font-bold mb-3 md:mb-4 px-4 text-white">{title}</h2>

      <div className="relative group">
        {/* Left Arrow - Desktop Only */}
        <button
          onClick={() => scroll('left')}
          className="hidden md:block absolute left-2 top-1/2 -translate-y-1/2 z-10 p-2 rounded-full bg-black/80 backdrop-blur-sm hover:bg-brand-purple/80 opacity-0 group-hover:opacity-100 transition-all hover:scale-110"
          aria-label="Scroll left"
        >
          <ChevronLeft size={24} />
        </button>

        {/* Movies Container */}
        <div
          ref={scrollRef}
          className="flex gap-3 md:gap-4 overflow-x-auto scrollbar-hide px-4 scroll-smooth snap-x snap-mandatory"
          style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
        >
          {movies.map((movie, index) => (
            <div key={movie.id} className="flex-none w-36 md:w-48 snap-start">
              <MovieCard movie={movie} index={index} />
            </div>
          ))}
        </div>

        {/* Right Arrow - Desktop Only */}
        <button
          onClick={() => scroll('right')}
          className="hidden md:block absolute right-2 top-1/2 -translate-y-1/2 z-10 p-2 rounded-full bg-black/80 backdrop-blur-sm hover:bg-brand-purple/80 opacity-0 group-hover:opacity-100 transition-all hover:scale-110"
          aria-label="Scroll right"
        >
          <ChevronRight size={24} />
        </button>
      </div>

      <style jsx>{`
        .scrollbar-hide::-webkit-scrollbar {
          display: none;
        }
      `}</style>
    </div>
  )
}

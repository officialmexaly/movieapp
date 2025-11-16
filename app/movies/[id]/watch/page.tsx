'use client'

import { useState, useEffect, useRef } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { useQuery } from '@tanstack/react-query'
import dynamic from 'next/dynamic'
import {
  Play,
  Pause,
  Volume2,
  VolumeX,
  Maximize,
  Minimize,
  Settings,
  ChevronLeft,
  Subtitles,
} from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import * as tmdb from '@/services/tmdb-cached'
import { updateWatchProgress, getWatchProgress } from '@/lib/storage'

// Dynamically import ReactPlayer to avoid SSR issues
const ReactPlayer = dynamic(() => import('react-player'), { ssr: false })

type Quality = 'auto' | '1080p' | '720p' | '480p' | '360p'
type Subtitle = 'off' | 'en' | 'es' | 'fr' | 'de' | 'it' | 'pt' | 'ja' | 'ko' | 'zh'

const QUALITIES: Quality[] = ['auto', '1080p', '720p', '480p', '360p']
const SUBTITLES: { value: Subtitle; label: string }[] = [
  { value: 'off', label: 'Off' },
  { value: 'en', label: 'English' },
  { value: 'es', label: 'Spanish' },
  { value: 'fr', label: 'French' },
  { value: 'de', label: 'German' },
  { value: 'it', label: 'Italian' },
  { value: 'pt', label: 'Portuguese' },
  { value: 'ja', label: 'Japanese' },
  { value: 'ko', label: 'Korean' },
  { value: 'zh', label: 'Chinese' },
]

export default function WatchPage() {
  const params = useParams()
  const router = useRouter()
  const movieId = parseInt(params.id as string)

  const playerRef = useRef<any>(null)
  const controlsTimeoutRef = useRef<NodeJS.Timeout | undefined>(undefined)

  const [playing, setPlaying] = useState(false)
  const [volume, setVolume] = useState(1)
  const [muted, setMuted] = useState(false)
  const [played, setPlayed] = useState(0)
  const [duration, setDuration] = useState(0)
  const [fullscreen, setFullscreen] = useState(false)
  const [showControls, setShowControls] = useState(true)
  const [showSettings, setShowSettings] = useState(false)
  const [quality, setQuality] = useState<Quality>('auto')
  const [subtitle, setSubtitle] = useState<Subtitle>('off')

  const { data: movie } = useQuery({
    queryKey: ['movie', movieId],
    queryFn: () => tmdb.getMovieDetails(movieId),
  })

  const { data: videos } = useQuery({
    queryKey: ['videos', movieId],
    queryFn: () => tmdb.getMovieVideos(movieId),
    enabled: !!movie,
  })

  // Load saved progress
  useEffect(() => {
    const savedProgress = getWatchProgress(movieId)
    if (savedProgress > 0 && savedProgress < 0.9) {
      setPlayed(savedProgress)
      if (playerRef.current) {
        playerRef.current.seekTo(savedProgress)
      }
    }
  }, [movieId])

  // Save progress periodically
  useEffect(() => {
    const interval = setInterval(() => {
      if (playing && played > 0) {
        updateWatchProgress(movieId, played)
      }
    }, 10000) // Save every 10 seconds

    return () => clearInterval(interval)
  }, [playing, played, movieId])

  // Auto-hide controls
  useEffect(() => {
    if (showControls && playing) {
      if (controlsTimeoutRef.current) {
        clearTimeout(controlsTimeoutRef.current)
      }

      controlsTimeoutRef.current = setTimeout(() => {
        setShowControls(false)
        setShowSettings(false)
      }, 3000)
    }

    return () => {
      if (controlsTimeoutRef.current) {
        clearTimeout(controlsTimeoutRef.current)
      }
    }
  }, [showControls, playing])

  const handlePlayPause = () => {
    setPlaying(!playing)
  }

  const handleProgress = (state: any) => {
    setPlayed(state.played)
  }

  const handleDuration = (duration: number) => {
    setDuration(duration)
  }

  const handleSeek = (value: number) => {
    setPlayed(value)
    if (playerRef.current) {
      playerRef.current.seekTo(value)
    }
  }

  const handleVolumeChange = (value: number) => {
    setVolume(value)
    setMuted(value === 0)
  }

  const toggleMute = () => {
    setMuted(!muted)
  }

  const toggleFullscreen = () => {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen()
      setFullscreen(true)
    } else {
      document.exitFullscreen()
      setFullscreen(false)
    }
  }

  const handleMouseMove = () => {
    setShowControls(true)
  }

  const formatTime = (seconds: number) => {
    const h = Math.floor(seconds / 3600)
    const m = Math.floor((seconds % 3600) / 60)
    const s = Math.floor(seconds % 60)

    if (h > 0) {
      return `${h}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
    }
    return `${m}:${s.toString().padStart(2, '0')}`
  }

  // Demo video URL (In production, this would be the actual movie stream)
  const trailer = videos?.find((v) => v.type === 'Trailer' && v.site === 'YouTube')
  const videoUrl = trailer
    ? `https://www.youtube.com/watch?v=${trailer.key}`
    : 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' // Fallback demo video

  return (
    <div
      className="relative w-full h-screen bg-black overflow-hidden"
      onMouseMove={handleMouseMove}
    >
      {/* Video Player */}
      <div className="w-full h-full">
        <ReactPlayer
          ref={playerRef}
          url={videoUrl}
          playing={playing}
          volume={volume}
          muted={muted}
          onProgress={handleProgress}
          onDuration={handleDuration}
          width="100%"
          height="100%"
          config={{
            youtube: {
              playerVars: { showinfo: 0, controls: 0 },
            },
          }}
        />
      </div>

      {/* Top Bar */}
      <AnimatePresence>
        {showControls && (
          <motion.div
            initial={{ y: -100, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: -100, opacity: 0 }}
            className="absolute top-0 left-0 right-0 p-6 bg-gradient-to-b from-black/80 to-transparent z-10"
          >
            <div className="flex items-center justify-between">
              <button
                onClick={() => router.back()}
                className="p-2 hover:bg-white/10 rounded-full transition-colors"
              >
                <ChevronLeft size={24} />
              </button>

              <div className="flex-1 ml-4">
                <h1 className="text-xl font-bold">{movie?.title || 'Loading...'}</h1>
                {quality !== 'auto' && (
                  <p className="text-sm text-white/70">Quality: {quality}</p>
                )}
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Center Play Button */}
      {!playing && (
        <motion.button
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          onClick={handlePlayPause}
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 p-6 rounded-full bg-brand-purple/90 hover:bg-brand-purple transition-colors z-10"
        >
          <Play size={48} fill="white" />
        </motion.button>
      )}

      {/* Bottom Controls */}
      <AnimatePresence>
        {showControls && (
          <motion.div
            initial={{ y: 100, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: 100, opacity: 0 }}
            className="absolute bottom-0 left-0 right-0 p-6 bg-gradient-to-t from-black/80 to-transparent z-10"
          >
            {/* Progress Bar */}
            <div className="mb-4">
              <input
                type="range"
                min={0}
                max={0.999999}
                step={0.001}
                value={played}
                onChange={(e) => handleSeek(parseFloat(e.target.value))}
                className="w-full accent-brand-purple cursor-pointer"
              />
              <div className="flex justify-between text-xs text-white/70 mt-1">
                <span>{formatTime(duration * played)}</span>
                <span>{formatTime(duration)}</span>
              </div>
            </div>

            {/* Controls */}
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-4">
                {/* Play/Pause */}
                <button
                  onClick={handlePlayPause}
                  className="p-2 hover:bg-white/10 rounded-full transition-colors"
                >
                  {playing ? <Pause size={24} /> : <Play size={24} />}
                </button>

                {/* Volume */}
                <div className="flex items-center gap-2 group">
                  <button
                    onClick={toggleMute}
                    className="p-2 hover:bg-white/10 rounded-full transition-colors"
                  >
                    {muted || volume === 0 ? (
                      <VolumeX size={24} />
                    ) : (
                      <Volume2 size={24} />
                    )}
                  </button>
                  <input
                    type="range"
                    min={0}
                    max={1}
                    step={0.1}
                    value={muted ? 0 : volume}
                    onChange={(e) => handleVolumeChange(parseFloat(e.target.value))}
                    className="w-0 group-hover:w-20 transition-all accent-brand-purple cursor-pointer"
                  />
                </div>

                {/* Time */}
                <span className="text-sm">
                  {formatTime(duration * played)} / {formatTime(duration)}
                </span>
              </div>

              <div className="flex items-center gap-2">
                {/* Subtitles */}
                <div className="relative">
                  <button
                    onClick={() => setShowSettings(showSettings === false ? true : false)}
                    className={`p-2 hover:bg-white/10 rounded-full transition-colors ${
                      subtitle !== 'off' ? 'text-brand-purple' : ''
                    }`}
                  >
                    <Subtitles size={24} />
                  </button>

                  {showSettings && (
                    <div className="absolute bottom-full right-0 mb-2 p-4 rounded-lg bg-bg-card min-w-[200px]">
                      <div className="mb-4">
                        <h3 className="text-sm font-semibold mb-2">Quality</h3>
                        <div className="space-y-1">
                          {QUALITIES.map((q) => (
                            <button
                              key={q}
                              onClick={() => setQuality(q)}
                              className={`w-full text-left px-3 py-2 rounded hover:bg-white/10 text-sm ${
                                quality === q ? 'text-brand-purple font-semibold' : ''
                              }`}
                            >
                              {q.charAt(0).toUpperCase() + q.slice(1)}
                            </button>
                          ))}
                        </div>
                      </div>

                      <div>
                        <h3 className="text-sm font-semibold mb-2">Subtitles</h3>
                        <div className="space-y-1 max-h-48 overflow-y-auto">
                          {SUBTITLES.map((s) => (
                            <button
                              key={s.value}
                              onClick={() => setSubtitle(s.value)}
                              className={`w-full text-left px-3 py-2 rounded hover:bg-white/10 text-sm ${
                                subtitle === s.value
                                  ? 'text-brand-purple font-semibold'
                                  : ''
                              }`}
                            >
                              {s.label}
                            </button>
                          ))}
                        </div>
                      </div>
                    </div>
                  )}
                </div>

                {/* Settings */}
                <button
                  onClick={() => setShowSettings(!showSettings)}
                  className="p-2 hover:bg-white/10 rounded-full transition-colors"
                >
                  <Settings size={24} />
                </button>

                {/* Fullscreen */}
                <button
                  onClick={toggleFullscreen}
                  className="p-2 hover:bg-white/10 rounded-full transition-colors"
                >
                  {fullscreen ? <Minimize size={24} /> : <Maximize size={24} />}
                </button>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}

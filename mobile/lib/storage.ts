// Local storage utilities for user preferences and data

export interface UserPreferences {
  darkMode: boolean
  autoPlay: boolean
  preferredQuality: 'auto' | '1080p' | '720p' | '480p' | '360p'
  notifications: boolean
}

export interface WatchHistoryItem {
  movieId: number
  title: string
  thumbnail: string
  watchedAt: string
  progress: number
}

const STORAGE_KEYS = {
  USER_PREFERENCES: 'deyeturn_user_preferences',
  WATCH_HISTORY: 'deyeturn_watch_history',
  MY_LIST: 'deyeturn_my_list',
  CONTINUE_WATCHING: 'deyeturn_continue_watching',
}

// User Preferences
export function getUserPreferences(): UserPreferences {
  if (typeof window === 'undefined') {
    return getDefaultPreferences()
  }

  const stored = localStorage.getItem(STORAGE_KEYS.USER_PREFERENCES)
  if (!stored) return getDefaultPreferences()

  try {
    return JSON.parse(stored)
  } catch {
    return getDefaultPreferences()
  }
}

export function saveUserPreferences(preferences: UserPreferences): void {
  if (typeof window === 'undefined') return
  localStorage.setItem(STORAGE_KEYS.USER_PREFERENCES, JSON.stringify(preferences))
}

function getDefaultPreferences(): UserPreferences {
  return {
    darkMode: true,
    autoPlay: true,
    preferredQuality: 'auto',
    notifications: true,
  }
}

// Watch History
export function getWatchHistory(): WatchHistoryItem[] {
  if (typeof window === 'undefined') return []

  const stored = localStorage.getItem(STORAGE_KEYS.WATCH_HISTORY)
  if (!stored) return []

  try {
    return JSON.parse(stored)
  } catch {
    return []
  }
}

export function addToWatchHistory(item: Omit<WatchHistoryItem, 'watchedAt'>): void {
  if (typeof window === 'undefined') return

  const history = getWatchHistory()
  const newItem: WatchHistoryItem = {
    ...item,
    watchedAt: new Date().toISOString(),
  }

  // Remove if already exists
  const filtered = history.filter((h) => h.movieId !== item.movieId)

  // Add to beginning
  const updated = [newItem, ...filtered].slice(0, 20) // Keep last 20

  localStorage.setItem(STORAGE_KEYS.WATCH_HISTORY, JSON.stringify(updated))
}

// My List (Watchlist)
export function getMyList(): number[] {
  if (typeof window === 'undefined') return []

  const stored = localStorage.getItem(STORAGE_KEYS.MY_LIST)
  if (!stored) return []

  try {
    return JSON.parse(stored)
  } catch {
    return []
  }
}

export function addToMyList(movieId: number): void {
  if (typeof window === 'undefined') return

  const list = getMyList()
  if (!list.includes(movieId)) {
    const updated = [...list, movieId]
    localStorage.setItem(STORAGE_KEYS.MY_LIST, JSON.stringify(updated))
  }
}

export function removeFromMyList(movieId: number): void {
  if (typeof window === 'undefined') return

  const list = getMyList()
  const updated = list.filter((id) => id !== movieId)
  localStorage.setItem(STORAGE_KEYS.MY_LIST, JSON.stringify(updated))
}

export function isInMyList(movieId: number): boolean {
  return getMyList().includes(movieId)
}

// Continue Watching
interface ContinueWatchingItem {
  movieId: number
  progress: number
  updatedAt: string
}

export function getContinueWatching(): ContinueWatchingItem[] {
  if (typeof window === 'undefined') return []

  const stored = localStorage.getItem(STORAGE_KEYS.CONTINUE_WATCHING)
  if (!stored) return []

  try {
    return JSON.parse(stored)
  } catch {
    return []
  }
}

export function updateWatchProgress(movieId: number, progress: number): void {
  if (typeof window === 'undefined') return

  const list = getContinueWatching()
  const existing = list.find((item) => item.movieId === movieId)

  if (existing) {
    existing.progress = progress
    existing.updatedAt = new Date().toISOString()
  } else {
    list.push({
      movieId,
      progress,
      updatedAt: new Date().toISOString(),
    })
  }

  // Sort by most recently updated
  list.sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime())

  // Keep only last 10
  const updated = list.slice(0, 10)

  localStorage.setItem(STORAGE_KEYS.CONTINUE_WATCHING, JSON.stringify(updated))
}

export function getWatchProgress(movieId: number): number {
  const list = getContinueWatching()
  const item = list.find((i) => i.movieId === movieId)
  return item?.progress || 0
}

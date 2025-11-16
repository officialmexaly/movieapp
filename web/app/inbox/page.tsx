'use client'

import { motion } from 'framer-motion'
import { Bell, Star, TrendingUp, Film } from 'lucide-react'
import { Header } from '@/components/Header'
import { BottomNav } from '@/components/BottomNav'

interface Notification {
  id: string
  type: 'new_release' | 'recommendation' | 'trending' | 'general'
  title: string
  message: string
  time: string
  read: boolean
}

const NOTIFICATIONS: Notification[] = [
  {
    id: '1',
    type: 'new_release',
    title: 'New Movie Alert',
    message: 'Dune: Part Three is now available in 4K!',
    time: '2 hours ago',
    read: false,
  },
  {
    id: '2',
    type: 'recommendation',
    title: 'Recommended for You',
    message: 'Based on your watch history, you might like "Inception"',
    time: '5 hours ago',
    read: false,
  },
  {
    id: '3',
    type: 'trending',
    title: 'Trending Now',
    message: '"The Batman" is trending this week. Watch now!',
    time: '1 day ago',
    read: true,
  },
  {
    id: '4',
    type: 'general',
    title: 'Update Available',
    message: 'A new version of D-eyeturn is available with improvements.',
    time: '2 days ago',
    read: true,
  },
  {
    id: '5',
    type: 'new_release',
    title: 'New Arrival',
    message: 'The Marvel collection has been updated with latest releases.',
    time: '3 days ago',
    read: true,
  },
]

export default function InboxPage() {
  const getIcon = (type: Notification['type']) => {
    switch (type) {
      case 'new_release':
        return <Film size={24} className="text-brand-purple" />
      case 'recommendation':
        return <Star size={24} className="text-yellow-500" />
      case 'trending':
        return <TrendingUp size={24} className="text-brand-cyan" />
      default:
        return <Bell size={24} className="text-white/70" />
    }
  }

  const unreadCount = NOTIFICATIONS.filter((n) => !n.read).length

  return (
    <div className="min-h-screen bg-bg-main">
      <Header />

      <main className="pt-24 pb-24 md:pb-8 px-4">
        <div className="container mx-auto max-w-4xl">
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
          >
            <div className="flex items-center justify-between mb-8">
              <div>
                <h1 className="text-3xl md:text-4xl font-black mb-2">Inbox</h1>
                <p className="text-white/70">
                  {unreadCount} unread {unreadCount === 1 ? 'notification' : 'notifications'}
                </p>
              </div>

              {unreadCount > 0 && (
                <button className="px-4 py-2 rounded-lg bg-white/10 hover:bg-white/20 transition-colors text-sm font-semibold">
                  Mark all as read
                </button>
              )}
            </div>

            {NOTIFICATIONS.length > 0 ? (
              <div className="space-y-3">
                {NOTIFICATIONS.map((notification, index) => (
                  <motion.div
                    key={notification.id}
                    initial={{ x: -20, opacity: 0 }}
                    animate={{ x: 0, opacity: 1 }}
                    transition={{ delay: index * 0.05 }}
                    className={`rounded-xl p-6 transition-all ${
                      notification.read
                        ? 'bg-bg-card hover:bg-bg-hover'
                        : 'bg-gradient-card-1 hover:opacity-90'
                    }`}
                  >
                    <div className="flex gap-4">
                      <div className="flex-shrink-0 w-12 h-12 rounded-full bg-bg-main flex items-center justify-center">
                        {getIcon(notification.type)}
                      </div>

                      <div className="flex-1 min-w-0">
                        <div className="flex items-start justify-between gap-4 mb-1">
                          <h3 className="font-bold text-lg">
                            {notification.title}
                          </h3>
                          {!notification.read && (
                            <span className="flex-shrink-0 w-2 h-2 rounded-full bg-brand-purple" />
                          )}
                        </div>

                        <p className="text-white/80 mb-2">
                          {notification.message}
                        </p>

                        <p className="text-sm text-white/50">
                          {notification.time}
                        </p>
                      </div>
                    </div>
                  </motion.div>
                ))}
              </div>
            ) : (
              <div className="text-center py-16">
                <div className="w-24 h-24 mx-auto mb-6 rounded-full bg-bg-card flex items-center justify-center">
                  <Bell size={48} className="text-white/30" />
                </div>
                <h2 className="text-2xl font-bold mb-2">No notifications</h2>
                <p className="text-white/70">
                  You're all caught up! Check back later for updates.
                </p>
              </div>
            )}
          </motion.div>
        </div>
      </main>

      <BottomNav />
    </div>
  )
}

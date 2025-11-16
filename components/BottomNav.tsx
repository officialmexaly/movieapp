'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Home, Search, Inbox, User } from 'lucide-react'
import { motion } from 'framer-motion'

export function BottomNav() {
  const pathname = usePathname()

  const navItems = [
    { href: '/', icon: Home, label: 'Home' },
    { href: '/search', icon: Search, label: 'Search' },
    { href: '/inbox', icon: Inbox, label: 'Inbox' },
    { href: '/profile', icon: User, label: 'Profile' },
  ]

  return (
    <motion.nav
      initial={{ y: 100, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.5 }}
      className="fixed bottom-0 left-0 right-0 z-50 md:hidden glass-effect border-t border-white/10"
    >
      <div className="flex items-center justify-around py-3">
        {navItems.map((item) => {
          const Icon = item.icon
          const isActive = pathname === item.href

          return (
            <Link
              key={item.href}
              href={item.href}
              className="flex flex-col items-center gap-1 px-4 py-2 transition-colors"
            >
              <Icon
                size={24}
                className={isActive ? 'text-brand-purple' : 'text-white/70'}
              />
              <span
                className={`text-xs font-medium ${
                  isActive ? 'text-brand-purple' : 'text-white/70'
                }`}
              >
                {item.label}
              </span>
            </Link>
          )
        })}
      </div>
    </motion.nav>
  )
}

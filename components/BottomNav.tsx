'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Home, Search, Heart, User } from 'lucide-react'
import { motion } from 'framer-motion'

export function BottomNav() {
  const pathname = usePathname()

  const navItems = [
    { href: '/', icon: Home, label: 'Home' },
    { href: '/search', icon: Search, label: 'Search' },
    { href: '/my-list', icon: Heart, label: 'My List' },
    { href: '/profile', icon: User, label: 'Profile' },
  ]

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-50 md:hidden bg-black/80 backdrop-blur-xl border-t border-white/10">
      <div className="relative flex items-center justify-around px-6 pb-safe">
        {navItems.map((item) => {
          const Icon = item.icon
          const isActive = pathname === item.href

          return (
            <Link
              key={item.href}
              href={item.href}
              className="flex flex-col items-center flex-1 relative py-3"
            >
              {/* Icon */}
              <motion.div
                whileTap={{ scale: 0.9 }}
                className="relative mb-1"
              >
                <Icon
                  size={24}
                  strokeWidth={2}
                  className={`transition-colors duration-200 ${
                    isActive
                      ? 'text-brand-purple'
                      : 'text-white/60'
                  }`}
                />
              </motion.div>

              {/* Label */}
              <span
                className={`text-[10px] font-medium transition-colors duration-200 ${
                  isActive ? 'text-white' : 'text-white/60'
                }`}
              >
                {item.label}
              </span>

              {/* Active indicator line - always present but visible only when active */}
              <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-10 h-1 overflow-hidden">
                {isActive && (
                  <motion.div
                    layoutId="activeIndicator"
                    className="w-full h-full bg-gradient-to-r from-brand-purple to-brand-blue rounded-full"
                    transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                  />
                )}
              </div>
            </Link>
          )
        })}
      </div>
    </nav>
  )
}

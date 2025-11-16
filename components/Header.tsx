'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Search, Bell, User } from 'lucide-react'
import { motion } from 'framer-motion'

export function Header() {
  const pathname = usePathname()

  return (
    <motion.header
      initial={{ y: -100, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.5, ease: 'easeOut' }}
      className="fixed top-0 left-0 right-0 z-50 pt-safe"
    >
      {/* Backdrop with gradient */}
      <div className="absolute inset-0 bg-gradient-to-b from-bg-primary via-bg-primary/98 to-bg-primary/80 backdrop-blur-2xl" />
      <div className="absolute bottom-0 left-0 right-0 h-[1px] bg-gradient-to-r from-transparent via-white/10 to-transparent" />

      <div className="relative container mx-auto px-4 py-3 md:py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2 group">
            <motion.div
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="text-xl md:text-2xl font-bold bg-gradient-to-r from-brand-purple via-brand-blue to-brand-purple bg-clip-text text-transparent"
            >
              PadreStream
            </motion.div>
          </Link>

          {/* Navigation - Desktop */}
          <nav className="hidden md:flex items-center gap-8">
            <Link
              href="/"
              className={`text-sm font-semibold transition-colors hover:text-brand-purple relative group ${
                pathname === '/' ? 'text-white' : 'text-white/60'
              }`}
            >
              Home
              {pathname === '/' && (
                <motion.div
                  layoutId="header-indicator"
                  className="absolute -bottom-1 left-0 right-0 h-0.5 bg-gradient-to-r from-brand-purple to-brand-blue rounded-full"
                  transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                />
              )}
            </Link>
            <Link
              href="/movies"
              className={`text-sm font-semibold transition-colors hover:text-brand-purple relative group ${
                pathname === '/movies' ? 'text-white' : 'text-white/60'
              }`}
            >
              Movies
              {pathname === '/movies' && (
                <motion.div
                  layoutId="header-indicator"
                  className="absolute -bottom-1 left-0 right-0 h-0.5 bg-gradient-to-r from-brand-purple to-brand-blue rounded-full"
                  transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                />
              )}
            </Link>
            <Link
              href="/my-list"
              className={`text-sm font-semibold transition-colors hover:text-brand-purple relative group ${
                pathname === '/my-list' ? 'text-white' : 'text-white/60'
              }`}
            >
              My List
              {pathname === '/my-list' && (
                <motion.div
                  layoutId="header-indicator"
                  className="absolute -bottom-1 left-0 right-0 h-0.5 bg-gradient-to-r from-brand-purple to-brand-blue rounded-full"
                  transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                />
              )}
            </Link>
          </nav>

          {/* Actions */}
          <div className="flex items-center gap-1 md:gap-2">
            <Link
              href="/search"
              className="md:hidden p-2.5 hover:bg-white/10 rounded-xl transition-all active:scale-95"
            >
              <Search size={20} className="text-white/70" />
            </Link>
            <Link
              href="/search"
              className="hidden md:block p-2 hover:bg-white/10 rounded-xl transition-all"
            >
              <Search size={20} />
            </Link>
            <button className="hidden md:block p-2 hover:bg-white/10 rounded-xl transition-all relative">
              <Bell size={20} />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-brand-purple rounded-full" />
            </button>
            <Link
              href="/profile"
              className="hidden md:block p-2 hover:bg-white/10 rounded-xl transition-all"
            >
              <User size={20} />
            </Link>
          </div>
        </div>
      </div>
    </motion.header>
  )
}

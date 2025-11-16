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
      transition={{ duration: 0.5 }}
      className="fixed top-0 left-0 right-0 z-50 glass-effect border-b border-white/10"
    >
      <div className="container mx-auto px-4 py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2">
            <div className="text-2xl font-bold text-gradient">
              D-eyeturn
            </div>
          </Link>

          {/* Navigation */}
          <nav className="hidden md:flex items-center gap-8">
            <Link
              href="/"
              className={`text-sm font-medium transition-colors hover:text-brand-purple ${
                pathname === '/' ? 'text-white' : 'text-white/70'
              }`}
            >
              Home
            </Link>
            <Link
              href="/search"
              className={`text-sm font-medium transition-colors hover:text-brand-purple ${
                pathname === '/search' ? 'text-white' : 'text-white/70'
              }`}
            >
              Search
            </Link>
            <Link
              href="/my-list"
              className={`text-sm font-medium transition-colors hover:text-brand-purple ${
                pathname === '/my-list' ? 'text-white' : 'text-white/70'
              }`}
            >
              My List
            </Link>
          </nav>

          {/* Actions */}
          <div className="flex items-center gap-4">
            <Link href="/search" className="p-2 hover:bg-white/10 rounded-full transition-colors">
              <Search size={20} />
            </Link>
            <button className="p-2 hover:bg-white/10 rounded-full transition-colors">
              <Bell size={20} />
            </button>
            <Link href="/profile" className="p-2 hover:bg-white/10 rounded-full transition-colors">
              <User size={20} />
            </Link>
          </div>
        </div>
      </div>
    </motion.header>
  )
}

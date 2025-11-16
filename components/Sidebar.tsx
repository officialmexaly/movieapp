'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Home, Search, Inbox, User, Heart, HelpCircle, CreditCard, Shield, Film } from 'lucide-react'
import { motion } from 'framer-motion'

export function Sidebar() {
  const pathname = usePathname()

  const mainNavItems = [
    { href: '/', icon: Home, label: 'Home' },
    { href: '/search', icon: Search, label: 'Search' },
    { href: '/movies', icon: Film, label: 'Movies' },
    { href: '/my-list', icon: Heart, label: 'My List' },
  ]

  const userNavItems = [
    { href: '/inbox', icon: Inbox, label: 'Inbox' },
    { href: '/profile', icon: User, label: 'Profile' },
  ]

  const settingsNavItems = [
    { href: '/subscription', icon: CreditCard, label: 'Subscription' },
    { href: '/privacy-security', icon: Shield, label: 'Privacy & Security' },
    { href: '/help', icon: HelpCircle, label: 'Help' },
  ]

  return (
    <motion.aside
      initial={{ x: -100, opacity: 0 }}
      animate={{ x: 0, opacity: 1 }}
      transition={{ duration: 0.5 }}
      className="hidden md:flex fixed left-0 top-20 bottom-0 w-64 glass-effect border-r border-white/10 flex-col z-40"
    >
      <nav className="flex-1 overflow-y-auto py-6 px-4">
        {/* Main Navigation */}
        <div className="mb-8">
          <h3 className="text-xs font-semibold text-white/50 uppercase tracking-wider mb-3 px-4">
            Browse
          </h3>
          <div className="space-y-1">
            {mainNavItems.map((item) => {
              const Icon = item.icon
              const isActive = pathname === item.href

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    isActive
                      ? 'bg-brand-purple text-white'
                      : 'text-white/70 hover:bg-white/5 hover:text-white'
                  }`}
                >
                  <Icon size={20} />
                  <span className="font-medium">{item.label}</span>
                </Link>
              )
            })}
          </div>
        </div>

        {/* User Navigation */}
        <div className="mb-8">
          <h3 className="text-xs font-semibold text-white/50 uppercase tracking-wider mb-3 px-4">
            Account
          </h3>
          <div className="space-y-1">
            {userNavItems.map((item) => {
              const Icon = item.icon
              const isActive = pathname === item.href

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    isActive
                      ? 'bg-brand-purple text-white'
                      : 'text-white/70 hover:bg-white/5 hover:text-white'
                  }`}
                >
                  <Icon size={20} />
                  <span className="font-medium">{item.label}</span>
                </Link>
              )
            })}
          </div>
        </div>

        {/* Settings Navigation */}
        <div>
          <h3 className="text-xs font-semibold text-white/50 uppercase tracking-wider mb-3 px-4">
            Settings
          </h3>
          <div className="space-y-1">
            {settingsNavItems.map((item) => {
              const Icon = item.icon
              const isActive = pathname === item.href

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    isActive
                      ? 'bg-brand-purple text-white'
                      : 'text-white/70 hover:bg-white/5 hover:text-white'
                  }`}
                >
                  <Icon size={20} />
                  <span className="font-medium">{item.label}</span>
                </Link>
              )
            })}
          </div>
        </div>
      </nav>

      {/* Sidebar Footer */}
      <div className="p-4 border-t border-white/10">
        <div className="px-4 py-3 bg-brand-purple/10 rounded-lg border border-brand-purple/20">
          <p className="text-xs font-semibold text-brand-purple mb-1">Premium Streaming</p>
          <p className="text-xs text-white/60">Unlimited movies & TV shows</p>
        </div>
      </div>
    </motion.aside>
  )
}

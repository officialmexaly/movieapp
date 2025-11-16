'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Home, Search, Inbox, User, Heart, HelpCircle, CreditCard, Shield, Film, Crown, Sparkles } from 'lucide-react'
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
      className="hidden md:flex fixed left-0 top-20 bottom-0 w-64 bg-gradient-to-b from-bg-primary/95 via-bg-primary to-bg-card/95 backdrop-blur-xl border-r border-white/10 flex-col z-40 shadow-2xl"
    >
      <nav className="flex-1 overflow-y-auto py-6 px-3 scrollbar-thin scrollbar-thumb-white/10 scrollbar-track-transparent">
        {/* Main Navigation */}
        <div className="mb-6">
          <h3 className="text-[10px] font-bold text-white/40 uppercase tracking-[0.15em] mb-3 px-3 flex items-center gap-2">
            <div className="h-px flex-1 bg-gradient-to-r from-transparent to-white/20" />
            <span>Browse</span>
            <div className="h-px flex-1 bg-gradient-to-l from-transparent to-white/20" />
          </h3>
          <div className="space-y-0.5">
            {mainNavItems.map((item) => {
              const Icon = item.icon
              const isActive = pathname === item.href

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`group flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 relative overflow-hidden ${
                    isActive
                      ? 'bg-gradient-to-r from-brand-purple to-brand-blue text-white shadow-lg shadow-brand-purple/20'
                      : 'text-white/60 hover:text-white hover:bg-white/[0.07]'
                  }`}
                >
                  {isActive && (
                    <motion.div
                      layoutId="sidebar-indicator"
                      className="absolute left-0 top-0 bottom-0 w-1 bg-white rounded-r-full"
                      transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                    />
                  )}
                  <Icon size={18} className={`${isActive ? 'scale-110' : 'group-hover:scale-105'} transition-transform`} />
                  <span className="font-semibold text-sm">{item.label}</span>
                </Link>
              )
            })}
          </div>
        </div>

        {/* Divider */}
        <div className="h-px bg-gradient-to-r from-transparent via-white/10 to-transparent my-6" />

        {/* User Navigation */}
        <div className="mb-6">
          <h3 className="text-[10px] font-bold text-white/40 uppercase tracking-[0.15em] mb-3 px-3 flex items-center gap-2">
            <div className="h-px flex-1 bg-gradient-to-r from-transparent to-white/20" />
            <span>Account</span>
            <div className="h-px flex-1 bg-gradient-to-l from-transparent to-white/20" />
          </h3>
          <div className="space-y-0.5">
            {userNavItems.map((item) => {
              const Icon = item.icon
              const isActive = pathname === item.href

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`group flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 relative overflow-hidden ${
                    isActive
                      ? 'bg-gradient-to-r from-brand-purple to-brand-blue text-white shadow-lg shadow-brand-purple/20'
                      : 'text-white/60 hover:text-white hover:bg-white/[0.07]'
                  }`}
                >
                  {isActive && (
                    <motion.div
                      layoutId="sidebar-indicator"
                      className="absolute left-0 top-0 bottom-0 w-1 bg-white rounded-r-full"
                      transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                    />
                  )}
                  <Icon size={18} className={`${isActive ? 'scale-110' : 'group-hover:scale-105'} transition-transform`} />
                  <span className="font-semibold text-sm">{item.label}</span>
                </Link>
              )
            })}
          </div>
        </div>

        {/* Divider */}
        <div className="h-px bg-gradient-to-r from-transparent via-white/10 to-transparent my-6" />

        {/* Settings Navigation */}
        <div>
          <h3 className="text-[10px] font-bold text-white/40 uppercase tracking-[0.15em] mb-3 px-3 flex items-center gap-2">
            <div className="h-px flex-1 bg-gradient-to-r from-transparent to-white/20" />
            <span>Settings</span>
            <div className="h-px flex-1 bg-gradient-to-l from-transparent to-white/20" />
          </h3>
          <div className="space-y-0.5">
            {settingsNavItems.map((item) => {
              const Icon = item.icon
              const isActive = pathname === item.href

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`group flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 relative overflow-hidden ${
                    isActive
                      ? 'bg-gradient-to-r from-brand-purple to-brand-blue text-white shadow-lg shadow-brand-purple/20'
                      : 'text-white/60 hover:text-white hover:bg-white/[0.07]'
                  }`}
                >
                  {isActive && (
                    <motion.div
                      layoutId="sidebar-indicator"
                      className="absolute left-0 top-0 bottom-0 w-1 bg-white rounded-r-full"
                      transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                    />
                  )}
                  <Icon size={18} className={`${isActive ? 'scale-110' : 'group-hover:scale-105'} transition-transform`} />
                  <span className="font-semibold text-sm">{item.label}</span>
                </Link>
              )
            })}
          </div>
        </div>
      </nav>

      {/* Premium Banner */}
      <div className="p-3 mt-auto">
        <motion.div
          whileHover={{ scale: 1.02 }}
          className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-brand-purple via-brand-blue to-brand-purple bg-size-200 bg-pos-0 hover:bg-pos-100 transition-all duration-700 p-4 shadow-xl shadow-brand-purple/30"
        >
          {/* Animated background gradient */}
          <div className="absolute inset-0 bg-gradient-to-tr from-transparent via-white/10 to-transparent opacity-0 hover:opacity-100 transition-opacity duration-500" />

          {/* Sparkle icon */}
          <div className="absolute top-2 right-2">
            <Sparkles size={16} className="text-white/40 animate-pulse" />
          </div>

          <div className="relative z-10">
            <div className="flex items-center gap-2 mb-2">
              <Crown size={18} className="text-yellow-300" />
              <p className="text-sm font-bold text-white">Premium Streaming</p>
            </div>
            <p className="text-xs text-white/80 leading-relaxed mb-3">
              Unlimited movies & TV shows in stunning 4K quality
            </p>
            <Link
              href="/subscription"
              className="block w-full text-center text-xs font-bold py-2 px-3 bg-white/20 hover:bg-white/30 rounded-lg backdrop-blur-sm transition-all duration-200 text-white"
            >
              Upgrade Now
            </Link>
          </div>
        </motion.div>
      </div>
    </motion.aside>
  )
}

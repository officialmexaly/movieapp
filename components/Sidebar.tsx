'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useState } from 'react'
import {
  Home,
  Search,
  Inbox,
  User,
  Heart,
  HelpCircle,
  CreditCard,
  Shield,
  Film,
  ChevronLeft,
  ChevronRight,
  Sparkles
} from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'

interface NavItem {
  href: string
  icon: any
  label: string
  badge?: string
}

export function Sidebar() {
  const pathname = usePathname()
  const [isCollapsed, setIsCollapsed] = useState(false)
  const [hoveredItem, setHoveredItem] = useState<string | null>(null)

  const mainNavItems: NavItem[] = [
    { href: '/', icon: Home, label: 'Home' },
    { href: '/search', icon: Search, label: 'Search' },
    { href: '/movies', icon: Film, label: 'Movies' },
    { href: '/my-list', icon: Heart, label: 'My List' },
  ]

  const userNavItems: NavItem[] = [
    { href: '/inbox', icon: Inbox, label: 'Inbox', badge: '3' },
    { href: '/profile', icon: User, label: 'Profile' },
  ]

  const settingsNavItems: NavItem[] = [
    { href: '/subscription', icon: CreditCard, label: 'Subscription' },
    { href: '/privacy-security', icon: Shield, label: 'Privacy' },
    { href: '/help', icon: HelpCircle, label: 'Help Center' },
  ]

  const NavLink = ({ item, showTooltip = false }: { item: NavItem; showTooltip?: boolean }) => {
    const Icon = item.icon
    const isActive = pathname === item.href
    const isHovered = hoveredItem === item.href

    return (
      <div className="relative">
        <Link
          href={item.href}
          onMouseEnter={() => setHoveredItem(item.href)}
          onMouseLeave={() => setHoveredItem(null)}
          className={`flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 relative group ${
            isActive
              ? 'bg-gradient-to-r from-brand-purple to-brand-blue text-white shadow-lg shadow-brand-purple/20'
              : 'text-white/70 hover:bg-white/5 hover:text-white'
          }`}
        >
          <div className={`flex-shrink-0 ${isActive ? 'scale-110' : ''} transition-transform`}>
            <Icon size={20} strokeWidth={isActive ? 2.5 : 2} />
          </div>

          <AnimatePresence>
            {!isCollapsed && (
              <motion.div
                initial={{ opacity: 0, width: 0 }}
                animate={{ opacity: 1, width: 'auto' }}
                exit={{ opacity: 0, width: 0 }}
                transition={{ duration: 0.2 }}
                className="flex items-center justify-between flex-1 overflow-hidden"
              >
                <span className={`font-medium text-sm whitespace-nowrap ${isActive ? 'font-semibold' : ''}`}>
                  {item.label}
                </span>
                {item.badge && (
                  <span className="ml-auto px-2 py-0.5 text-xs font-bold bg-brand-purple rounded-full">
                    {item.badge}
                  </span>
                )}
              </motion.div>
            )}
          </AnimatePresence>

          {/* Active Indicator */}
          {isActive && (
            <motion.div
              layoutId="activeTab"
              className="absolute left-0 top-0 bottom-0 w-1 bg-white rounded-r-full"
              transition={{ type: "spring", stiffness: 380, damping: 30 }}
            />
          )}
        </Link>

        {/* Tooltip for collapsed state */}
        {isCollapsed && isHovered && (
          <motion.div
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -10 }}
            className="absolute left-full ml-2 top-1/2 -translate-y-1/2 px-3 py-1.5 bg-bg-card border border-white/10 rounded-lg shadow-xl whitespace-nowrap z-50"
          >
            <span className="text-sm font-medium text-white">{item.label}</span>
            {item.badge && (
              <span className="ml-2 px-2 py-0.5 text-xs font-bold bg-brand-purple rounded-full">
                {item.badge}
              </span>
            )}
          </motion.div>
        )}
      </div>
    )
  }

  const SectionDivider = () => (
    <div className="my-4 border-t border-white/5" />
  )

  return (
    <>
      <motion.aside
        initial={{ x: -100, opacity: 0 }}
        animate={{
          x: 0,
          opacity: 1,
          width: isCollapsed ? '80px' : '280px'
        }}
        transition={{ duration: 0.3, ease: 'easeInOut' }}
        className="hidden md:flex fixed left-0 top-20 bottom-0 bg-gradient-to-b from-bg-card/95 to-bg-main/95 backdrop-blur-xl border-r border-white/10 flex-col z-40 shadow-2xl"
      >
        {/* Toggle Button */}
        <div className="flex items-center justify-end p-3 border-b border-white/5">
          <motion.button
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => setIsCollapsed(!isCollapsed)}
            className="p-2 hover:bg-white/5 rounded-lg transition-colors"
            aria-label={isCollapsed ? 'Expand sidebar' : 'Collapse sidebar'}
          >
            {isCollapsed ? (
              <ChevronRight size={20} className="text-white/70" />
            ) : (
              <ChevronLeft size={20} className="text-white/70" />
            )}
          </motion.button>
        </div>

        <nav className="flex-1 overflow-y-auto overflow-x-hidden py-4 px-3 scrollbar-thin">
          {/* Main Navigation */}
          <div className="mb-2">
            {!isCollapsed && (
              <motion.h3
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="text-[10px] font-bold text-white/40 uppercase tracking-widest mb-3 px-3"
              >
                Browse
              </motion.h3>
            )}
            <div className="space-y-1">
              {mainNavItems.map((item) => (
                <NavLink key={item.href} item={item} showTooltip={isCollapsed} />
              ))}
            </div>
          </div>

          <SectionDivider />

          {/* User Navigation */}
          <div className="mb-2">
            {!isCollapsed && (
              <motion.h3
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="text-[10px] font-bold text-white/40 uppercase tracking-widest mb-3 px-3"
              >
                Account
              </motion.h3>
            )}
            <div className="space-y-1">
              {userNavItems.map((item) => (
                <NavLink key={item.href} item={item} showTooltip={isCollapsed} />
              ))}
            </div>
          </div>

          <SectionDivider />

          {/* Settings Navigation */}
          <div>
            {!isCollapsed && (
              <motion.h3
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="text-[10px] font-bold text-white/40 uppercase tracking-widest mb-3 px-3"
              >
                Settings
              </motion.h3>
            )}
            <div className="space-y-1">
              {settingsNavItems.map((item) => (
                <NavLink key={item.href} item={item} showTooltip={isCollapsed} />
              ))}
            </div>
          </div>
        </nav>

        {/* Sidebar Footer */}
        <AnimatePresence>
          {!isCollapsed && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: 20 }}
              className="p-3 border-t border-white/5"
            >
              <div className="relative overflow-hidden px-4 py-3 bg-gradient-to-br from-brand-purple/20 to-brand-blue/20 rounded-xl border border-brand-purple/30 backdrop-blur-sm">
                <div className="absolute top-0 right-0 opacity-20">
                  <Sparkles size={40} className="text-brand-purple" />
                </div>
                <div className="relative">
                  <p className="text-xs font-bold text-gradient mb-1">Premium Streaming</p>
                  <p className="text-xs text-white/60">Unlimited access to all content</p>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Collapsed Footer Icon */}
        {isCollapsed && (
          <div className="p-3 border-t border-white/5 flex justify-center">
            <div className="p-2 bg-gradient-to-br from-brand-purple/20 to-brand-blue/20 rounded-lg">
              <Sparkles size={20} className="text-brand-purple" />
            </div>
          </div>
        )}
      </motion.aside>

      {/* Spacer for main content */}
      <motion.div
        animate={{ width: isCollapsed ? '80px' : '280px' }}
        transition={{ duration: 0.3, ease: 'easeInOut' }}
        className="hidden md:block flex-shrink-0"
        aria-hidden="true"
      />
    </>
  )
}

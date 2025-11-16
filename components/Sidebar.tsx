'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Home, Search, User, Heart, Film } from 'lucide-react'
import { motion } from 'framer-motion'
import { useSidebar } from '@/contexts/SidebarContext'
import { useState } from 'react'

export function Sidebar() {
  const pathname = usePathname()
  const { isCollapsed, setIsCollapsed } = useSidebar()
  const [isHovered, setIsHovered] = useState(false)

  const navItems = [
    { href: '/', icon: Home, label: 'Home' },
    { href: '/search', icon: Search, label: 'Search' },
    { href: '/movies', icon: Film, label: 'Movies' },
    { href: '/my-list', icon: Heart, label: 'My List' },
    { href: '/profile', icon: User, label: 'Profile' },
  ]

  const isExpanded = isHovered || !isCollapsed

  return (
    <motion.aside
      initial={{ x: -100, opacity: 0 }}
      animate={{
        x: 0,
        opacity: 1,
        width: isExpanded ? '240px' : '80px'
      }}
      transition={{ duration: 0.3, ease: 'easeInOut' }}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      className="hidden md:flex fixed left-0 top-20 bottom-0 flex-col z-40 group"
    >
      {/* Gradient background that blends with the page */}
      <div className="absolute inset-0 bg-gradient-to-r from-bg-main via-bg-main/95 to-transparent pointer-events-none" />

      {/* Subtle edge fade */}
      <div className="absolute inset-y-0 right-0 w-20 bg-gradient-to-l from-transparent to-bg-main/20 pointer-events-none" />

      <nav className="relative flex-1 overflow-y-auto py-6 px-3 z-10">
        <div className="space-y-2">
          {navItems.map((item) => {
            const Icon = item.icon
            const isActive = pathname === item.href

            return (
              <Link
                key={item.href}
                href={item.href}
                title={!isExpanded ? item.label : undefined}
                className={`flex items-center ${!isExpanded ? 'justify-center px-3' : 'gap-3 px-4'} py-3 rounded-xl transition-all duration-200 relative`}
              >
                {/* Active indicator container - always present */}
                <div className="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-8 overflow-hidden">
                  {isActive && (
                    <motion.div
                      layoutId="sidebar-active"
                      className="w-full h-full bg-gradient-to-b from-brand-purple to-brand-blue rounded-r-full"
                      transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                    />
                  )}
                </div>

                <Icon
                  size={24}
                  strokeWidth={2}
                  className={`transition-colors duration-200 ${
                    isActive ? 'text-brand-purple' : 'text-white/60'
                  }`}
                />

                <motion.span
                  initial={false}
                  animate={{
                    opacity: isExpanded ? 1 : 0,
                    width: isExpanded ? 'auto' : 0
                  }}
                  transition={{ duration: 0.2 }}
                  className={`font-medium text-sm whitespace-nowrap overflow-hidden transition-colors duration-200 ${
                    isActive ? 'text-white' : 'text-white/60'
                  }`}
                >
                  {item.label}
                </motion.span>
              </Link>
            )
          })}
        </div>
      </nav>
    </motion.aside>
  )
}

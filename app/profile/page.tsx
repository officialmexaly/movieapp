'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { motion } from 'framer-motion'
import {
  User,
  Mail,
  Bell,
  CreditCard,
  Shield,
  HelpCircle,
  ChevronRight,
  Moon,
  Sun,
  Play,
  Settings,
  LogOut,
} from 'lucide-react'
import { Header } from '@/components/Header'
import { BottomNav } from '@/components/BottomNav'
import { getUserPreferences, saveUserPreferences } from '@/lib/storage'

export default function ProfilePage() {
  const [preferences, setPreferences] = useState(getUserPreferences())
  const [user] = useState({
    name: 'John Doe',
    email: 'john.doe@example.com',
    avatar: null,
    subscription: 'Premium',
  })

  useEffect(() => {
    saveUserPreferences(preferences)
  }, [preferences])

  const toggleDarkMode = () => {
    setPreferences((prev) => ({ ...prev, darkMode: !prev.darkMode }))
  }

  const toggleAutoPlay = () => {
    setPreferences((prev) => ({ ...prev, autoPlay: !prev.autoPlay }))
  }

  const toggleNotifications = () => {
    setPreferences((prev) => ({ ...prev, notifications: !prev.notifications }))
  }

  const handleQualityChange = (quality: any) => {
    setPreferences((prev) => ({ ...prev, preferredQuality: quality }))
  }

  const menuItems = [
    {
      icon: CreditCard,
      label: 'Subscription',
      href: '/subscription',
      description: 'Manage your plan',
    },
    {
      icon: Shield,
      label: 'Privacy & Security',
      href: '/privacy-security',
      description: 'Manage your privacy settings',
    },
    {
      icon: HelpCircle,
      label: 'Help & Support',
      href: '/help',
      description: 'Get help and contact us',
    },
  ]

  return (
    <div className="min-h-screen bg-bg-main">
      <Header />

      <main className="pt-24 pb-24 md:pb-8 px-4">
        <div className="container mx-auto max-w-4xl">
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
          >
            <h1 className="text-3xl md:text-4xl font-black mb-8">Profile</h1>

            {/* User Info */}
            <div className="bg-bg-card rounded-xl p-6 mb-6">
              <div className="flex items-center gap-4 mb-6">
                <div className="w-20 h-20 rounded-full bg-gradient-brand flex items-center justify-center text-2xl font-bold">
                  {user.name[0]}
                </div>
                <div className="flex-1">
                  <h2 className="text-xl font-bold">{user.name}</h2>
                  <p className="text-white/70">{user.email}</p>
                  <span className="inline-block mt-2 px-3 py-1 rounded-full bg-brand-purple/20 text-brand-purple text-sm font-semibold">
                    {user.subscription} Member
                  </span>
                </div>
              </div>

              <button className="w-full py-3 rounded-lg bg-white/10 hover:bg-white/20 transition-colors font-semibold flex items-center justify-center gap-2">
                <User size={20} />
                Edit Profile
              </button>
            </div>

            {/* Settings */}
            <div className="bg-bg-card rounded-xl p-6 mb-6">
              <h3 className="text-lg font-bold mb-4">Preferences</h3>

              <div className="space-y-4">
                {/* Dark Mode */}
                <div className="flex items-center justify-between py-3">
                  <div className="flex items-center gap-3">
                    {preferences.darkMode ? (
                      <Moon size={20} className="text-brand-purple" />
                    ) : (
                      <Sun size={20} className="text-yellow-500" />
                    )}
                    <div>
                      <p className="font-semibold">Dark Mode</p>
                      <p className="text-sm text-white/70">
                        {preferences.darkMode ? 'Enabled' : 'Disabled'}
                      </p>
                    </div>
                  </div>
                  <button
                    onClick={toggleDarkMode}
                    className={`relative w-14 h-8 rounded-full transition-colors ${
                      preferences.darkMode ? 'bg-brand-purple' : 'bg-white/20'
                    }`}
                  >
                    <div
                      className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                        preferences.darkMode ? 'translate-x-7' : 'translate-x-1'
                      }`}
                    />
                  </button>
                </div>

                {/* Auto Play */}
                <div className="flex items-center justify-between py-3 border-t border-white/10">
                  <div className="flex items-center gap-3">
                    <Play size={20} className="text-brand-purple" />
                    <div>
                      <p className="font-semibold">Auto Play</p>
                      <p className="text-sm text-white/70">
                        Auto play next episode
                      </p>
                    </div>
                  </div>
                  <button
                    onClick={toggleAutoPlay}
                    className={`relative w-14 h-8 rounded-full transition-colors ${
                      preferences.autoPlay ? 'bg-brand-purple' : 'bg-white/20'
                    }`}
                  >
                    <div
                      className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                        preferences.autoPlay ? 'translate-x-7' : 'translate-x-1'
                      }`}
                    />
                  </button>
                </div>

                {/* Notifications */}
                <div className="flex items-center justify-between py-3 border-t border-white/10">
                  <div className="flex items-center gap-3">
                    <Bell size={20} className="text-brand-purple" />
                    <div>
                      <p className="font-semibold">Notifications</p>
                      <p className="text-sm text-white/70">
                        Get updates and recommendations
                      </p>
                    </div>
                  </div>
                  <button
                    onClick={toggleNotifications}
                    className={`relative w-14 h-8 rounded-full transition-colors ${
                      preferences.notifications ? 'bg-brand-purple' : 'bg-white/20'
                    }`}
                  >
                    <div
                      className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                        preferences.notifications ? 'translate-x-7' : 'translate-x-1'
                      }`}
                    />
                  </button>
                </div>

                {/* Preferred Quality */}
                <div className="py-3 border-t border-white/10">
                  <div className="flex items-center gap-3 mb-3">
                    <Settings size={20} className="text-brand-purple" />
                    <div>
                      <p className="font-semibold">Preferred Video Quality</p>
                      <p className="text-sm text-white/70">
                        Default playback quality
                      </p>
                    </div>
                  </div>
                  <select
                    value={preferences.preferredQuality}
                    onChange={(e) => handleQualityChange(e.target.value)}
                    className="w-full px-4 py-2 bg-bg-main rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-brand-purple"
                  >
                    <option value="auto">Auto</option>
                    <option value="1080p">1080p</option>
                    <option value="720p">720p</option>
                    <option value="480p">480p</option>
                    <option value="360p">360p</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Menu Items */}
            <div className="bg-bg-card rounded-xl overflow-hidden mb-6">
              {menuItems.map((item, index) => {
                const Icon = item.icon
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className={`flex items-center justify-between p-6 hover:bg-white/5 transition-colors ${
                      index > 0 ? 'border-t border-white/10' : ''
                    }`}
                  >
                    <div className="flex items-center gap-4">
                      <Icon size={24} className="text-brand-purple" />
                      <div>
                        <p className="font-semibold">{item.label}</p>
                        <p className="text-sm text-white/70">{item.description}</p>
                      </div>
                    </div>
                    <ChevronRight size={20} className="text-white/50" />
                  </Link>
                )
              })}
            </div>

            {/* Logout Button */}
            <button className="w-full py-4 rounded-xl bg-brand-netflix/20 hover:bg-brand-netflix/30 text-brand-netflix transition-colors font-semibold flex items-center justify-center gap-2">
              <LogOut size={20} />
              Sign Out
            </button>
          </motion.div>
        </div>
      </main>

      <BottomNav />
    </div>
  )
}

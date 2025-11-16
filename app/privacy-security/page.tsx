'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { motion } from 'framer-motion'
import {
  ChevronLeft,
  Shield,
  Lock,
  Eye,
  EyeOff,
  Download,
  Trash2,
  AlertTriangle,
} from 'lucide-react'
import { Header } from '@/components/Header'
import { BottomNav } from '@/components/BottomNav'

export default function PrivacySecurityPage() {
  const router = useRouter()

  // Privacy Settings
  const [dataCollection, setDataCollection] = useState(true)
  const [personalizedAds, setPersonalizedAds] = useState(true)
  const [analytics, setAnalytics] = useState(true)
  const [crashReporting, setCrashReporting] = useState(true)

  // Security Settings
  const [twoFactor, setTwoFactor] = useState(false)
  const [biometric, setBiometric] = useState(false)
  const [sessionTimeout, setSessionTimeout] = useState('30')
  const [emailAlerts, setEmailAlerts] = useState(true)

  // Data Management
  const [dataRetention, setDataRetention] = useState('1year')

  const handleExportData = () => {
    alert('Your data export has been initiated. You will receive an email when ready.')
  }

  const handleDeleteAccount = () => {
    if (
      confirm(
        'Are you sure you want to delete your account? This action cannot be undone.'
      )
    ) {
      alert('Account deletion request submitted.')
    }
  }

  return (
    <div className="min-h-screen bg-bg-main">
      <Header />

      <main className="pt-24 pb-24 md:pb-8 px-4">
        <div className="container mx-auto max-w-4xl">
          {/* Header */}
          <div className="flex items-center gap-4 mb-8">
            <button
              onClick={() => router.back()}
              className="p-2 hover:bg-white/10 rounded-full transition-colors"
            >
              <ChevronLeft size={24} />
            </button>
            <h1 className="text-3xl md:text-4xl font-black">
              Privacy & Security
            </h1>
          </div>

          {/* Privacy Settings */}
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            className="bg-bg-card rounded-xl p-6 mb-6"
          >
            <div className="flex items-center gap-3 mb-6">
              <Eye size={24} className="text-brand-purple" />
              <h2 className="text-xl font-bold">Privacy Controls</h2>
            </div>

            <div className="space-y-4">
              <div className="flex items-center justify-between py-3">
                <div>
                  <p className="font-semibold">Data Collection</p>
                  <p className="text-sm text-white/70">
                    Allow us to collect usage data
                  </p>
                </div>
                <button
                  onClick={() => setDataCollection(!dataCollection)}
                  className={`relative w-14 h-8 rounded-full transition-colors ${
                    dataCollection ? 'bg-brand-purple' : 'bg-white/20'
                  }`}
                >
                  <div
                    className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                      dataCollection ? 'translate-x-7' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>

              <div className="flex items-center justify-between py-3 border-t border-white/10">
                <div>
                  <p className="font-semibold">Personalized Ads</p>
                  <p className="text-sm text-white/70">
                    Show ads based on your interests
                  </p>
                </div>
                <button
                  onClick={() => setPersonalizedAds(!personalizedAds)}
                  className={`relative w-14 h-8 rounded-full transition-colors ${
                    personalizedAds ? 'bg-brand-purple' : 'bg-white/20'
                  }`}
                >
                  <div
                    className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                      personalizedAds ? 'translate-x-7' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>

              <div className="flex items-center justify-between py-3 border-t border-white/10">
                <div>
                  <p className="font-semibold">Analytics Tracking</p>
                  <p className="text-sm text-white/70">
                    Help improve the app with usage analytics
                  </p>
                </div>
                <button
                  onClick={() => setAnalytics(!analytics)}
                  className={`relative w-14 h-8 rounded-full transition-colors ${
                    analytics ? 'bg-brand-purple' : 'bg-white/20'
                  }`}
                >
                  <div
                    className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                      analytics ? 'translate-x-7' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>

              <div className="flex items-center justify-between py-3 border-t border-white/10">
                <div>
                  <p className="font-semibold">Crash Reporting</p>
                  <p className="text-sm text-white/70">
                    Send crash reports to help us fix bugs
                  </p>
                </div>
                <button
                  onClick={() => setCrashReporting(!crashReporting)}
                  className={`relative w-14 h-8 rounded-full transition-colors ${
                    crashReporting ? 'bg-brand-purple' : 'bg-white/20'
                  }`}
                >
                  <div
                    className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                      crashReporting ? 'translate-x-7' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>
            </div>
          </motion.div>

          {/* Security Settings */}
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.1 }}
            className="bg-bg-card rounded-xl p-6 mb-6"
          >
            <div className="flex items-center gap-3 mb-6">
              <Shield size={24} className="text-brand-purple" />
              <h2 className="text-xl font-bold">Security Settings</h2>
            </div>

            <div className="space-y-4">
              <div className="flex items-center justify-between py-3">
                <div>
                  <p className="font-semibold">Two-Factor Authentication</p>
                  <p className="text-sm text-white/70">
                    Add an extra layer of security
                  </p>
                </div>
                <button
                  onClick={() => setTwoFactor(!twoFactor)}
                  className={`relative w-14 h-8 rounded-full transition-colors ${
                    twoFactor ? 'bg-brand-purple' : 'bg-white/20'
                  }`}
                >
                  <div
                    className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                      twoFactor ? 'translate-x-7' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>

              <div className="flex items-center justify-between py-3 border-t border-white/10">
                <div>
                  <p className="font-semibold">Biometric Login</p>
                  <p className="text-sm text-white/70">
                    Use fingerprint or face ID
                  </p>
                </div>
                <button
                  onClick={() => setBiometric(!biometric)}
                  className={`relative w-14 h-8 rounded-full transition-colors ${
                    biometric ? 'bg-brand-purple' : 'bg-white/20'
                  }`}
                >
                  <div
                    className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                      biometric ? 'translate-x-7' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>

              <div className="py-3 border-t border-white/10">
                <p className="font-semibold mb-2">Session Timeout</p>
                <p className="text-sm text-white/70 mb-3">
                  Automatically log out after inactivity
                </p>
                <select
                  value={sessionTimeout}
                  onChange={(e) => setSessionTimeout(e.target.value)}
                  className="w-full px-4 py-2 bg-bg-main rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-brand-purple"
                >
                  <option value="15">15 minutes</option>
                  <option value="30">30 minutes</option>
                  <option value="60">1 hour</option>
                  <option value="never">Never</option>
                </select>
              </div>

              <div className="flex items-center justify-between py-3 border-t border-white/10">
                <div>
                  <p className="font-semibold">Security Email Alerts</p>
                  <p className="text-sm text-white/70">
                    Get notified of suspicious activity
                  </p>
                </div>
                <button
                  onClick={() => setEmailAlerts(!emailAlerts)}
                  className={`relative w-14 h-8 rounded-full transition-colors ${
                    emailAlerts ? 'bg-brand-purple' : 'bg-white/20'
                  }`}
                >
                  <div
                    className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                      emailAlerts ? 'translate-x-7' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>

              <button className="w-full py-3 rounded-lg bg-white/10 hover:bg-white/20 transition-colors font-semibold flex items-center justify-center gap-2">
                <Lock size={20} />
                Change Password
              </button>
            </div>
          </motion.div>

          {/* Data Management */}
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.2 }}
            className="bg-bg-card rounded-xl p-6 mb-6"
          >
            <div className="flex items-center gap-3 mb-6">
              <Download size={24} className="text-brand-purple" />
              <h2 className="text-xl font-bold">Data Management</h2>
            </div>

            <div className="space-y-4">
              <div className="py-3">
                <p className="font-semibold mb-2">Data Retention Period</p>
                <p className="text-sm text-white/70 mb-3">
                  How long we keep your data
                </p>
                <select
                  value={dataRetention}
                  onChange={(e) => setDataRetention(e.target.value)}
                  className="w-full px-4 py-2 bg-bg-main rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-brand-purple"
                >
                  <option value="3months">3 months</option>
                  <option value="6months">6 months</option>
                  <option value="1year">1 year</option>
                  <option value="indefinite">Indefinitely</option>
                </select>
              </div>

              <button
                onClick={handleExportData}
                className="w-full py-3 rounded-lg bg-white/10 hover:bg-white/20 transition-colors font-semibold flex items-center justify-center gap-2 border-t border-white/10 pt-4"
              >
                <Download size={20} />
                Export My Data
              </button>
            </div>
          </motion.div>

          {/* Danger Zone */}
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.3 }}
            className="bg-brand-netflix/10 border border-brand-netflix/30 rounded-xl p-6"
          >
            <div className="flex items-center gap-3 mb-6">
              <AlertTriangle size={24} className="text-brand-netflix" />
              <h2 className="text-xl font-bold text-brand-netflix">
                Danger Zone
              </h2>
            </div>

            <p className="text-white/70 mb-4">
              Once you delete your account, there is no going back. Please be
              certain.
            </p>

            <button
              onClick={handleDeleteAccount}
              className="w-full py-3 rounded-lg bg-brand-netflix hover:bg-brand-netflix/90 transition-colors font-semibold flex items-center justify-center gap-2"
            >
              <Trash2 size={20} />
              Delete My Account
            </button>
          </motion.div>
        </div>
      </main>

      <BottomNav />
    </div>
  )
}

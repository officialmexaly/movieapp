'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { motion, AnimatePresence } from 'framer-motion'
import { ChevronLeft, ChevronDown, Mail, MessageCircle, Phone } from 'lucide-react'
import { Header } from '@/components/Header'
import { BottomNav } from '@/components/BottomNav'

interface FAQ {
  question: string
  answer: string
}

interface FAQCategory {
  category: string
  faqs: FAQ[]
}

const FAQ_DATA: FAQCategory[] = [
  {
    category: 'General',
    faqs: [
      {
        question: 'What is PadreStream?',
        answer:
          'PadreStream is a premium movie streaming platform that offers thousands of movies and TV shows in HD and 4K quality. Stream your favorite content anytime, anywhere.',
      },
      {
        question: 'How do I sign up?',
        answer:
          'Click on the "Sign Up" button in the top right corner, choose your plan, and follow the registration process. You can start with a free trial before subscribing.',
      },
      {
        question: 'Can I watch offline?',
        answer:
          'Yes! Premium and Premium Plus members can download content for offline viewing. Just tap the download icon on any movie or episode.',
      },
    ],
  },
  {
    category: 'Account',
    faqs: [
      {
        question: 'How do I reset my password?',
        answer:
          'Click on "Forgot Password" on the login page. We\'ll send you a reset link to your registered email address.',
      },
      {
        question: 'How do I change my payment method?',
        answer:
          'Go to Profile > Subscription > Payment Method to update your payment information.',
      },
      {
        question: 'Can I cancel my subscription anytime?',
        answer:
          'Yes, you can cancel your subscription at any time from your account settings. You\'ll continue to have access until the end of your billing period.',
      },
    ],
  },
  {
    category: 'Streaming',
    faqs: [
      {
        question: 'What video quality do you offer?',
        answer:
          'We offer multiple quality options: 4K Ultra HD (Premium Plus), 1080p HD (Premium), and 480p (Free). Quality automatically adjusts based on your internet speed.',
      },
      {
        question: 'Why is my video buffering?',
        answer:
          'Buffering is usually caused by slow internet connection. Try lowering the video quality, closing other apps, or moving closer to your WiFi router.',
      },
      {
        question: 'Are subtitles available?',
        answer:
          'Yes! We offer subtitles in 12+ languages including English, Spanish, French, German, and more. Enable them from the player settings.',
      },
    ],
  },
  {
    category: 'Technical',
    faqs: [
      {
        question: 'Which devices are supported?',
        answer:
          'PadreStream works on web browsers, iOS and Android devices, Smart TVs, streaming devices (Roku, Fire TV, Chromecast), and gaming consoles.',
      },
      {
        question: 'The app won\'t open. What should I do?',
        answer:
          'Try force-closing and reopening the app. If that doesn\'t work, clear the app cache or reinstall the app. Make sure you\'re running the latest version.',
      },
      {
        question: 'How do I enable parental controls?',
        answer:
          'Go to Profile > Settings > Parental Controls to set up PINs and content restrictions based on age ratings.',
      },
    ],
  },
]

export default function HelpPage() {
  const router = useRouter()
  const [expandedIndex, setExpandedIndex] = useState<string | null>(null)
  const [searchQuery, setSearchQuery] = useState('')

  const toggleFAQ = (index: string) => {
    setExpandedIndex(expandedIndex === index ? null : index)
  }

  const filteredFAQs = FAQ_DATA.map((category) => ({
    ...category,
    faqs: category.faqs.filter(
      (faq) =>
        faq.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
        faq.answer.toLowerCase().includes(searchQuery.toLowerCase())
    ),
  })).filter((category) => category.faqs.length > 0)

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
            <h1 className="text-3xl md:text-4xl font-black">Help & Support</h1>
          </div>

          {/* Search */}
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            className="mb-8"
          >
            <input
              type="text"
              placeholder="Search for help..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full px-6 py-4 bg-bg-card rounded-xl text-white placeholder:text-white/50 focus:outline-none focus:ring-2 focus:ring-brand-purple"
            />
          </motion.div>

          {/* Contact Options */}
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.1 }}
            className="grid md:grid-cols-3 gap-4 mb-8"
          >
            <button className="p-6 bg-bg-card rounded-xl hover:bg-bg-hover transition-colors">
              <Mail size={32} className="text-brand-purple mb-3 mx-auto" />
              <p className="font-semibold">Email Support</p>
              <p className="text-sm text-white/70 mt-1">
                support@padrestream.com
              </p>
            </button>

            <button className="p-6 bg-bg-card rounded-xl hover:bg-bg-hover transition-colors">
              <MessageCircle
                size={32}
                className="text-brand-purple mb-3 mx-auto"
              />
              <p className="font-semibold">Live Chat</p>
              <p className="text-sm text-white/70 mt-1">24/7 available</p>
            </button>

            <button className="p-6 bg-bg-card rounded-xl hover:bg-bg-hover transition-colors">
              <Phone size={32} className="text-brand-purple mb-3 mx-auto" />
              <p className="font-semibold">Phone Support</p>
              <p className="text-sm text-white/70 mt-1">1-800-PADRE-STREAM</p>
            </button>
          </motion.div>

          {/* FAQs */}
          <h2 className="text-2xl font-bold mb-6">
            Frequently Asked Questions
          </h2>

          {filteredFAQs.length > 0 ? (
            <div className="space-y-6">
              {filteredFAQs.map((category, catIndex) => (
                <motion.div
                  key={category.category}
                  initial={{ y: 20, opacity: 0 }}
                  animate={{ y: 0, opacity: 1 }}
                  transition={{ delay: catIndex * 0.1 }}
                >
                  <h3 className="text-xl font-bold mb-4 text-brand-purple">
                    {category.category}
                  </h3>

                  <div className="space-y-3">
                    {category.faqs.map((faq, faqIndex) => {
                      const key = `${catIndex}-${faqIndex}`
                      const isExpanded = expandedIndex === key

                      return (
                        <div
                          key={key}
                          className="bg-bg-card rounded-xl overflow-hidden"
                        >
                          <button
                            onClick={() => toggleFAQ(key)}
                            className="w-full p-6 flex items-center justify-between hover:bg-bg-hover transition-colors text-left"
                          >
                            <span className="font-semibold pr-4">
                              {faq.question}
                            </span>
                            <ChevronDown
                              size={20}
                              className={`flex-shrink-0 transition-transform ${
                                isExpanded ? 'rotate-180' : ''
                              }`}
                            />
                          </button>

                          <AnimatePresence>
                            {isExpanded && (
                              <motion.div
                                initial={{ height: 0, opacity: 0 }}
                                animate={{ height: 'auto', opacity: 1 }}
                                exit={{ height: 0, opacity: 0 }}
                                transition={{ duration: 0.2 }}
                                className="overflow-hidden"
                              >
                                <div className="px-6 pb-6 text-white/80">
                                  {faq.answer}
                                </div>
                              </motion.div>
                            )}
                          </AnimatePresence>
                        </div>
                      )
                    })}
                  </div>
                </motion.div>
              ))}
            </div>
          ) : (
            <div className="text-center py-12">
              <p className="text-white/70">
                No results found for "{searchQuery}". Try different keywords or
                contact our support team.
              </p>
            </div>
          )}
        </div>
      </main>

      <BottomNav />
    </div>
  )
}

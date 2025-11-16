'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { motion } from 'framer-motion'
import { Check, ChevronLeft, Star } from 'lucide-react'
import { Header } from '@/components/Header'
import { BottomNav } from '@/components/BottomNav'

interface Plan {
  id: string
  name: string
  price: number
  period: string
  features: string[]
  popular?: boolean
}

const PLANS: Plan[] = [
  {
    id: 'free',
    name: 'Free',
    price: 0,
    period: 'month',
    features: [
      'Limited content library',
      '480p quality',
      'Ads included',
      '1 device',
      'No downloads',
    ],
  },
  {
    id: 'premium',
    name: 'Premium',
    price: 9.99,
    period: 'month',
    popular: true,
    features: [
      'Full content library',
      '1080p HD quality',
      'Ad-free experience',
      '2 devices',
      'Unlimited downloads',
      'Early access to new releases',
    ],
  },
  {
    id: 'premium_plus',
    name: 'Premium Plus',
    price: 14.99,
    period: 'month',
    features: [
      'Full content library',
      '4K Ultra HD quality',
      'Ad-free experience',
      '4 devices',
      'Unlimited downloads',
      'Early access to new releases',
      'Exclusive content',
      'Offline viewing',
    ],
  },
]

export default function SubscriptionPage() {
  const router = useRouter()
  const [currentPlan] = useState('premium')
  const [selectedPlan, setSelectedPlan] = useState('premium')

  const handleUpgrade = (planId: string) => {
    setSelectedPlan(planId)
    // In a real app, this would handle payment
    console.log('Upgrading to:', planId)
  }

  return (
    <div className="min-h-screen bg-bg-main">
      <Header />

      <main className="pt-24 pb-24 md:pb-8 px-4">
        <div className="container mx-auto max-w-6xl">
          {/* Header */}
          <div className="flex items-center gap-4 mb-8">
            <button
              onClick={() => router.back()}
              className="p-2 hover:bg-white/10 rounded-full transition-colors"
            >
              <ChevronLeft size={24} />
            </button>
            <h1 className="text-3xl md:text-4xl font-black">Subscription</h1>
          </div>

          {/* Current Plan */}
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            className="bg-gradient-card-1 rounded-xl p-6 mb-8"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-white/70 mb-1">Current Plan</p>
                <h2 className="text-2xl font-bold">
                  {PLANS.find((p) => p.id === currentPlan)?.name}
                </h2>
              </div>
              <div className="text-right">
                <p className="text-3xl font-black">
                  ${PLANS.find((p) => p.id === currentPlan)?.price}
                </p>
                <p className="text-white/70">/month</p>
              </div>
            </div>
            <p className="text-white/70 mt-4">
              Next billing date: December 16, 2025
            </p>
          </motion.div>

          {/* Plans */}
          <h2 className="text-2xl font-bold mb-6">Choose Your Plan</h2>

          <div className="grid md:grid-cols-3 gap-6 mb-8">
            {PLANS.map((plan, index) => (
              <motion.div
                key={plan.id}
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: index * 0.1 }}
                className={`relative rounded-xl p-6 transition-all ${
                  plan.popular
                    ? 'bg-gradient-card-1 border-2 border-brand-purple'
                    : 'bg-bg-card'
                } ${
                  selectedPlan === plan.id
                    ? 'ring-2 ring-brand-purple'
                    : 'hover:bg-bg-hover'
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 -translate-x-1/2 px-4 py-1 rounded-full bg-gradient-brand text-xs font-bold flex items-center gap-1">
                    <Star size={12} fill="white" />
                    MOST POPULAR
                  </div>
                )}

                <h3 className="text-2xl font-bold mb-2">{plan.name}</h3>

                <div className="mb-6">
                  <span className="text-4xl font-black">${plan.price}</span>
                  <span className="text-white/70">/{plan.period}</span>
                </div>

                <ul className="space-y-3 mb-6">
                  {plan.features.map((feature, i) => (
                    <li key={i} className="flex items-start gap-2">
                      <Check
                        size={20}
                        className="text-brand-purple flex-shrink-0 mt-0.5"
                      />
                      <span className="text-sm text-white/90">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button
                  onClick={() => handleUpgrade(plan.id)}
                  disabled={currentPlan === plan.id}
                  className={`w-full py-3 rounded-lg font-semibold transition-all ${
                    currentPlan === plan.id
                      ? 'bg-white/10 text-white/50 cursor-not-allowed'
                      : plan.popular
                      ? 'bg-gradient-brand hover:opacity-90'
                      : 'bg-white/10 hover:bg-white/20'
                  }`}
                >
                  {currentPlan === plan.id ? 'Current Plan' : 'Select Plan'}
                </button>
              </motion.div>
            ))}
          </div>

          {/* Billing History */}
          <div className="bg-bg-card rounded-xl p-6">
            <h3 className="text-xl font-bold mb-4">Billing History</h3>

            <div className="space-y-3">
              {[
                {
                  date: 'Nov 16, 2025',
                  amount: 9.99,
                  status: 'Paid',
                  plan: 'Premium',
                },
                {
                  date: 'Oct 16, 2025',
                  amount: 9.99,
                  status: 'Paid',
                  plan: 'Premium',
                },
                {
                  date: 'Sep 16, 2025',
                  amount: 9.99,
                  status: 'Paid',
                  plan: 'Premium',
                },
              ].map((item, index) => (
                <div
                  key={index}
                  className="flex items-center justify-between py-3 border-t border-white/10"
                >
                  <div>
                    <p className="font-semibold">{item.plan} Plan</p>
                    <p className="text-sm text-white/70">{item.date}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-semibold">${item.amount.toFixed(2)}</p>
                    <span className="text-xs px-2 py-1 rounded-full bg-green-500/20 text-green-500">
                      {item.status}
                    </span>
                  </div>
                </div>
              ))}
            </div>

            <button className="w-full mt-4 py-3 rounded-lg bg-white/10 hover:bg-white/20 transition-colors font-semibold">
              View All Transactions
            </button>
          </div>
        </div>
      </main>

      <BottomNav />
    </div>
  )
}

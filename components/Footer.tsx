'use client'

import Link from 'next/link'
import { motion } from 'framer-motion'
import { Facebook, Twitter, Instagram, Youtube, Mail, ArrowUpRight } from 'lucide-react'

export function Footer() {
  const footerLinks = {
    company: [
      { label: 'About Us', href: '/about' },
      { label: 'Careers', href: '/careers' },
      { label: 'Press', href: '/press' },
    ],
    support: [
      { label: 'Help Center', href: '/help' },
      { label: 'Contact Us', href: '/contact' },
      { label: 'FAQ', href: '/faq' },
    ],
    legal: [
      { label: 'Terms of Service', href: '/terms' },
      { label: 'Privacy Policy', href: '/privacy' },
      { label: 'Cookie Policy', href: '/cookies' },
    ],
    account: [
      { label: 'My Account', href: '/profile' },
      { label: 'Subscription', href: '/subscription' },
      { label: 'Privacy & Security', href: '/privacy-security' },
    ],
  }

  const socialLinks = [
    { icon: Facebook, href: '#', label: 'Facebook', color: 'hover:bg-blue-600' },
    { icon: Twitter, href: '#', label: 'Twitter', color: 'hover:bg-sky-500' },
    { icon: Instagram, href: '#', label: 'Instagram', color: 'hover:bg-gradient-to-br hover:from-purple-600 hover:to-pink-600' },
    { icon: Youtube, href: '#', label: 'YouTube', color: 'hover:bg-red-600' },
    { icon: Mail, href: '#', label: 'Email', color: 'hover:bg-brand-purple' },
  ]

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1
      }
    }
  }

  const itemVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration: 0.5 }
    }
  }

  return (
    <footer className="relative bg-gradient-to-b from-bg-card to-bg-primary border-t border-white/10 mt-20 mb-16 md:mb-0 overflow-hidden">
      {/* Decorative background elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-brand-purple/10 rounded-full blur-3xl" />
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-brand-blue/10 rounded-full blur-3xl" />
      </div>

      <div className="relative container mx-auto px-4 py-16">
        {/* Top section with logo and social */}
        <motion.div
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          variants={containerVariants}
          className="flex flex-col md:flex-row justify-between items-start md:items-center gap-8 mb-12 pb-12 border-b border-white/10"
        >
          <motion.div variants={itemVariants}>
            <Link href="/" className="inline-block group">
              <h2 className="text-3xl md:text-4xl font-bold text-gradient mb-2 group-hover:scale-105 transition-transform">
                PadreStream
              </h2>
              <p className="text-sm text-white/50">Your premium streaming destination</p>
            </Link>
          </motion.div>

          <motion.div variants={itemVariants} className="flex items-center gap-3">
            {socialLinks.map((social, index) => {
              const Icon = social.icon
              return (
                <motion.a
                  key={social.label}
                  href={social.href}
                  aria-label={social.label}
                  whileHover={{ scale: 1.1, y: -3 }}
                  whileTap={{ scale: 0.95 }}
                  className={`p-3 bg-white/5 backdrop-blur-sm rounded-xl transition-all duration-300 border border-white/10 hover:border-white/20 ${social.color} hover:shadow-lg group`}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: index * 0.1 }}
                >
                  <Icon size={20} className="text-white/70 group-hover:text-white transition-colors" />
                </motion.a>
              )
            })}
          </motion.div>
        </motion.div>

        {/* Main Footer Content */}
        <motion.div
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          variants={containerVariants}
          className="grid grid-cols-2 md:grid-cols-4 gap-8 md:gap-12 mb-12"
        >
          {/* Company */}
          <motion.div variants={itemVariants}>
            <h4 className="text-sm font-bold text-white mb-5 flex items-center gap-2">
              <div className="h-px w-8 bg-gradient-to-r from-brand-purple to-transparent" />
              Company
            </h4>
            <ul className="space-y-3">
              {footerLinks.company.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 hover:text-brand-purple transition-colors inline-flex items-center gap-1 group"
                  >
                    <span>{link.label}</span>
                    <ArrowUpRight size={14} className="opacity-0 group-hover:opacity-100 transition-opacity -translate-y-0.5" />
                  </Link>
                </li>
              ))}
            </ul>
          </motion.div>

          {/* Support */}
          <motion.div variants={itemVariants}>
            <h4 className="text-sm font-bold text-white mb-5 flex items-center gap-2">
              <div className="h-px w-8 bg-gradient-to-r from-brand-purple to-transparent" />
              Support
            </h4>
            <ul className="space-y-3">
              {footerLinks.support.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 hover:text-brand-purple transition-colors inline-flex items-center gap-1 group"
                  >
                    <span>{link.label}</span>
                    <ArrowUpRight size={14} className="opacity-0 group-hover:opacity-100 transition-opacity -translate-y-0.5" />
                  </Link>
                </li>
              ))}
            </ul>
          </motion.div>

          {/* Legal */}
          <motion.div variants={itemVariants}>
            <h4 className="text-sm font-bold text-white mb-5 flex items-center gap-2">
              <div className="h-px w-8 bg-gradient-to-r from-brand-purple to-transparent" />
              Legal
            </h4>
            <ul className="space-y-3">
              {footerLinks.legal.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 hover:text-brand-purple transition-colors inline-flex items-center gap-1 group"
                  >
                    <span>{link.label}</span>
                    <ArrowUpRight size={14} className="opacity-0 group-hover:opacity-100 transition-opacity -translate-y-0.5" />
                  </Link>
                </li>
              ))}
            </ul>
          </motion.div>

          {/* Account */}
          <motion.div variants={itemVariants}>
            <h4 className="text-sm font-bold text-white mb-5 flex items-center gap-2">
              <div className="h-px w-8 bg-gradient-to-r from-brand-purple to-transparent" />
              Account
            </h4>
            <ul className="space-y-3">
              {footerLinks.account.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 hover:text-brand-purple transition-colors inline-flex items-center gap-1 group"
                  >
                    <span>{link.label}</span>
                    <ArrowUpRight size={14} className="opacity-0 group-hover:opacity-100 transition-opacity -translate-y-0.5" />
                  </Link>
                </li>
              ))}
            </ul>
          </motion.div>
        </motion.div>

        {/* Bottom Section */}
        <motion.div
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          transition={{ delay: 0.3 }}
          className="pt-8 border-t border-white/10"
        >
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <div className="text-sm text-white/50 text-center md:text-left">
              <p>&copy; {new Date().getFullYear()} PadreStream. All rights reserved.</p>
              <p className="mt-1">Enjoy unlimited entertainment in stunning quality</p>
            </div>

            <div className="flex items-center gap-4 text-xs text-white/40">
              <span className="px-3 py-1.5 bg-white/5 rounded-full border border-white/10">
                4K Ultra HD
              </span>
              <span className="px-3 py-1.5 bg-white/5 rounded-full border border-white/10">
                Dolby Atmos
              </span>
              <span className="px-3 py-1.5 bg-white/5 rounded-full border border-white/10">
                HDR10+
              </span>
            </div>
          </div>
        </motion.div>
      </div>
    </footer>
  )
}

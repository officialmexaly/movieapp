'use client'

import Link from 'next/link'
import { motion } from 'framer-motion'
import { Facebook, Twitter, Instagram, Youtube, Mail } from 'lucide-react'

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
    { icon: Facebook, href: '#', label: 'Facebook' },
    { icon: Twitter, href: '#', label: 'Twitter' },
    { icon: Instagram, href: '#', label: 'Instagram' },
    { icon: Youtube, href: '#', label: 'YouTube' },
    { icon: Mail, href: '#', label: 'Email' },
  ]

  return (
    <motion.footer
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.5 }}
      className="bg-bg-card border-t border-white/10 mt-12 mb-16 md:mb-0"
    >
      <div className="container mx-auto px-4 py-12">
        {/* Main Footer Content */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 mb-8">
          {/* Company */}
          <div>
            <h4 className="text-sm font-semibold text-white mb-4">Company</h4>
            <ul className="space-y-2">
              {footerLinks.company.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 hover:text-brand-purple transition-colors"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Support */}
          <div>
            <h4 className="text-sm font-semibold text-white mb-4">Support</h4>
            <ul className="space-y-2">
              {footerLinks.support.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 hover:text-brand-purple transition-colors"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Legal */}
          <div>
            <h4 className="text-sm font-semibold text-white mb-4">Legal</h4>
            <ul className="space-y-2">
              {footerLinks.legal.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 hover:text-brand-purple transition-colors"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Account */}
          <div>
            <h4 className="text-sm font-semibold text-white mb-4">Account</h4>
            <ul className="space-y-2">
              {footerLinks.account.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 hover:text-brand-purple transition-colors"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* Social Links */}
        <div className="flex justify-center gap-4 mb-8 pb-8 border-b border-white/10">
          {socialLinks.map((social) => {
            const Icon = social.icon
            return (
              <a
                key={social.label}
                href={social.href}
                aria-label={social.label}
                className="p-3 bg-white/5 hover:bg-brand-purple hover:scale-110 rounded-full transition-all"
              >
                <Icon size={18} />
              </a>
            )
          })}
        </div>

        {/* Bottom Section */}
        <div className="flex flex-col md:flex-row justify-between items-center gap-4">
          <div className="text-2xl font-bold text-gradient">
            PadreStream
          </div>

          <div className="text-sm text-white/50 text-center md:text-right">
            <p>&copy; {new Date().getFullYear()} PadreStream. All rights reserved.</p>
            <p className="mt-1">Premium movie streaming platform</p>
          </div>
        </div>
      </div>
    </motion.footer>
  )
}

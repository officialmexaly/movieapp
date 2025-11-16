import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          purple: '#6C5CE7',
          blue: '#74B9FF',
          cyan: '#00CEC9',
          netflix: '#E50914',
        },
        bg: {
          main: '#0D0D0D',
          card: '#1A1A1A',
          hover: '#2A2A2A',
        },
      },
      fontFamily: {
        sans: ['-apple-system', 'BlinkMacSystemFont', 'SF Pro Display', 'Segoe UI', 'Roboto', 'sans-serif'],
      },
      backgroundImage: {
        'gradient-brand': 'linear-gradient(135deg, #6C5CE7 0%, #74B9FF 50%, #00CEC9 100%)',
        'gradient-card-1': 'linear-gradient(135deg, #667eea 0%, #764ba2 33%, #6C5CE7 66%, #74B9FF 100%)',
        'gradient-card-2': 'linear-gradient(135deg, #2c1810 0%, #8B0000 50%, #000000 100%)',
        'gradient-card-3': 'linear-gradient(135deg, #2C2C54 0%, #40407A 50%, #706FD3 100%)',
      },
      animation: {
        'fade-in': 'fadeIn 1s ease-out',
        'slide-up': 'slideUp 0.8s ease-out',
        'pulse-glow': 'pulseGlow 2s ease-in-out infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        pulseGlow: {
          '0%, 100%': { boxShadow: '0 0 20px rgba(108, 92, 231, 0.5)' },
          '50%': { boxShadow: '0 0 40px rgba(116, 185, 255, 0.8)' },
        },
      },
    },
  },
  plugins: [],
}
export default config

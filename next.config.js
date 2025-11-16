/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'image.tmdb.org',
        pathname: '/t/p/**',
      },
    ],
    formats: ['image/avif', 'image/webp'],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
    minimumCacheTTL: 60 * 60 * 24 * 7, // Cache images for 7 days
    dangerouslyAllowSVG: true,
    contentDispositionType: 'inline',
    unoptimized: false,
  },
  // Enable compression
  compress: true,
  // Experimental features for better performance
  experimental: {
    optimizePackageImports: ['lucide-react', 'framer-motion'],
    // Enable React Server Components caching
    serverActions: {
      bodySizeLimit: '2mb',
    },
    // Staletime for static pages (ISR)
    staleTimes: {
      dynamic: 30,
      static: 180,
    },
  },
  // Caching configuration for Next.js 16
  cacheLife: {
    default: {
      // Default caching for most pages
      stale: 60 * 5, // 5 minutes
      revalidate: 60 * 30, // 30 minutes
      expire: 60 * 60 * 24, // 1 day
    },
    movies: {
      // Longer caching for movie data
      stale: 60 * 30, // 30 minutes
      revalidate: 60 * 60 * 2, // 2 hours
      expire: 60 * 60 * 24 * 7, // 7 days
    },
  },
  // Enable static optimization
  generateBuildId: async () => {
    return 'padrestream-build-' + Date.now()
  },
}

module.exports = nextConfig

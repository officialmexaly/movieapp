# D-eyeturn Web - Next.js Application

A modern, responsive movie streaming web application built with Next.js 14, featuring a sleek dark theme with purple/blue gradients.

## Features

### 🎬 Core Features
- **Browse Movies**: Explore thousands of movies across multiple categories
- **Featured Carousel**: Auto-rotating featured movies with smooth animations
- **Advanced Search**: Search with filters for genres, release year, ratings, and more
- **Movie Details**: View comprehensive information including cast, reviews, and trailers
- **Video Player**: Custom video player with quality selection and subtitle support
- **My List**: Save movies to watch later
- **Watch History**: Continue watching from where you left off

### 📱 Pages
- **Home**: Featured carousel + 15+ movie categories
- **Search**: Advanced search with filters
- **Movie Detail**: Full movie info with cast, reviews, trailers
- **Video Player**: Custom player with controls
- **Profile**: User preferences and settings
- **My List**: Saved movies collection
- **Subscription**: Plan management
- **Privacy & Security**: Privacy and security settings
- **Help & Support**: FAQs and contact options
- **Inbox**: Notifications

### 🛠 Tech Stack
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Animations**: Framer Motion
- **Data Fetching**: TanStack Query
- **State Management**: Zustand
- **Video Player**: React Player
- **API**: The Movie Database (TMDB)

## Getting Started

### Prerequisites
- Node.js 18+
- npm or yarn

### Installation

1. Navigate to the web directory:
```bash
cd web
```

2. Install dependencies:
```bash
npm install
```

3. Set up TMDB API credentials:
   - Go to [https://www.themoviedb.org/signup](https://www.themoviedb.org/signup) to create a free account
   - Navigate to [https://www.themoviedb.org/settings/api](https://www.themoviedb.org/settings/api)
   - Request an API key (choose "Developer" option)
   - Copy your credentials to `.env.local`:
     ```bash
     cp .env.example .env.local
     ```
   - Edit `.env.local` and add your credentials:
     - `NEXT_PUBLIC_TMDB_ACCESS_TOKEN` - Your API Read Access Token (v4 Bearer Token)
     - `NEXT_PUBLIC_TMDB_API_KEY` - Your API Key (v3 auth)

4. Run the development server:
```bash
npm run dev
```

5. Open [http://localhost:3000](http://localhost:3000) in your browser

### Build for Production
```bash
npm run build
npm start
```

## Environment Variables

This application requires TMDB API credentials to fetch movie data. See the Installation section above for setup instructions.

**Required variables:**
- `NEXT_PUBLIC_TMDB_ACCESS_TOKEN` - TMDB API Read Access Token
- `NEXT_PUBLIC_TMDB_API_KEY` - TMDB API Key (v3)

## Project Structure

```
web/
├── app/                    # Next.js app directory
│   ├── page.tsx           # Home page
│   ├── search/            # Search page
│   ├── movies/[id]/       # Movie details
│   └── my-list/           # User's saved movies
├── components/            # React components
│   ├── MovieCard.tsx
│   ├── CategorySection.tsx
│   └── ...
├── services/              # API services
│   └── tmdb.ts           # TMDB API client
├── types/                 # TypeScript type definitions
│   └── movie.ts
├── lib/                   # Utility functions
└── public/                # Static assets
```

## License

This project is for educational purposes only. Movie data and images are provided by TMDB.

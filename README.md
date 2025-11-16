# D-eyeturn - Multi-Platform Movie Streaming Application

A modern movie streaming platform available on both mobile and web, featuring a sleek dark theme with purple/blue gradients. Built with Flutter for mobile and Next.js for web, powered by The Movie Database (TMDB) API.

## 🎯 Project Overview

This is a **monorepo** containing two separate applications:

### 📱 Mobile App (Flutter)
Cross-platform mobile application supporting iOS, Android, Web, Linux, macOS, and Windows.

**[→ View Mobile README](./mobile/README.md)**

### 🌐 Web App (Next.js)
Modern, responsive web application built with Next.js 14 and React.

**[→ View Web README](./web/README.md)**

## 🚀 Quick Start

### Mobile App
```bash
cd mobile
flutter pub get
flutter run
```

### Web App
```bash
cd web
npm install
npm run dev
```

## 📁 Repository Structure

```
movieapp/
├── mobile/              # Flutter mobile application
│   ├── lib/            # Dart source code
│   ├── android/        # Android platform code
│   ├── ios/            # iOS platform code
│   ├── web/            # Flutter web
│   ├── linux/          # Linux platform code
│   ├── macos/          # macOS platform code
│   ├── windows/        # Windows platform code
│   ├── test/           # Unit and widget tests
│   └── pubspec.yaml    # Flutter dependencies
│
├── web/                # Next.js web application
│   ├── app/            # Next.js app router pages
│   ├── components/     # React components
│   ├── services/       # API services
│   ├── types/          # TypeScript types
│   └── package.json    # Node dependencies
│
├── docs/               # Project documentation
│   ├── DESIGN_SYSTEM.md
│   ├── WEB_IMPLEMENTATION_GUIDE.md
│   └── ... more documentation
│
├── .github/            # GitHub Actions and workflows
└── README.md           # This file
```

## ✨ Features

Both platforms share core features:

- **Browse Movies** - Explore thousands of movies across multiple categories
- **Featured Content** - Auto-rotating featured movies with smooth animations
- **Advanced Search** - Filter by genre, year, rating, and more
- **Movie Details** - Comprehensive info including cast, reviews, and trailers
- **Video Player** - Custom player with quality selection
- **My List** - Save movies to watch later
- **Watch History** - Continue watching from where you left off

## 🛠 Tech Stack

### Mobile (Flutter)
- Flutter 3.x
- Dart
- Platform: iOS, Android, Web, Desktop
- API: TMDB

### Web (Next.js)
- Next.js 14 (App Router)
- TypeScript
- Tailwind CSS
- TanStack Query
- Framer Motion
- API: TMDB

## 🔑 API Configuration

Both applications use The Movie Database (TMDB) API:

1. Create a free account at [TMDB](https://www.themoviedb.org/signup)
2. Get your API credentials from [TMDB API Settings](https://www.themoviedb.org/settings/api)
3. Configure each app:
   - **Mobile**: Credentials are in the Flutter service files
   - **Web**: Add credentials to `web/.env.local` (see web/README.md)

## 📖 Documentation

Detailed documentation is available in the `/docs` directory:

- [Design System](./docs/DESIGN_SYSTEM.md)
- [Web Implementation Guide](./docs/WEB_IMPLEMENTATION_GUIDE.md)
- [Production Readiness](./docs/PRODUCTION_READINESS.md)
- [Design Summary](./docs/DESIGN_SUMMARY.md)

## 🎨 Design

The application features a consistent dark theme with purple/blue gradients across both platforms, ensuring a cohesive user experience whether on mobile or web.

## 📝 Development

### Mobile Development
```bash
cd mobile

# Run on specific platform
flutter run -d ios
flutter run -d android
flutter run -d chrome
flutter run -d macos

# Build for production
flutter build apk --release
flutter build ios --release
```

### Web Development
```bash
cd web

# Development
npm run dev        # Start dev server on http://localhost:3000

# Production
npm run build      # Build for production
npm start          # Start production server
```

## 🧪 Testing

### Mobile Tests
```bash
cd mobile
flutter test
```

### Web Tests
```bash
cd web
npm test
```

## 🤝 Contributing

When contributing to this project:

1. **Mobile changes**: Work in the `/mobile` directory
2. **Web changes**: Work in the `/web` directory
3. **Documentation**: Update relevant README files
4. **Shared design**: Maintain consistency across platforms

## 📄 License

This project is for educational purposes only. Movie data and images are provided by The Movie Database (TMDB).

---

## Platform-Specific Documentation

- **[Mobile App Documentation](./mobile/README.md)** - Flutter setup, platform guides, and mobile-specific features
- **[Web App Documentation](./web/README.md)** - Next.js setup, deployment, and web-specific features

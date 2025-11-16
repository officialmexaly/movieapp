# Web Version Implementation Guide - CSS/Tailwind Equivalents

This guide provides CSS and Tailwind CSS equivalents for replicating the PadreStream Flutter design in a web application.

---

## CSS COLOR VARIABLES

```css
:root {
  /* Brand Colors */
  --primary-purple: #6C5CE7;
  --primary-blue: #74B9FF;
  --primary-cyan: #00CEC9;
  
  /* Background Colors */
  --bg-dark: #0D0D0D;
  --bg-card: #1A1A1A;
  --bg-dark-rgb: 13, 13, 13;
  
  /* Accent Colors */
  --netflix-red: #E50914;
  --accent-amber: #FFC107;
  --text-secondary: rgba(255, 255, 255, 0.7);
  --text-tertiary: rgba(255, 255, 255, 0.5);
}
```

---

## GRADIENT DEFINITIONS (CSS)

### FluxShorts Brand Gradient
```css
.gradient-brand {
  background: linear-gradient(
    135deg,
    #6C5CE7 0%,
    #74B9FF 50%,
    #00CEC9 100%
  );
}

/* For text with gradient (using background-clip) */
.gradient-brand-text {
  background: linear-gradient(
    135deg,
    #6C5CE7 0%,
    #74B9FF 50%,
    #00CEC9 100%
  );
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}
```

### Card Gradient 1 (Purple-Blue)
```css
.gradient-card-1 {
  background: linear-gradient(
    135deg,
    #667eea 0%,
    #764ba2 30%,
    #6C5CE7 70%,
    #74B9FF 100%
  );
}
```

### Card Gradient 2 (Dark Brown-Red)
```css
.gradient-card-2 {
  background: linear-gradient(
    180deg,
    #2c1810 0%,
    #8B0000 50%,
    #000000 100%
  );
}
```

### Card Gradient 3 (Dark Purple)
```css
.gradient-card-3 {
  background: linear-gradient(
    180deg,
    #2C2C54 0%,
    #40407A 50%,
    #706FD3 100%
  );
}
```

### Dark Overlay Gradient
```css
.gradient-overlay-dark {
  background: linear-gradient(
    180deg,
    rgba(0, 0, 0, 0) 0%,
    rgba(0, 0, 0, 0.13) 30%,
    rgba(0, 0, 0, 0.4) 60%,
    rgba(0, 0, 0, 0.87) 100%
  );
}
```

### Radial Glow Gradient
```css
.gradient-glow-cyan {
  background: radial-gradient(
    circle,
    rgba(0, 206, 201, 0.3) 0%,
    rgba(116, 185, 255, 0.2) 40%,
    transparent 100%
  );
}
```

---

## TYPOGRAPHY

### CSS Font Definitions
```css
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700;800;900&display=swap');

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Poppins', sans-serif;
  color: #FFFFFF;
  background-color: #0D0D0D;
}

/* Headline Large */
.headline-large {
  font-size: 34px;
  font-weight: 800;
  letter-spacing: -1px;
  line-height: 1.1;
}

/* Title Large */
.title-large {
  font-size: 20px;
  font-weight: 700;
  letter-spacing: -0.4px;
}

/* Body Medium */
.body-medium {
  font-size: 15px;
  font-weight: 500;
  letter-spacing: 0.1px;
}

/* Movie Title Large */
.movie-title-hero {
  font-size: 40px;
  font-weight: 900;
  letter-spacing: -1px;
  text-shadow: 0 4px 12px rgba(0, 0, 0, 0.87);
}

/* Movie Card Title */
.movie-title-card {
  font-size: 12px;
  font-weight: 600;
}

/* Button Text */
.button-text {
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 0.2px;
}

/* Genre Text */
.genre-text {
  font-size: 10px;
  font-weight: 500;
}
```

### Tailwind CSS Typography Classes
```html
<!-- Headline Large -->
<h1 class="text-4xl font-black -tracking-wider leading-tight">Title</h1>

<!-- Title Large -->
<h2 class="text-xl font-bold -tracking-wide">Section Title</h2>

<!-- Body Medium -->
<p class="text-base font-medium tracking-tight">Body text</p>

<!-- Movie Title Hero -->
<h3 class="text-5xl font-black -tracking-wider drop-shadow-lg">Movie Title</h3>

<!-- Movie Card Title -->
<h4 class="text-xs font-semibold">Card Title</h4>

<!-- Button Text -->
<span class="text-sm font-semibold">Button</span>
```

---

## COMPONENT STYLING

### Featured Movie Card

```css
.featured-card {
  height: 420px;
  border-radius: 24px;
  overflow: hidden;
  position: relative;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
}

.featured-card__backdrop {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
}

.featured-card__overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    180deg,
    transparent 0%,
    rgba(0, 0, 0, 0.13) 30%,
    rgba(0, 0, 0, 0.4) 60%,
    rgba(0, 0, 0, 0.87) 100%
  );
}

.featured-card__glow {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  animation: pulseGlow 2s ease-in-out infinite;
}

@keyframes pulseGlow {
  0%, 100% {
    background: radial-gradient(
      circle at 30% -40%,
      rgba(0, 206, 201, 0.3) 0%,
      rgba(116, 185, 255, 0.2) 40%,
      transparent 100%
    );
  }
  50% {
    background: radial-gradient(
      circle at 30% -40%,
      rgba(0, 206, 201, 0.4) 0%,
      rgba(116, 185, 255, 0.25) 40%,
      transparent 100%
    );
  }
}

.featured-card__content {
  position: absolute;
  bottom: 120px;
  left: 24px;
  right: 24px;
  z-index: 2;
  animation: slideUp 1.4s cubic-bezier(0.34, 1.56, 0.64, 1) both;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(32px) scale(0.9);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.featured-card__title {
  font-size: 40px;
  font-weight: 900;
  color: #FFFFFF;
  letter-spacing: -1px;
  margin-bottom: 16px;
  text-shadow: 0 4px 12px rgba(0, 0, 0, 0.87);
}

.featured-card__description {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 12px;
  line-height: 1.3;
}

.featured-card__badges {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
  margin-bottom: 16px;
}

.featured-card__badge {
  background-color: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 12px;
  padding: 6px 12px;
  font-size: 12px;
  font-weight: 600;
  color: #FFFFFF;
}

.featured-card__netflix-badge {
  background-color: #E50914;
  border: none;
  padding: 4px 8px;
  border-radius: 4px;
  margin-right: 8px;
  font-weight: 900;
  font-size: 16px;
}

.featured-card__actions {
  position: absolute;
  bottom: 16px;
  left: 24px;
  right: 24px;
  display: flex;
  gap: 16px;
  z-index: 3;
}

.featured-card__button {
  flex: 1;
  padding: 12px 16px;
  border-radius: 6px;
  border: none;
  font-weight: 600;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: all 200ms ease-out;
}

.featured-card__button--primary {
  background-color: #FFFFFF;
  color: #000000;
}

.featured-card__button--primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(255, 255, 255, 0.2);
}

.featured-card__button--secondary {
  background-color: rgba(128, 128, 128, 0.3);
  color: #FFFFFF;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.featured-card__button--secondary:hover {
  background-color: rgba(128, 128, 128, 0.5);
}
```

### Movie Card (Grid Item)

```css
.movie-card {
  width: 160px;
  position: relative;
  cursor: pointer;
  transition: transform 300ms ease-out;
}

.movie-card:hover {
  transform: translateY(-4px);
}

.movie-card__image-wrapper {
  position: relative;
  height: 200px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}

.movie-card__image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 300ms ease-out;
}

.movie-card:hover .movie-card__image {
  transform: scale(1.05);
}

.movie-card__overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 40px;
  background: linear-gradient(
    180deg,
    transparent 0%,
    rgba(0, 0, 0, 0.7) 100%
  );
}

.movie-card__rating {
  position: absolute;
  top: 8px;
  right: 8px;
  background-color: rgba(0, 0, 0, 0.7);
  padding: 3px 6px;
  border-radius: 4px;
  font-size: 10px;
  font-weight: 600;
  color: #FFFFFF;
  display: flex;
  align-items: center;
  gap: 2px;
}

.movie-card__rating-star {
  color: #FFC107;
  font-size: 12px;
}

.movie-card__info {
  padding: 8px;
  margin-top: 8px;
}

.movie-card__title {
  font-size: 12px;
  font-weight: 600;
  color: #FFFFFF;
  margin-bottom: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.movie-card__genres {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.7);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
```

### Genre Chip

```css
.genre-chip {
  display: inline-block;
  background-color: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 12px;
  padding: 6px 12px;
  font-size: 12px;
  font-weight: 600;
  color: #FFFFFF;
  letter-spacing: 0.2px;
  transition: all 200ms ease-out;
}

.genre-chip:hover {
  background-color: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.5);
}
```

### Filter Pills

```css
.filter-pills {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  padding: 12px 24px;
  scroll-behavior: smooth;
}

.filter-pill {
  padding: 8px 16px;
  border-radius: 20px;
  border: 1.5px solid rgba(255, 255, 255, 0.15);
  background-color: rgba(255, 255, 255, 0.08);
  color: #FFFFFF;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  white-space: nowrap;
  transition: all 400ms cubic-bezier(0.34, 1.56, 0.64, 1);
}

.filter-pill:hover {
  background-color: rgba(255, 255, 255, 0.12);
}

.filter-pill--active {
  background: linear-gradient(135deg, #6C5CE7, #74B9FF);
  border-color: transparent;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(108, 92, 231, 0.4);
}
```

### Bottom Navigation

```css
.bottom-nav {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 100px;
  background: linear-gradient(
    180deg,
    transparent 0%,
    rgba(13, 13, 13, 0.95) 70%,
    rgba(13, 13, 13, 1) 100%
  );
  border-top: 0.5px solid rgba(116, 185, 255, 0.2);
  box-shadow: 0 -5px 20px rgba(0, 0, 0, 0.3);
  display: flex;
  justify-content: space-around;
  align-items: flex-start;
  padding-top: 8px;
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  transition: all 200ms ease-out;
}

.nav-item__icon {
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  color: #666666;
  border-radius: 50%;
  transition: all 200ms ease-out;
}

.nav-item__label {
  font-size: 11px;
  font-weight: 500;
  color: #666666;
  transition: all 200ms ease-out;
}

.nav-item__indicator {
  width: 0;
  height: 2px;
  background-color: #74B9FF;
  border-radius: 1px;
  transition: all 200ms ease-out;
}

.nav-item--active .nav-item__icon {
  color: #74B9FF;
  background: radial-gradient(
    circle,
    rgba(116, 185, 255, 0.2) 0%,
    transparent 100%
  );
  box-shadow: 0 0 15px rgba(116, 185, 255, 0.4);
  transform: scale(1.1);
}

.nav-item--active .nav-item__label {
  color: #74B9FF;
  font-weight: 600;
  font-size: 12px;
}

.nav-item--active .nav-item__indicator {
  width: 6px;
}

.nav-item:hover:not(.nav-item--active) .nav-item__icon {
  color: #888888;
}
```

### App Header

```css
.app-header {
  padding: 20px 24px 16px;
  background: linear-gradient(
    180deg,
    rgba(13, 13, 13, 0.98) 0%,
    rgba(13, 13, 13, 0) 100%
  );
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.app-header__logo {
  font-size: 24px;
  font-weight: 900;
  letter-spacing: -0.5px;
  background: linear-gradient(135deg, #6C5CE7, #74B9FF, #00CEC9);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  transition: transform 300ms ease-out;
}

.app-header__logo:hover {
  transform: scale(1.02);
}

.app-header__search {
  width: 24px;
  height: 24px;
  color: #FFFFFF;
  cursor: pointer;
  transition: all 200ms ease-out;
}

.app-header__search:hover {
  transform: scale(1.1);
  filter: brightness(1.2);
}
```

### Buttons

```css
.btn {
  padding: 12px 16px;
  border-radius: 6px;
  border: none;
  font-weight: 600;
  font-size: 14px;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  transition: all 200ms ease-out;
}

.btn--primary {
  background-color: #FFFFFF;
  color: #000000;
}

.btn--primary:hover {
  box-shadow: 0 8px 16px rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.btn--secondary {
  background-color: rgba(128, 128, 128, 0.3);
  color: #FFFFFF;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.btn--secondary:hover {
  background-color: rgba(128, 128, 128, 0.5);
  border-color: rgba(255, 255, 255, 0.4);
}

.btn--gradient {
  background: linear-gradient(135deg, #6C5CE7, #74B9FF);
  color: #FFFFFF;
}

.btn--gradient:hover {
  box-shadow: 0 8px 16px rgba(108, 92, 231, 0.4);
  transform: translateY(-2px);
}
```

---

## ANIMATIONS & TRANSITIONS

```css
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@keyframes slideUpIn {
  from {
    opacity: 0;
    transform: translateY(32px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideLeftIn {
  from {
    opacity: 0;
    transform: translateX(-32px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes slideRightIn {
  from {
    opacity: 0;
    transform: translateX(32px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes scaleIn {
  from {
    opacity: 0;
    transform: scale(0.9);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

@keyframes pulseGlow {
  0%, 100% {
    opacity: 1;
    transform: scale(1);
  }
  50% {
    opacity: 0.8;
    transform: scale(1.05);
  }
}

@keyframes shimmer {
  0% {
    background-position: -1000px 0;
  }
  100% {
    background-position: 1000px 0;
  }
}

/* Page Transitions */
.fade-in {
  animation: fadeIn 300ms ease-out forwards;
}

.slide-up-in {
  animation: slideUpIn 800ms cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
}

.slide-left-in {
  animation: slideLeftIn 300ms ease-out forwards;
}

.slide-right-in {
  animation: slideRightIn 300ms ease-out forwards;
}

.scale-in {
  animation: scaleIn 400ms cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
}
```

---

## TAILWIND CSS CONFIGURATION

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        'brand-purple': '#6C5CE7',
        'brand-blue': '#74B9FF',
        'brand-cyan': '#00CEC9',
        'bg-dark': '#0D0D0D',
        'bg-card': '#1A1A1A',
        'netflix-red': '#E50914',
      },
      fontFamily: {
        sans: [
          '-apple-system',
          'BlinkMacSystemFont',
          'Segoe UI',
          'Poppins',
          'sans-serif',
        ],
      },
      backgroundImage: {
        'gradient-brand': 'linear-gradient(135deg, #6C5CE7, #74B9FF, #00CEC9)',
        'gradient-card-1': 'linear-gradient(135deg, #667eea, #764ba2, #6C5CE7, #74B9FF)',
        'gradient-card-2': 'linear-gradient(180deg, #2c1810, #8B0000, #000000)',
        'gradient-card-3': 'linear-gradient(180deg, #2C2C54, #40407A, #706FD3)',
        'gradient-overlay': 'linear-gradient(180deg, transparent, rgba(0,0,0,0.13), rgba(0,0,0,0.4), rgba(0,0,0,0.87))',
      },
      boxShadow: {
        'glow-purple': '0 0 20px rgba(108, 92, 231, 0.4)',
        'glow-cyan': '0 0 20px rgba(0, 206, 201, 0.4)',
        'card': '0 4px 8px rgba(0, 0, 0, 0.3)',
      },
      animation: {
        'pulse-glow': 'pulseGlow 2s ease-in-out infinite',
        'slide-up': 'slideUpIn 800ms cubic-bezier(0.34, 1.56, 0.64, 1) forwards',
      },
    },
  },
};
```

---

## TAILWIND CSS USAGE EXAMPLES

```html
<!-- Featured Card -->
<div class="h-[420px] rounded-3xl overflow-hidden relative shadow-2xl group">
  <!-- Backdrop -->
  <img class="absolute inset-0 w-full h-full object-cover" src="..." />
  
  <!-- Gradient Overlay -->
  <div class="absolute inset-0 bg-gradient-overlay"></div>
  
  <!-- Content -->
  <div class="absolute bottom-32 left-6 right-6 z-10">
    <h2 class="text-5xl font-black -tracking-wider text-white drop-shadow-lg">
      Movie Title
    </h2>
    <p class="text-sm text-white/90 mt-2 line-clamp-2">
      Movie description
    </p>
    <div class="flex gap-2 mt-3 flex-wrap">
      <span class="px-3 py-1 bg-white/20 border border-white/30 rounded-full text-xs font-semibold">
        Action
      </span>
    </div>
  </div>
  
  <!-- Buttons -->
  <div class="absolute bottom-4 left-6 right-6 flex gap-4 z-20">
    <button class="flex-1 bg-white text-black py-3 rounded px-4 font-semibold hover:shadow-lg transition">
      Play
    </button>
    <button class="flex-1 bg-gray-400/30 text-white py-3 rounded px-4 font-semibold border border-white/20">
      My List
    </button>
  </div>
</div>

<!-- Movie Grid Card -->
<div class="w-40 cursor-pointer group">
  <div class="relative h-56 rounded-xl overflow-hidden shadow-lg">
    <img class="w-full h-full object-cover group-hover:scale-105 transition" src="..." />
    <div class="absolute inset-0 bg-gradient-to-b from-transparent to-black/70"></div>
    
    <!-- Optional Rating -->
    <div class="absolute top-2 right-2 bg-black/70 px-2 py-1 rounded text-xs font-semibold flex items-center gap-1">
      <span class="text-yellow-400">★</span>
      <span>8.5</span>
    </div>
  </div>
  
  <div class="px-2 py-2">
    <h3 class="text-xs font-semibold text-white truncate">Movie Title</h3>
    <p class="text-xs text-white/70 truncate">Action · Drama</p>
  </div>
</div>

<!-- Filter Pills -->
<div class="flex gap-3 overflow-x-auto px-6 py-3">
  <button class="px-4 py-2 rounded-full bg-white/8 border border-white/15 text-white text-sm font-medium whitespace-nowrap hover:bg-white/12 transition">
    All
  </button>
  <button class="px-4 py-2 rounded-full bg-gradient-brand text-white text-sm font-semibold whitespace-nowrap shadow-glow-purple">
    Action
  </button>
</div>

<!-- Bottom Navigation -->
<nav class="fixed bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-black/95 to-transparent border-t border-brand-blue/20 flex justify-around items-start pt-2">
  <a href="#" class="flex flex-col items-center gap-1">
    <div class="w-11 h-11 flex items-center justify-center rounded-full bg-brand-blue/20 text-brand-blue">
      <svg><!-- home icon --></svg>
    </div>
    <span class="text-xs font-semibold text-brand-blue">Home</span>
    <div class="w-1.5 h-0.5 bg-brand-blue rounded"></div>
  </a>
</nav>
```

---

## IMPLEMENTATION NOTES

1. **Gradients**: Use CSS `linear-gradient()` for most effects. For text gradients, use `-webkit-background-clip: text`.

2. **Shadows**: Replicate the glow effects using `box-shadow` with semi-transparent colored values.

3. **Animations**: Use CSS `@keyframes` for smooth transitions. Adjust duration and easing curves to match Flutter's behavior.

4. **Responsive Design**: Use CSS media queries or Tailwind's responsive prefixes to adapt to different screen sizes.

5. **Typography**: Use web-safe system fonts as fallbacks, with a web font like Poppins for the custom look.

6. **Dark Theme**: Apply the dark background to the body and use opacity values for text hierarchy.

7. **Icons**: Use SVG or icon libraries like Feather Icons or Tabler Icons to match the aesthetic.

8. **Performance**: Consider using CSS variables and Tailwind's JIT mode for optimal performance.


# D-eyeturn Flutter Movie App - Design Language & Style Guide

## PROJECT OVERVIEW
The app is called **D-eyeturn** (formerly FluxShorts) - a Netflix-like streaming application built with Flutter. It features a modern, dark-themed design with premium gradient effects and smooth animations.

---

## PRIMARY COLOR PALETTE

### Brand Colors
```
Primary Purple:    #6C5CE7  (RGB: 108, 92, 231)
Primary Blue:      #74B9FF  (RGB: 116, 185, 255)
Primary Cyan:      #00CEC9  (RGB: 0, 206, 201)
```

### Background Colors
```
Main Background:   #0D0D0D  (Very Dark Gray/Almost Black)
Card Background:   #1A1A1A  (Dark Gray)
```

### Accent Colors
```
Netflix Red:       #E50914  (Used for Netflix series badge)
Amber/Gold:        For star ratings
```

---

## GRADIENT DEFINITIONS

### 1. FluxShorts Brand Gradient
**Colors:** Purple → Blue → Cyan
**Usage:** Logo, primary badges, selected filter pills

### 2. Card Gradient 1 (Purple-Blue)
```
Direction: Top-Left to Bottom-Right
Colors: #667eea → #764ba2 → #6C5CE7 → #74B9FF
Stops: [0.0, 0.3, 0.7, 1.0]
```
**Usage:** Featured movie cards, placeholder backgrounds

### 3. Card Gradient 2 (Dark Brown-Red)
```
Direction: Top to Bottom
Colors: #2c1810 → #8B0000 → #000000
Stops: [0.0, 0.5, 1.0]
```
**Usage:** Alternative featured card backgrounds

### 4. Card Gradient 3 (Dark Purple)
```
Direction: Top to Bottom
Colors: #2C2C54 → #40407A → #706FD3
Stops: [0.0, 0.5, 1.0]
```
**Usage:** Alternative card backgrounds

---

## TYPOGRAPHY

### Font Family
**Primary Font:** SF Pro Display (Apple's system font)

### Text Styles

#### Headline Large
- **Size:** 34px
- **Weight:** 800 (Extra Bold)
- **Letter Spacing:** -1.0
- **Line Height:** 1.1
- **Usage:** Large screen titles

#### Title Large
- **Size:** 20px
- **Weight:** 700 (Bold)
- **Letter Spacing:** -0.4
- **Usage:** Section headers, featured content titles

#### Body Medium
- **Size:** 15px
- **Weight:** 500 (Medium)
- **Letter Spacing:** 0.1
- **Usage:** Regular body text

#### Additional Styles Used
- **Large Bold:** 40px, Weight 900, Letter Spacing -1
  - Featured movie titles in hero card
- **Movie Card Title:** 12px, Weight 600
  - Small movie card titles
- **Movie Card Subtitle:** 10px, Weight 500
  - Genre and metadata text
- **Label/Button:** 14-16px, Weight 600
  - Action buttons and interactive elements

---

## UI COMPONENT STYLING

### 1. Featured Movie Card
- **Height:** 420px
- **Border Radius:** 24px
- **Decoration:**
  - Gradient background (custom per movie)
  - Dark overlay with gradient from transparent to black
  - Radial pulse animation overlay with cyan/blue glow
  
**Elements:**
- Title: Large bold white text with text shadow
- Overview: Smaller white text (opacity 0.9)
- Genres: Genre chips with semi-transparent white background
- Netflix Badge: Red background (#E50914) with "N" logo for series
- Action Buttons:
  - Primary (Play): White background, black text, rounded corners
  - Secondary (My List): Gray transparent background, white text

**Animations:**
- Scale transition (0.9 → 1.0)
- Slide animation from bottom with offset (0, 0.2)
- Pulse glow effect (1.0 → 1.05)
- Radial gradient follows pulse animation

### 2. Movie Card (Grid Item)
- **Width:** 160px (customizable)
- **Height:** 200px (customizable)
- **Border Radius:** 12px
- **Box Shadow:** 0 4px 8px with black opacity 0.3
- **Image:** Cached network image with gradient placeholder
- **Bottom Overlay:** Gradient overlay (transparent → black 0.7)
- **Rating Badge (optional):**
  - Dark background with opacity 0.7
  - Star icon with amber color
  - Rating text in small bold font

**Optional Title Section:**
- Movie title: 12px, weight 600, white
- Genre text: 10px, weight 500, white opacity 0.7

### 3. Genre Chip
- **Padding:** 12px horizontal, 6px vertical
- **Background:** White with opacity 0.2
- **Border:** 1px white with opacity 0.3
- **Border Radius:** 12px
- **Text:** 12px, weight 600, white, letter-spacing 0.2

### 4. Filter Pills
- **States:**
  - **Inactive:** 
    - Background: White opacity 0.08
    - Border: White opacity 0.15
    - Text: White opacity varies
  - **Active:** 
    - Gradient: Purple to Blue (#6C5CE7 → #74B9FF)
    - Shadow: Purple glow (opacity 0.4)
    - Text: White, weight 600

- **Padding:** 16px horizontal, 8px vertical
- **Border Radius:** 20px
- **Animation:** 400ms easeOutExpo

### 5. Bottom Navigation Bar
- **Height:** 100px
- **Background:** Gradient fade from transparent to dark
- **Top Border:** 0.5px cyan line (opacity 0.2)
- **Box Shadow:** Black shadow above

**Navigation Items:**
- Icon size: 20px
- Icon color (inactive): #666666
- Icon color (active): #74B9FF
- Background (active): Radial gradient with cyan tint
- Glow effect on active: Cyan shadow (opacity 0.4)
- Selection indicator: 6px wide, 2px high line

**Animations:**
- Scale on selection (1.0 → 1.1)
- Elastic out curve for bouncy feel

### 6. App Header
- **Padding:** 24px horizontal, 20px vertical top
- **Background:** Linear gradient fade (dark → transparent)
- **Logo:** "D-eyeturn" with gradient mask (purple → blue → cyan)
- **Logo Animation:** Hero animation on navigation
- **Font:** 24px, weight 900, letter-spacing -0.5

**Right Icon:**
- Search icon, 24px, white
- Fade + Slide transition on tap

### 7. Buttons
**Primary Button:**
- Background: White (#FFFFFF)
- Text Color: Black
- Padding: 12px vertical
- Border Radius: 6px
- Text: 16px, weight 600

**Secondary Button:**
- Background: Gray with opacity 0.3
- Text Color: White
- Same padding and radius

**Button Icons:** 20px, with 8px spacing from text

---

## SCREEN DESIGNS

### Home Screen
**Layout:**
1. App Header with logo + search
2. Category Filter Pills (horizontal scroll)
3. Featured Movie Card (auto-rotating every 3 minutes)
4. "Editor's Picks" horizontal scroll
5. "Viral Right Now" / Top 10 section
6. "Continue Watching" section
7. Multiple category sections (dynamically loaded)
8. "My List" section
9. Bottom Navigation Bar

**Colors:**
- Background: #0D0D0D
- Text: White (various opacities)
- Accents: Primary colors

**Animations:**
- Header fade-in on load
- Card scale + slide on initial display
- Pulse animation on featured card
- Bouncing scroll physics

### Movie Detail Screen
**Layout:**
1. Sliver AppBar with backdrop image
   - Flexible space with gradient overlay
   - Back button in circular dark container
   - Share button in circular dark container
   - Pinned title bar
2. Movie Information Section
3. Action Buttons (Watch Now, My List)
4. Overview/Description
5. Cast Section
6. Trailers Section
7. Reviews Section
8. Similar Movies Section

**Styling:**
- Backdrop image with dark gradient overlay
- Circular icon buttons with dark semi-transparent backgrounds
- Content padding: 24px horizontal
- Section spacing: 32px

### Profile Screen
**Layout:**
1. Header with close/back button
2. Profile Picture (circular avatar with gradient)
3. User Name & Email
4. Stats Section (watch time, movies watched, etc.)
5. Settings Section
6. Account Management Section
7. Logout Button

**Color Scheme:**
- Background: #0D0D0D
- Sections: Cards with slightly lighter background (#1A1A1A)
- Text: White and white with opacity
- Toggles: Cyan/Blue accents

---

## ANIMATIONS & TRANSITIONS

### Page Transitions
- **Default:** Fade transition (300ms)
- **To Profile:** Slide from right (300ms)
- **To Search:** Fade + Slide from top (300ms)
- **Curve:** easeOutQuart for smooth deceleration

### Component Animations
- **Header:** Fade in with easeOutExpo (1000ms)
- **Cards:** Scale + Slide with elasticOut (1400ms)
- **Pulse:** Repeating animation 1.0 → 1.05 (2000ms)
- **Buttons:** InkWell ripple with transparent splash color
- **Navigation:** Scale with elasticOut on selection

### Haptic Feedback
- Light impact for most taps
- Medium impact for play button
- Selection click for filter pills

---

## SPACING & LAYOUT

### Standard Spacing
- **Header padding:** 24px horizontal, 20px vertical
- **Content padding:** 20-24px horizontal
- **Section spacing:** 32px
- **Element spacing:** 12-16px
- **Card spacing:** 12px margin between items

### Border Radius
- **Large containers:** 24px
- **Medium containers:** 12px
- **Buttons:** 6px
- **Pills:** 20px

### Shadows
- **Standard box shadow:** 0 4px 8px, black opacity 0.3
- **Subtle shadow:** 0 6px 16px, black opacity 0.6
- **Glow shadow:** Variable blur, colored (purple, cyan)

---

## DARK THEME SPECIFICATIONS

The entire app uses a dark theme with:
- Background: #0D0D0D
- Cards: #1A1A1A
- Text: Pure white (#FFFFFF) or white with opacity for secondary text
- No light backgrounds

**Text Opacity Levels:**
- Primary text: 1.0
- Secondary text: 0.9
- Tertiary text: 0.7
- Disabled text: 0.5

**Background Opacity Levels:**
- Cards: Full opacity
- Overlays: 0.2 - 0.8 depending on use
- Disabled elements: 0.08

---

## KEY DESIGN PATTERNS

### 1. Gradient Masking
Logo and badges use gradient masking for visual appeal:
```
ShaderMask with LinearGradient applied to text
```

### 2. Layered Overlays
Cards use multiple overlay layers:
- Base image/gradient
- Gradient overlay for readability
- Optional radial glow effect

### 3. Animating Containers
Heavily uses AnimatedContainer for smooth state changes:
- Filter pills expand/contract on selection
- Bottom nav items scale and glow

### 4. Hero Animations
Logo uses hero animation for consistency across navigation

### 5. Custom Scroll Physics
Uses BouncingScrollPhysics for iOS-like momentum scrolling

### 6. Material Design + Custom
Mix of Material Design patterns with custom styling:
- Material InkWell for tap feedback
- Custom theme overrides for colors
- Custom navigation transitions

---

## LAYOUT GRID & RESPONSIVE DESIGN

- **Device:** Mobile-first (Flutter handles responsiveness)
- **Safe Area:** Used on all screens
- **Column Layout:** Main content in SingleChildScrollView or CustomScrollView
- **Horizontal Scrolling:** SingleChildScrollView for categories

---

## ACCESSIBILITY

- All interactive elements have minimum 44px touch targets
- Icons are 20-24px (within WCAG standards)
- Color contrast maintained for white text on dark backgrounds
- Haptic feedback for interactions
- No text size smaller than 10px for important content

---

## CODE REFERENCES

### Key Files Implementing Design:
1. `/lib/utils/app_colors.dart` - Color palette definitions
2. `/lib/theme/app_theme.dart` - Theme configuration
3. `/lib/widgets/featured_card.dart` - Featured movie card styling
4. `/lib/widgets/movie_card.dart` - Movie grid item styling
5. `/lib/widgets/bottom_navigation.dart` - Bottom nav styling
6. `/lib/widgets/category_filters.dart` - Filter pills styling
7. `/lib/widgets/app_header.dart` - Header styling
8. `/lib/widgets/genre_chip.dart` - Chip styling
9. `/lib/screens/home_screen.dart` - Home layout
10. `/lib/screens/movie_detail_screen.dart` - Detail page layout
11. `/lib/screens/profile_screen.dart` - Profile layout


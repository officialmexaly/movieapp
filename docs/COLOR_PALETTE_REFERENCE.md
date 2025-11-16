# D-eyeturn Color Palette Quick Reference

## Color Swatches

### Primary Brand Colors
| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| Purple | #6C5CE7 | 108, 92, 231 | Primary actions, logo, badges |
| Blue | #74B9FF | 116, 185, 255 | Secondary actions, accents, hover states |
| Cyan | #00CEC9 | 0, 206, 201 | Tertiary accent, glow effects |

### Background Colors
| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| Dark Background | #0D0D0D | 13, 13, 13 | Main background |
| Card Background | #1A1A1A | 26, 26, 26 | Card backgrounds |
| Dark Overlay | #000000 | 0, 0, 0 | Overlays with opacity |

### Accent Colors
| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| Netflix Red | #E50914 | 229, 9, 20 | Netflix series badge |
| Star/Amber | #FFC107 | 255, 193, 7 | Star ratings |
| Icon Gray (Inactive) | #666666 | 102, 102, 102 | Inactive navigation icons |

---

## Opacity Variations

### Text Opacity
```
Primary Text:    rgba(255, 255, 255, 1.0)    - Full opacity
Secondary Text:  rgba(255, 255, 255, 0.9)    - 90% opacity
Tertiary Text:   rgba(255, 255, 255, 0.7)    - 70% opacity
Disabled Text:   rgba(255, 255, 255, 0.5)    - 50% opacity
```

### Background Opacity
```
Strong Overlay:  rgba(0, 0, 0, 0.87)         - 87% opacity
Medium Overlay:  rgba(0, 0, 0, 0.6)          - 60% opacity
Light Overlay:   rgba(0, 0, 0, 0.4)          - 40% opacity
Very Light:      rgba(0, 0, 0, 0.13)         - 13% opacity
```

### Component Opacity
```
Button Background:  rgba(255, 255, 255, 0.08)  - 8% opacity
Border:            rgba(255, 255, 255, 0.15)  - 15% opacity
Border (Stronger): rgba(255, 255, 255, 0.3)   - 30% opacity
Chip Background:   rgba(255, 255, 255, 0.2)   - 20% opacity
```

---

## Gradient Combinations

### Brand Gradient (3 colors)
```
Start:  #6C5CE7 (Purple)
Middle: #74B9FF (Blue)
End:    #00CEC9 (Cyan)
Direction: 135deg
```

### Card Gradient 1 (Purple-Blue)
```
Stops: [0%, 30%, 70%, 100%]
Colors: #667eea → #764ba2 → #6C5CE7 → #74B9FF
Direction: Top-left to bottom-right
```

### Card Gradient 2 (Dark Brown-Red)
```
Stops: [0%, 50%, 100%]
Colors: #2c1810 → #8B0000 → #000000
Direction: Top to bottom
```

### Card Gradient 3 (Dark Purple)
```
Stops: [0%, 50%, 100%]
Colors: #2C2C54 → #40407A → #706FD3
Direction: Top to bottom
```

### Dark Overlay (4-step)
```
Stops: [0%, 30%, 60%, 100%]
Colors: transparent → #000000 22% → #000000 40% → #000000 87%
Direction: Top to bottom
```

---

## CSS/Tailwind Quick Copy

### CSS Variables
```css
--primary-purple: #6C5CE7;
--primary-blue: #74B9FF;
--primary-cyan: #00CEC9;
--bg-dark: #0D0D0D;
--bg-card: #1A1A1A;
--netflix-red: #E50914;
```

### Tailwind Config Colors
```javascript
'brand-purple': '#6C5CE7',
'brand-blue': '#74B9FF',
'brand-cyan': '#00CEC9',
'bg-dark': '#0D0D0D',
'bg-card': '#1A1A1A',
'netflix-red': '#E50914',
```

### Tailwind Opacity Shortcuts
```
text-white              → #FFFFFF (100%)
text-white/90           → rgba(255, 255, 255, 0.9)
text-white/70           → rgba(255, 255, 255, 0.7)
text-white/50           → rgba(255, 255, 255, 0.5)
bg-white/8              → rgba(255, 255, 255, 0.08)
bg-white/20             → rgba(255, 255, 255, 0.2)
```

---

## Color Usage Guidelines

### Navigation & Interactive
- Use **Purple (#6C5CE7)** for primary CTAs and main navigation
- Use **Blue (#74B9FF)** for secondary actions and hover states
- Use **Cyan (#00CEC9)** for glow effects and subtle accents

### Backgrounds
- Use **#0D0D0D** for main page backgrounds
- Use **#1A1A1A** for card containers
- Apply black with opacity for overlays to maintain depth

### Text Hierarchy
- **Primary content**: White (1.0 opacity)
- **Secondary info**: White (0.9 opacity)
- **Tertiary/metadata**: White (0.7 opacity)
- **Disabled state**: White (0.5 opacity)

### Contrast & Readability
- All text on dark backgrounds maintains WCAG AAA contrast
- Use text shadows for text on image overlays (#000000 with blur)
- Avoid pure white on images - use semi-transparent overlays first

---

## Color Combinations for Components

### Featured Card Badge
```
Background: Linear gradient (#6C5CE7 to #74B9FF)
Text: White
Border: None
Shadow: 0 4px 12px rgba(108, 92, 231, 0.4)
```

### Filter Pill (Inactive)
```
Background: rgba(255, 255, 255, 0.08)
Border: 1.5px solid rgba(255, 255, 255, 0.15)
Text: White (0.8 opacity)
```

### Filter Pill (Active)
```
Background: Linear gradient (#6C5CE7 to #74B9FF)
Text: White
Shadow: 0 4px 12px rgba(108, 92, 231, 0.4)
```

### Primary Button
```
Background: #FFFFFF
Text: #000000
Hover Shadow: 0 8px 16px rgba(255, 255, 255, 0.2)
```

### Secondary Button
```
Background: rgba(128, 128, 128, 0.3)
Text: White
Border: 1px solid rgba(255, 255, 255, 0.2)
Hover: rgba(128, 128, 128, 0.5)
```

---

## Animation Color Transitions

### Glow Effects
```
Cyan Glow: 
  - Start: rgba(0, 206, 201, 0.3)
  - Mid: rgba(116, 185, 255, 0.2)
  - End: transparent

Purple Glow:
  - Start: rgba(108, 92, 231, 0.4)
  - Mid: rgba(108, 92, 231, 0.2)
  - End: transparent
```

---

## Accessibility Notes

- **Contrast Ratio (WCAG AA)**: All text meets minimum 4.5:1 ratio
- **Color Blind Safe**: Primary colors chosen for distinguishability
- **No Color Only**: Important information is not conveyed by color alone
- **Dark Theme**: Reduces eye strain and works well for media consumption


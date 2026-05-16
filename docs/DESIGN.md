# Design System: Casual Bubbly

## Brand & Style
The design system moves away from the neon arcade aesthetic towards a "Casual Bubbly" feel, inspired by modern trivia games like "Perguntados" (Trivia Crack). It targets a broad, casual audience that values fun, clarity, and tactile responsiveness.

The visual style is **Light/Dark, Vibrant, and Playful**. Key hallmarks include:
- **Clean Backgrounds:** Light grey or deep charcoal backgrounds to let the category colors pop.
- **Vibrant Solid Colors:** Each category is represented by a distinct, high-saturation color.
- **Soft Geometry:** Extensive use of rounded corners and pill-shaped elements.
- **Tactile Depth:** Subtle drop shadows and "bubble" effects.

## Colors
The palette is built on a flexible base with vibrant accents for gameplay.

### Light Mode
- **Background:** `#F8F9FA` (Off-White)
- **Surface:** `#FFFFFF` (White)
- **Text Primary:** `#2D3436`
- **Text Secondary:** `#636E72`

### Dark Mode
- **Background:** `#121212` (Deep Charcoal)
- **Surface:** `#1E1E1E` (Dark Grey)
- **Text Primary:** `#E0E0E0`
- **Text Secondary:** `#B0B0B0`

### Categories (Universal)
- **History (Yellow):** `#FFD700`
- **Science (Green):** `#4CAF50`
- **Geography (Blue):** `#2196F3`
- **Art (Red):** `#F44336`
- **Sports (Orange):** `#FF9800`
- **Entertainment (Pink):** `#E91E63`
- **Crown/Special (Purple):** `#9C27B0`

## Typography
The typography system uses rounded fonts to maintain a friendly and accessible atmosphere.

**Nunito** is the primary font for headlines and question text. It provides a balanced, organic feel that is easy to read.

**Varela Round** is used for buttons and labels, offering a consistent "bubble" aesthetic across all interactive elements.

## Layout & Spacing
- **Responsive Containers:** Use flexible layouts that adapt well to various screen sizes.
- **Pill Shapes:** All primary buttons are pill-shaped (full border radius).
- **Generous White Space:** Ensure elements have enough room to "breathe."

## Elevation & Depth
- **Soft Drop Shadows:** Use `BoxShadow` with low opacity and high blur.
- **Layering:** Content cards should feel like they are floating slightly above the background.

## Components

### Theme Toggle
Located in the global `AppBar`, allows users to switch between Light and Dark modes seamlessly.

### Buttons
Pill-shaped with solid color fills. They use a slightly darker bottom border or shadow to simulate a physical "pressable" button.

### Question Cards
Large cards with rounded corners (24px) and a soft shadow. Adapts its color to the current theme surface.

### Answer Chips
Rounded rectangles or pill-shaped outlines. When selected, they fill with the category color or success/error colors (Green/Red).

### Timer
A circular countdown that changes color (Yellow/Green to Red) as time runs out.

### Categories
Represented by large, circular icons with their respective solid colors and a representative icon inside.

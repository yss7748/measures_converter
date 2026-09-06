# Measures Converter - Flutter University Assignment

A clean, single-file Material 3 Measures Converter application built with Flutter & Dart.

## Project Structure
```text
measures_converter/
├── pubspec.yaml
├── lib/
│   └── main.dart
└── README.md
```

## Features
- **Material 3 Clean UI**: Blue palette, responsive card layout, customizable input fields.
- **Supported Units**:
  - **Distance**: Meters, Kilometers, Miles, Feet, Inches
  - **Mass / Weight**: Kilograms, Grams, Pounds, Ounces
- **Incompatible Conversion Protection**: Gracefully catches cross-category conversions (e.g., Distance to Mass) with inline error cards and floating SnackBars.
- **Robust Input Handling**: Validates empty and non-numeric inputs without crashing.
- **Accurate Formatting**: Matches the exact university output format:
  `"{value} {fromUnit} are {result} {toUnit}"` (e.g., `100.0 meters are 328.084 feet`).
- **Bonus UX**: Unit swap button, input clear button, and form reset action in the AppBar.

## How to Run
1. Navigate to the project directory:
   ```bash
   cd /Users/saisahishnuyerraguravagari/.gemini/antigravity/scratch/measures_converter
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

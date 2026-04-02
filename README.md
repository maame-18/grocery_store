# 🥂 FoodShop UI - Premium Food & Grocery Experience

[![Flutter](https://img.shields.io/badge/Flutter-v3.22+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![State Management](https://img.shields.io/badge/Provider-v6.1.1-6BA539?logo=flutter&logoColor=white)](https://pub.dev/packages/provider)
[![Firebase](https://img.shields.io/badge/Firebase-Auth-FFCA28?logo=firebase&logoColor=white)](https://firebase.google.com)

A high-fidelity, premium Flutter application designed for a seamless food and grocery shopping experience. Built with a focus on modern aesthetics, fluid animations, and robust functionality.

## ✨ Features

### 🎨 Visual Excellence
- **Deeply Immersive Dark Mode**: Full system-aware dark theme support with curated surface and background tokens.
- **Interactive Shuffle Banner**: A custom 3D card shuffle interaction for featured promotions, replacing traditional carousels with elastic physics and parallax effects.
- **Micro-interactions**: Subtle bounce animations, hover effects, and spring-based transitions for a premium tactile feel.

### 🍔 Advanced Ordering
- **Complex Customization**: Support for multi-select toppings (checkboxes) and exclusive choices (radio buttons) with real-time price calculation.
- **Special Instructions**: Direct-to-kitchen notes and references for highly personalized orders.
- **Smart Cart System**: Intelligent grouping of items based on customization, ensuring unique configurations are treated as separate line items.

### 🔐 Core Functionality
- **Firebase Authentication**: Secure user sign-up and sign-in with granular error feedback.
- **Wishlist Management**: Personalized "Favorites" section with animated state persistence.
- **Global Tab State**: Unified navigation shell for seamless switching between Home, Cart, Favorites, and Profile.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Provider](https://pub.dev/packages/provider) (Cart, Theme, Tab, Favorites)
- **Backend**: [Firebase Auth](https://firebase.google.com)
- **Typography**: [Google Fonts (Inter)](https://fonts.google.com/specimen/Inter)
- **Image Handling**: [Cached Network Image](https://pub.dev/packages/cached_network_image) for optimized performance.

## 📱 Screenshots

*Coming Soon...*

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Stable channel)
- Dart SDK
- Firebase account for backend features

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/maame-18/grocery_store.git
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup:**
   - Link your project to [Firebase Console](https://console.firebase.google.com).
   - Download and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```text
lib/
├── models/         # Data models (FoodItem, Topping, CartItem)
├── providers/      # Global state (Cart, Favorites, Tab, Theme)
├── screens/        # UI Layers (Home, Main Shell, Details, etc.)
├── services/       # External integrations (AuthService)
├── utils/          # Constants, Mock Data, and Theme configs
└── widgets/        # Reusable UI components (ShuffleBanner, FoodCard)
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Handcrafted with ❤️ using Flutter.*

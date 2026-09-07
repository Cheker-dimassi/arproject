# 🛋️ Smart Room AR — Luxury Augmented Reality Furniture & Decor

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.4-6DB33F?style=for-the-badge&logo=spring-boot&logoColor=white)](https://spring.io/projects/spring-boot)
[![ARCore](https://img.shields.io/badge/ARCore-Compatible-EA4335?style=for-the-badge&logo=google&logoColor=white)](https://developers.google.com/ar)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**Smart Room AR** is an enterprise-grade mobile application built with **Flutter** and connected to a high-performance **Spring Boot 3 REST API**. It empowers users to preview luxury furniture, ambient lighting, and art pieces directly in their physical space in photorealistic 3D using **Augmented Reality (ARCore)** before requesting personalized merchant quotes.

---

## 📸 Key Features

### 🌟 1. Immersive 3D & Augmented Reality
- Interactive 3D model inspector with 360° orbit, pan, and zoom gestures.
- One-tap AR button leveraging Google SceneViewer / ARCore.
- Intelligent surface placement: **horizontal ground planes** for tables/sofas and **vertical surfaces** for wall art and sconces.
- Verified CDN-hosted `.glb` assets with automatic camera framing.

### 🎨 2. Luxury Dark Design System
- Sleek dark aesthetic (`#0E0F12` background, `#1A1C23` cards, `#E8A33D` warm gold accents).
- High-contrast typography powered by Google Fonts (*Outfit* & *Plus Jakarta Sans*).
- Fluid micro-animations, category chips, and search filtering across 27+ catalog items.

### 🌍 3. Reactive Trilingual Localization & RTL
- Seamless on-the-fly switching between **Français**, **English**, and **العربية**.
- Native **RTL (Right-to-Left)** layout adaptation for Arabic with proper text alignment.
- Persistent language preference saved to device storage.

### 🛒 4. Persistent Shopping Basket & Quote Requests
- Multi-item shopping cart stored locally using `SharedPreferences`.
- Bulk quote submission sending multiple article IDs to `POST /api/quotes`.
- Dynamic total calculation, instant quantity adjustments, and swipe-to-remove.

### 📋 5. Interactive Customer Quote Tracking
- Real-time quote status tracking with color-coded badges:
  - ⏳ **En attente** (`#F59E0B`)
  - ✅ **Traité** (`#10B981`)
  - ❌ **Refusé** (`#EF4444`)
- Detailed quote breakdown displaying submission timestamp, requested items, and merchant notes.

### ⚡ 6. Offline Catalog Disk Caching
- Dual-tier data strategy: instant offline startup from local JSON cache.
- Silent background refresh when connected to Spring Boot backend.
- Network resilience with intuitive retry and offline banner notifications.

### 🔐 7. Merchant Admin Portal
- Protected `/admin` login screen with credential validation.
- Merchant dashboard to triage incoming customer quotes.
- Live status updates via `PATCH /api/quotes/{id}/status`.
- Filter quotes by status (`ALL`, `EN_ATTENTE`, `TRAITE`, `REFUSE`).

---

## 🏛️ Architecture & Project Structure

```
lib/
├── core/
│   ├── admin_session.dart     # Admin authentication state & preferences
│   ├── api_client.dart        # HTTP client with caching & error handling
│   ├── app_config.dart        # Host configuration (10.0.2.2 / LAN IP)
│   ├── cart.dart              # Persistent multi-item cart singleton
│   ├── favorites.dart         # Local favorites bookmark state
│   ├── l10n.dart              # Trilingual dictionary (FR, EN, AR)
│   ├── quote_history.dart     # Customer submitted quote persistence
│   └── theme.dart             # Dark luxury theme tokens & styling
├── data/
│   ├── article.dart           # Article model with JSON serialization
│   └── quote_request.dart     # Quote & customer data models
├── features/
│   ├── admin/                 # Merchant portal & status triage
│   ├── ar/                    # 3D model viewer & AR picker
│   ├── article_detail/        # Detailed product view with 3D preview
│   ├── cart/                  # Shopping cart & quote submission
│   ├── catalog/               # Category filters & product grid
│   ├── favorites/             # Bookmarked favorite items
│   ├── onboarding/            # Welcome splash & feature intro
│   ├── profile/               # Language selector & app settings
│   ├── quote/                 # Quote request form
│   ├── quotes/                # Customer quote history screen
│   ├── search/                # Real-time search by name/category/material
│   └── shell/                 # Bottom navigation shell
└── main.dart                  # App bootstrap with async initialization
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.24.0` or later
- **Dart SDK**: `^3.5.0`
- **Android Device**: ARCore compatible (Android 8.0+ / API 26+) or emulator
- **Backend**: [augmented-reality-backend](https://github.com/ayoubgaouet/augmented-reality-backend) running on port 8080

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ayoubgaouet/arproject.git
   cd arproject
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Backend URL:**
   Update `lib/core/app_config.dart` with your server IP:
   - For Android Emulator: `http://10.0.2.2:8080`
   - For Physical Device via USB reverse: `http://127.0.0.1:8080` (run `adb reverse tcp:8080 tcp:8080`)
   - For Local Network: `http://192.168.x.x:8080`

4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🌐 API Endpoints Consumed

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/articles` | Retrieve active furniture & decor catalog |
| `GET` | `/api/articles/{id}` | Fetch detailed product specs and 3D model URL |
| `POST` | `/api/quotes` | Submit customer quote request for multiple items |
| `GET` | `/api/quotes` | Fetch all quotes (Admin Basic Auth) |
| `PATCH` | `/api/quotes/{id}/status` | Update quote status (`EN_ATTENTE`, `TRAITE`, `REFUSE`) |

---

## 🤝 Contributing & Workflow

This repository adheres to a pull request workflow with semantic branch naming:
- `feat/` — New features and enhancements
- `fix/` — Bug fixes and stability patches
- `docs/` — Documentation updates
- `chore/` — Build configuration and tooling

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.


---

## 👥 Engineering Team & Credits

- **Cheker Dimassi** ([@Cheker-dimassi](https://github.com/Cheker-dimassi)) — Mobile Client Engineering, ARCore Spatial Tracking & UI Architecture
- **Ayoub Gaouet** ([@ayoubgaouet](https://github.com/ayoubgaouet)) — Backend Services, Spring Boot 3 API & Model Pipelines

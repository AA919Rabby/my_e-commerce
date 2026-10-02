# Mye Commerce

A Flutter mobile app for commerce and on-demand home services. Users can browse services, manage a cart, place orders, update their profile, and receive live updates through real-time notifications.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)](#)
[![State](https://img.shields.io/badge/State-GetX-8A2BE2)](https://pub.dev/packages/get)

**[Watch the demo video](https://drive.google.com/file/d/1AfOKD8kjRPD6sfqJdudAwbiSnDZrUqj8/view?usp=drivesdk)** · **[Download the Android APK](https://drive.google.com/file/d/1ug4T4-ON_n1vBp2HHEelqqGHrXCuqcv7/view?usp=drive_link)**

---

## Overview

Mye Commerce is a service marketplace app that makes everyday home-service bookings quick and easy. The Flutter frontend connects to a REST backend API for authentication, services, orders, notifications, and profile data, and uses a **WebSocket** connection to push live updates to the user.

## Features

- **Authentication and session handling**: secure login with persistent sessions.
- **Service browsing**: explore available services from the home dashboard.
- **Cart and orders**: view service details, add to cart, and place orders.
- **Profile management**: edit profile details and upload a profile image.
- **Live notifications**: real-time notifications delivered over WebSocket.
- **Real-time events**: profile and order updates reflected instantly in the app.
- **Polished UX**: loaders, error handling, and snackbar feedback throughout.
- **Responsive UI**: adapts to different screen sizes with Flutter ScreenUtil and reusable custom widgets.

## Screens

- Intro / onboarding
- Authentication flow
- Home dashboard
- Service details and cart
- Profile and update profile
- Notifications
- Settings

## Tech Stack

| Area | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State management and routing | GetX |
| API communication | HTTP (REST) |
| Real-time updates | WebSocket |
| Local storage | Shared Preferences |
| Media | Image Picker |
| Location | Geolocator, Geocoding |
| Configuration | Flutter Dotenv |
| UI | Flutter ScreenUtil, custom widgets |

## Architecture

The code is organized into clear layers, with GetX bindings and routes registered centrally.

```
mye_commerce/
├── android/
├── ios/
├── asset/                 # Images and static assets
├── test/
└── lib/
    ├── core/              # Shared widgets, theme, constants
    ├── global/            # Global helpers and app-wide state
    ├── local_db/          # Local storage layer
    ├── presentation/      # Screens and controllers
    ├── services/          # API and WebSocket services
    ├── all_binding.dart   # GetX dependency bindings
    ├── all_route.dart     # App routes
    ├── app.dart
    └── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Android Studio or VS Code with the Flutter plugin
- An emulator or physical device
- A running backend API (base URL required)

### Setup

```bash
# 1. Clone the repository and switch to the branch
git clone https://github.com/your-username/mye_commerce.git
cd mye_commerce
git checkout Service-name

# 2. Install dependencies
flutter pub get
```

### Configure environment variables

Create a `.env` file in the project root:

```env
BASE_URL=https://your-api-url.com
```

> The app needs a backend that provides the authentication and service endpoints. `BASE_URL` must point to your deployed backend, and the WebSocket service URL is set in the app configuration.

### Run

```bash
flutter run
```

### Build a release APK

```bash
flutter build apk --release
```

## Security Notes

- The API URL and other configuration live in a `.env` file that is **not** committed to the repository.
- Never commit secrets, API keys, or signing keystores.

## Roadmap

- Unit, widget, and integration tests
- Push notifications (FCM) when the app is in the background
- Online payment integration
- Play Store release

## License

This project is intended for educational and personal development use.

## Author

**Your Name**: Flutter developer
Branch: `Service-name`

Open to collaboration and job opportunities. Feel free to reach out.
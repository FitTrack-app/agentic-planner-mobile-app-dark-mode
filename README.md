# Fittrac Frontend

## About This Repository

This repository contains the **frontend mobile application** for the Fittrac project. It focuses on the user interface and client-side logic for workout planning and real-time form correction using AI models and the device camera.

> **Note:** This is the frontend-only repository built with Flutter. For backend services, AI model training, and other components, please refer to the corresponding repositories in the [Fittrac organization](https://github.com/fittrac).

## Features

- **Personalized Workout Planning UI** - Interactive interface powered by AI-driven APIs for customized fitness routines
- **Real-time Form Feedback** - Live exercise form correction using camera integration and pose detection
- **Cross-platform Support** - Runs on both Android and iOS devices
- **Progress Tracking** - Visual dashboards for monitoring fitness goals and achievements
- **Exercise Library** - Comprehensive database of exercises with detailed instructions and demonstrations

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Provider/Riverpod
- **Camera Integration**: camera plugin
- **HTTP Requests**: dio package
- **Local Storage**: shared_preferences
- **Charts & Analytics**: fl_chart

## Prerequisites

- **Flutter SDK** (latest stable version)
- **Android Studio** - Required for Android development environment
- **Android device** with USB debugging enabled
- **USB cable** for device connection
- Backend API services running (see [Fittrac Backend](https://github.com/fittrac/backend))

## Getting Started

### Installation

1. **Install Flutter SDK**
   ```bash
   # Follow official Flutter installation guide for your OS
   # https://docs.flutter.dev/get-started/install
   ```

2. **Install Android Studio**
   - Download from https://developer.android.com/studio
   - Install Android SDK and configure environment

3. **Clone the repository**
   ```bash
   git clone https://github.com/fittrac/frontend.git
   cd frontend
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```
   
### Running the App

1. **Connect your Android device via USB cable**
2. **Enable USB debugging** on your Android device
3. **Verify device connection**
   ```bash
   flutter devices
   ```
4. **Run the application**
   ```bash
   flutter run
   ```

The app will be installed and launched on your connected Android device.

## Project Structure

<img width="221" height="340" alt="image" src="https://github.com/user-attachments/assets/e5c8a7e1-5084-42a0-aba6-29aaff57128b" />

## Screen Components Overview

-**main.dart** : App entry point and navigation setup
-**welcome_screen.dart** : First screen users see with app introduction and navigation to login/signup
-**login_screen.dart** : User authentication and login functionality
-**signup_screen.dart** : New user registration with form validation
-**forgot_password.dart** :  Password recovery flow for existing users
-**homescreen.dart** : Main home screen after login, central navigation hub
-**dashboard_home.dart** : User dashboard with overview of fitness progress and stats
-**workout_dashboard.dart** : Workout-specific dashboard showing exercise plans and progress
-**camera_screen.dart** : Real-time form checking using device camera and AI analysis
-**metrics_screen.dart** :  Detailed fitness metrics, charts, and progress tracking
-**Profile.dart** : User profile management, settings, and account information


## Key Features

- **WorkoutPlanner**: AI-powered workout creation interface
- **FormChecker**: Real-time exercise form analysis using device camera
- **Dashboard**: Progress tracking and analytics
- **ExerciseLibrary**: Browse and search exercise database

## Camera Integration

The app requires camera permissions for form checking features. Camera permissions are configured in the android/app/src/main/AndroidManifest.xml file. The app will automatically request permissions when the camera feature is first used.


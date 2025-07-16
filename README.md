# Notes Management App

A Flutter application for managing personal notes with user authentication and real-time synchronization using Firebase Firestore.

## Features

- **User Authentication**: Sign up and log in with email and password
- **Notes Management**: Create, read, update, and delete notes
- **Real-time Sync**: Changes are instantly synchronized with Firebase Firestore
- **Offline Support**: Works offline with local caching
- **Input Validation**: Comprehensive validation for all user inputs
- **Clean Architecture**: Organized codebase following clean architecture principles

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Screens   │  │   Widgets   │  │   State Management  │  │
│  │             │  │             │  │    (BLoC/Cubit)    │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │ Use Cases   │  │   Repository        │  │
│  │             │  │             │  │   Interface         │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Repository  │  │ Data Source │  │      Models         │  │
│  │Implementation│  │ (Firebase)  │  │                     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Project Structure

```
MOBILE_NOTE_APP/
├── .dart_tool/
├── .idea/
├── android/
├── ios/
├── lib/
│   ├── data/
│   │   ├── models/
│   │   └── repositories/
│   ├── presentation/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── main.dart
│   └── firebase_options.dart
├── linux/
├── macos/
├── test/
├── web/
├── windows/
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── firebase.json
├── mobile_note_app.iml
├── pubspec.lock
├── pubspec.yaml
├── README.md
└── test_firebase.dart
```

## Prerequisites

Before running this application, ensure you have the following installed:

- **Flutter SDK**: Version 3.0.0 or higher
- **Dart SDK**: Version 2.17.0 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Firebase CLI**: For Firebase configuration

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/notes-management-app.git
cd notes-management-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### Android Setup:
1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add an Android app to your project
3. Download `google-services.json` and place it in `android/app/`
4. Add the following to `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

#### iOS Setup:
1. Add an iOS app to your Firebase project
2. Download `GoogleService-Info.plist` and place it in `ios/Runner/`
3. Configure iOS settings in Xcode

## State Management

This application uses **Provider** pattern for state management, which provides simple and efficient state management solution that's easy to understand and implement.

## Input Validation

The app includes comprehensive input validation for:
- Email format validation
- Password strength requirements
- Form input validation with specific error messages

## Error Handling

The app provides comprehensive error handling with specific SnackBar messages for authentication errors, Firestore errors, and network-related issues.

## License

This project is licensed under the MIT License.

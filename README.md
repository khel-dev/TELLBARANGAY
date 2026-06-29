# TellBarangay

TellBarangay is a Flutter mobile application for barangay request and complaint management. It helps citizens submit concerns, request barangay documents or assistance, track their submissions, and view announcements. Barangay officials can review reports, process requests, post announcements, and monitor basic analytics.

## Purpose

This app is designed as a community care system for faster communication between residents and barangay officials.

Main users:

- Citizens who need to report concerns or request barangay services
- Barangay officials who manage reports, requests, and announcements

## Features

### Citizen Side

- Landing page with barangay branding
- Login and registration
- Citizen account registration
- Report a concern or complaint
- Submit barangay service requests
- Track submitted reports and requests
- View barangay announcements
- View and update profile information

### Barangay Official Side

- Official account registration
- Role-based login redirect
- Official dashboard
- View received reports
- Update report status: Pending, In Progress, Solved
- View service requests
- Approve or reject requests
- Create and manage announcements
- View analytics summary

## Request Types

Citizens can submit requests for:

- Barangay Clearance
- Certification
- Barangay ID
- Permit Request
- Request for Assistance
- Other barangay requests

## Complaint / Report Categories

Citizens can report concerns such as:

- Garbage
- Noise
- Water
- Safety
- Road damage
- Illegal activities
- Other community issues

## Tech Stack

| Area | Technology |
| --- | --- |
| Framework | Flutter |
| Language | Dart |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| File Storage | Firebase Storage |
| Notifications package | Firebase Messaging |
| UI | Material Design |

## Project Structure

```text
lib/
├── main.dart
├── firebase_options.dart
├── config/
│   └── app_colors.dart
├── screens/
│   ├── landing_page.dart
│   ├── login_page.dart
│   ├── registration_page.dart
│   ├── home_page.dart
│   ├── report_page.dart
│   ├── request_page.dart
│   ├── track_page.dart
│   ├── announcements_page.dart
│   ├── profile_page.dart
│   ├── home_official_page.dart
│   ├── reports_official_page.dart
│   ├── requests_official_page.dart
│   ├── announcements_official_page.dart
│   └── analytics_official_page.dart
└── services/
    ├── auth_service.dart
    ├── database.dart
    └── data_service.dart
```

## App Routes

| Route | Screen |
| --- | --- |
| `/` | Landing page |
| `/login` | Login |
| `/register` | Citizen / official registration |
| `/home` | Citizen home dashboard |
| `/reports` | Report a concern |
| `/request` | Submit a request |
| `/track` | Track reports and requests |
| `/announcements` | Citizen announcements |
| `/profile` | Profile |
| `/official-home` | Official dashboard |
| `/official-reports` | Received reports |
| `/official-requests` | Requests to process |
| `/official-announcements` | Manage announcements |
| `/official-analytics` | Analytics |

## Firebase Collections

The Firebase service layer is prepared for these collections:

```text
users
reports
requests
announcements
notifications
```

The app uses Firebase Authentication for login and registration. User profiles are stored in Firestore with a `role` field, usually `citizen` or `official`, which controls where the user is redirected after login.

## Current Implementation Notes

- Firebase Auth and Firestore profile creation are implemented in `AuthService` and `DatabaseService`.
- Firestore report, request, announcement, notification, analytics, and storage helper methods are available in `database.dart`.
- Some citizen-side report/request tracking screens currently use `DataService`, an in-memory service for local demo data during the app session.
- File upload UI is present in request/report forms, while full file picker or camera integration can still be connected to Firebase Storage.

## Requirements

- Flutter SDK 3.9.2 or compatible
- Dart SDK included with Flutter
- Firebase project
- Android Studio, VS Code, or another Flutter-supported IDE
- Android emulator, iOS simulator, or physical device

## Setup

1. Clone the repository:

```bash
git clone https://github.com/khel-dev/tellbarangay.git
cd tellbarangay
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure Firebase:

```bash
flutterfire configure
```

This generates or updates:

```text
lib/firebase_options.dart
```

4. Enable Firebase services:

- Email/password sign-in in Firebase Authentication
- Cloud Firestore
- Firebase Storage if file upload will be used

5. Run the app:

```bash
flutter run
```

## Useful Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk
```

## Status

TellBarangay is a Flutter barangay request and complaint management app with citizen and official workflows. Core screens, routing, authentication, and Firebase service structure are already in place.

## License

Private project. All rights reserved.

# Barterhood

Trade clutter for useful items — a Flutter app to list, browse, and barter items locally.

**Table of Contents**

- **Overview:** What Barterhood is and who it's for.
- **Features:** Key user-facing capabilities.
- **Tech Stack:** Libraries and services used.
- **Architecture:** Project layout in this monorepo.
- **Getting Started:** Local setup and run instructions.
- **Testing & CI:** How to run tests and CI checks.
- **Contributing:** How to help.

**Overview**

- **Purpose:** Enable users to list items they no longer need and arrange trades with others.
- **Audience:** Mobile users looking to swap items instead of discarding them.

**Features**

- **Authentication:** Firebase Auth (email, social providers).
- **User Profile:** Profile picture, display name, optional nickname, basic location.
- **Browse Items:** Infinite scroll of available barter items with local caching/offline support.
- **List Items:** Upload photos, title, description, condition, and desired trade terms.
- **Barter Flow:** Start or accept trade requests and message interested users (in-app or external).

**Tech Stack**

- **Frontend:** Flutter
- **Auth / Realtime:** Firebase (Auth, optional Realtime/Firestore)
- **Backend / Storage:** Supabase (optional services) and platform APIs
- **Monorepo tooling:** melos (packages are under `/packages` and apps under `/apps`)

**Architecture**

- **Monorepo layout:** This project lives in a mono repo. Relevant folders:
  - `apps/barterhood` — Flutter app (this folder)
  - `packages/core` — shared domain, value objects, and utilities
  - `packages/widgets` — reusable UI widgets
- **Domain structure (example):**
  - `lib/features/` — feature modules (e.g., `auth`, `items`, `barter`)
  - Each feature contains `presentation/`, `application/`, `domain/`, `infrastructure/` layers

**Getting Started (Local)**
Prerequisites:

- Install Flutter (stable) — <https://flutter.dev/docs/get-started/install>
- Install `melos` if you use the monorepo tooling: `dart pub global activate melos` (optional)

Clone and prepare:

```bash
git clone <repo-url>
cd <repo-root>
# If using melos
melos bootstrap
flutter pub get
```

Platform setup:

- Android: ensure Android SDK, emulator or device available.
- iOS: open `ios/Runner.xcworkspace` and set signing in Xcode; macOS required.

Environment configuration:

- Firebase: configure a Firebase project and add the generated `GoogleService-Info.plist` (iOS) and `google-services.json` (Android) into the platform-specific folders.
- Supabase: set the `SUPABASE_URL` and `SUPABASE_KEY` in your environment or `.env` used by the app.

Run the app:

```bash
# For Android
flutter run -d emulator-5554

# For iOS (device or simulator)
flutter run -d <device-id>
```

**Testing & CI**

- Unit and widget tests live under `test/` in each package and app.
- Run tests for the app:

```bash
flutter test
```

- CI should run unit and integration tests and static analysis (`flutter analyze`, `dart format --set-exit-if-changed`).

**Contributing**

- Fork the repo, create a feature branch, follow the repo's linting and testing rules, then open a PR.
- Keep changes small and add tests for new features.

**Troubleshooting**

- Missing Firebase files: ensure `GoogleService-Info.plist` / `google-services.json` are placed and ignored by git.
- Flutter SDK mismatch: run `flutter doctor` and fix any platform issues.

**Next steps**

- Add screenshots and a short demo GIF to this README.
- Document the environment variables and exact Firebase setup (project, auth providers).

---

If you'd like, I can commit this change, add screenshots, or generate an example `.env` and setup instructions for Firebase/Supabase.

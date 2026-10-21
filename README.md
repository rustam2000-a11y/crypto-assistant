# Crypto Assistant

A Flutter mobile app for tracking cryptocurrencies (quotes, charts), managing favorites/portfolio ("briefcase"), and chatting with an AI assistant. Backend is Firebase (Auth, Firestore, Storage); quotes come from the CoinGecko API.

## Tech stack

- **Flutter** 3.35.4 (managed via [FVM](https://fvm.app)), Dart SDK `^3.9.0`
- **State management**: `flutter_bloc`, `provider`
- **DI**: `get_it` + `injectable` (code generated via `build_runner`)
- **Backend**: Firebase (`firebase_auth`, `cloud_firestore`, `firebase_storage`), Google/Apple Sign-In
- **Crypto data**: CoinGecko REST API (`http`), charts via `fl_chart`
- **Localization**: `flutter_localizations` + `intl_utils` (en/ru)

## Requirements

- Flutter 3.35.4 — installing via [FVM](https://fvm.app) is recommended; the version is already pinned in `.fvmrc`
- Xcode + CocoaPods (for iOS builds)
- Android Studio / Android SDK (for Android builds), Java 11
- A Firebase account with access to the project (the `google-services.json` and `GoogleService-Info.plist` configs are already in the repository, no extra setup needed)

## Installation

1. Install FVM (if not installed yet):
   ```bash
   dart pub global activate fvm
   ```

2. Install the project's Flutter version:
   ```bash
   fvm install
   ```

3. Install dependencies:
   ```bash
   fvm flutter pub get
   ```

4. Create a `.env` file in the project root (it is not tracked in git) and fill in the variables:
   ```env
   GEMINI_API_KEY=your_gemini_api_key
   ```
   Ask your team lead for the key or get it from the internal secrets storage.

5. For iOS, also install the pods:
   ```bash
   cd ios && pod install && cd ..
   ```

## Code generation

The project uses code generation for DI (`injectable`) and localization (`intl_utils`). Generated files are already committed, but they must be regenerated after changing `@injectable` classes or `.arb` files:

```bash
# DI (get_it/injectable)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# or in watch mode
fvm flutter pub run build_runner watch --delete-conflicting-outputs

# localization (after editing lib/l10n/*.arb)
fvm flutter pub run intl_utils:generate
```

## Running

List available devices/emulators:
```bash
fvm flutter devices
```

Run the app:
```bash
fvm flutter run
```

Run on a specific platform:
```bash
fvm flutter run -d ios
fvm flutter run -d android
fvm flutter run -d chrome   # web
fvm flutter run -d macos    # desktop
```

## Tests and lint

```bash
fvm flutter analyze   # static analysis
fvm flutter test      # unit/widget tests
```

## Release build

```bash
fvm flutter build apk --release        # Android APK
fvm flutter build appbundle --release  # Android App Bundle (Google Play)
fvm flutter build ios --release        # iOS (then archive via Xcode)
```

## Project structure

Features are organized into folders under `lib/`, each with its own `bloc`/`data`/`domain`/`widget`:

```
lib/
├── assistant/     # AI assistant
├── briefcase/     # user portfolio
├── coin_card/     # coin details card
├── core/          # shared UI components, models, responsiveness (UiProvider)
├── generated/     # generated localization files
├── home/          # home screen, API access, languages
├── l10n/          # .arb localization files (en/ru)
├── navigation/    # navigation/bottom bar
├── presentation/  # shared constants (colors, images)
├── registration/  # sign-up/login
├── injection.dart # get_it/injectable setup
└── main.dart      # entry point
```

## Environment variables

| Variable         | Purpose                              |
|------------------|--------------------------------------|
| `GEMINI_API_KEY` | Key for the AI assistant (Gemini)    |

The `.env` file must not be committed to git — keep your keys local.

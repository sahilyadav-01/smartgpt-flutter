# SmartGPT

A Flutter chat application inspired by ChatGPT-style experiences.

> **Note:** This README is designed as a “premiere look” (clean, helpful, and placeholder-friendly). You can later align the exact details (env var names, model defaults, etc.) with the code.

---

## Features

- **Chat UI** with message streaming/updates (if enabled in code)
- **Chat history** (saved locally/in-app)
- **Authentication** screens (login/register/forgot password)
- **OpenAI integration** for generating responses
- **Markdown rendering** for formatted responses

---

## Tech Stack

- Flutter
- Dart
- OpenAI API (via a service layer)

---

## Getting Started

### 1) Prerequisites

- Flutter installed
- A working Flutter development environment (Android Studio / Xcode / VS Code)

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Configure API credentials

Open the secrets/config file used by the app (commonly something like `lib/config/secrets.dart`) and set your OpenAI API key.

> Keep API keys out of git. Use local/ignored configuration files or environment-based secrets.

### 4) Run the app

```bash
flutter run
```

---

## Project Structure (high level)

- `lib/features/` — UI + feature logic (auth, chat)
- `lib/services/` — API/service layer (OpenAI, auth, chat history)
- `lib/widgets/` — reusable UI widgets (e.g., markdown message widget)
- `lib/models/` — data models
- `lib/config/` — configuration/secrets

---

## Usage

1. Launch the app
2. Sign in / create an account (if auth is enabled)
3. Start chatting
4. View past conversations (if history is enabled)

---

## Screenshots

_Add screenshots here once available:*

- Home / Chat screen
- Authentication screen
- Example prompt + response (markdown)

---

## Troubleshooting

- **API key errors**: verify the key is set in the correct config file
- **Network issues**: ensure device/emulator has internet access
- **Android/iOS build**: follow Flutter’s standard setup for the target platform

---

## License

_MIT / Apache-2.0 / proprietary (add your license here)_


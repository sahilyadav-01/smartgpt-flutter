# smartgpt-flutter TODO

## Step 1: Confirm requirements & MVP scope
- [ ] Decide exact MVP: auth (guest/login/google) + chat (streaming + markdown) + conversation list + settings (theme/model/language).
- [ ] Decide state management choice: Riverpod vs BLoC (default: Riverpod).
- [ ] Decide backend approach for OpenAI key safety (Firebase Functions / Express proxy).

## Step 2: Create Flutter project scaffolding (code from scratch)
- [ ] Create Flutter project in this repo.
- [ ] Add routing, theming, and base layout.
- [ ] Add Riverpod providers structure.

## Step 3: Add Firebase project wiring (auth + firestore + storage)
- [ ] Add firebase_core + firebase_auth + cloud_firestore + firebase_storage.
- [ ] Configure Android/iOS Firebase config.
- [ ] Implement auth flows: email/password, Google sign-in, guest mode.

## Step 4: Implement chat domain
- [ ] Data models: User, Conversation, Message.
- [ ] Firestore repositories for conversations/messages.
- [ ] Chat UI: message list, composer, send button.

## Step 5: Implement OpenAI integration via backend proxy
- [ ] Create backend (Node/Express or Firebase Functions) to call OpenAI.
- [ ] Implement streaming endpoint and rate limiting.
- [ ] Add Flutter API client for streaming responses.

## Step 6: Streaming + markdown + code highlighting
- [ ] Render markdown messages.
- [ ] Add code highlighting for fenced blocks.
- [ ] Implement smooth streaming text updates.

## Step 7: Smart features (iterate)
- [ ] Voice-to-text (speech_to_text) and TTS (flutter_tts).
- [ ] File upload (firebase_storage) + prompt attachment handling.
- [ ] PDF reader integration.
- [ ] Copy/share message actions.

## Step 8: Settings & preferences
- [ ] Theme dark/light.
- [ ] Model selector.
- [ ] Language selector.
- [ ] Clear history.
- [ ] Account management (logout, delete account).

## Step 9: Optimization & hardening
- [ ] Loading/error states.
- [ ] Caching where needed.
- [ ] Security rules for Firestore/Storage.
- [ ] Basic analytics.

## Step 10: Testing & build
- [ ] Unit tests for providers/repositories.
- [ ] Basic integration testing.
- [ ] Android release build (signed APK/AAB).
- [ ] iOS TestFlight build.

## Step 11: Deployment checklist
- [ ] App icons, splash screens.
- [ ] Privacy policy links.
- [ ] Verify streaming works in release builds.


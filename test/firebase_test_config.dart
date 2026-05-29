import 'package:firebase_core/firebase_core.dart';

/// Ensures Firebase is initialized in widget tests.
///
/// WARNING: This is only for local/widget testing.
Future<void> ensureFirebaseInitializedForTests() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'features/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SmartGPTApp());
}

class SmartGPTApp extends StatelessWidget {
  const SmartGPTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartGPT',
      theme: AppTheme.darkTheme(),
      home: const SplashScreen(),
      onGenerateRoute: AppRoutes.generate,
    );
  }
}


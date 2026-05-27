import 'package:flutter/material.dart';
import '../features/auth/forgot_password.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/chat/chat_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String chat = '/chat';

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case splash:
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}

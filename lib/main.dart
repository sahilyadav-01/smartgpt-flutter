import 'package:flutter/material.dart';

void main() {
  runApp(const SmartGPTApp());
}

class SmartGPTApp extends StatelessWidget {
  const SmartGPTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartGPT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SafeArea(
        child: Center(
          child: Text(
            'SmartGPT app skeleton ready. Next: auth + chat UI.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}


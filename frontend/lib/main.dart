import 'package:flutter/material.dart';
import 'package:ecommerce_app/getStarted.dart';
import 'package:ecommerce_app/theme_provider.dart'; // <-- Add this line

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentTheme,
          home: const GetStartedPage(),
        );
      },
    );
  }
}
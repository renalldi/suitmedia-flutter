import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'views/first_screen.dart';
import 'views/second_screen.dart';
import 'views/third_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Palindrome App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const FirstScreen(),
        routes: {
          '/second': (context) => const SecondScreen(),
          '/third': (context) => const ThirdScreen(),
        },
      ),
    );
  }
}

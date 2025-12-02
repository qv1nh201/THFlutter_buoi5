// file: lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Đảm bảo đã chạy flutterfire configure
import 'screens/home_screen.dart'; // Import màn hình chính

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sổ Tay Nấu Ăn',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      // LƯU Ý: MaterialApp dùng 'home', KHÔNG dùng 'body'
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
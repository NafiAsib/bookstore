import 'package:bookstore/firebase_options.dart';
import 'package:bookstore/presentation/Signin/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      title: 'Bookstore',
      theme: ThemeData(
        fontFamily: 'WorkSans',
        scaffoldBackgroundColor: const Color(0xFFE4F9F5),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Signin(),
    );
  }
}

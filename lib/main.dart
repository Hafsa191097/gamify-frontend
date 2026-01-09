import 'package:flutter/material.dart';
import 'package:gamify/screens/auth/login.dart';
import 'package:gamify/screens/auth/onboarding.dart';
import 'package:gamify/screens/auth/signup.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';
import 'screens/book_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Book App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2D3142),
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D3142),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/welcome',
      getPages: [
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/book-detail', page: () => const BookDetailScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/favorites', page: () => const FavoritesScreen()),
      ],
    );
  }
}

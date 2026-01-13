import 'package:flutter/material.dart';
import 'package:gamify/config.dart';
import 'package:gamify/screens/auth/login.dart';
import 'package:gamify/screens/auth/onboarding.dart';
import 'package:gamify/screens/auth/signup.dart';
import 'package:gamify/screens/home_screen.dart';
import 'package:gamify/screens/profile_screen.dart';
import 'package:gamify/screens/favorites_screen.dart';
import 'package:gamify/services/token.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvironmentConfig.load();
  print('🌐 API Base URL: ${EnvironmentConfig.baseUrl}');
  print('🔧 Environment: ${EnvironmentConfig.environment}');
  Get.put(TokenService());

  // ✅ Check if user is authenticated
  final tokenService = Get.find<TokenService>();
  final isAuthenticated = tokenService.isAuthenticated();

  runApp(BookApp(isAuthenticated: isAuthenticated));
}

class BookApp extends StatelessWidget {
  final bool isAuthenticated;

  const BookApp({Key? key, required this.isAuthenticated}) : super(key: key);

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
      // ✅ Dynamic initial route based on authentication
      initialRoute: isAuthenticated ? '/' : '/welcome',
      getPages: [
        // Welcome screen - shown only first time (no token)
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),

        // Auth screens - for login/signup
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),

        // Protected screens - require authentication
        GetPage(name: '/', page: () => const HomeScreen()),
        // GetPage(name: '/book-detail', page: () => const BookDetailScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/favorites', page: () => const FavoritesScreen()),
      ],
    );
  }
}

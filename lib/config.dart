import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  static Future<void> load() async {
    await dotenv.load(fileName: '.env.dev');
    print('✅ Environment variables loaded');
  }

  // API Configuration
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 
        'https://annett-stereoscopic-xavi.ngrok-free.dev';
  }

  static int get apiTimeout {
    return int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30') ?? 30;
  }

  // Environment
  static String get environment {
    return dotenv.env['ENVIRONMENT'] ?? 'development';
  }

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  // Logging
  static String get logLevel {
    return dotenv.env['LOG_LEVEL'] ?? 'debug';
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mye_commerce/local_db/auth_services.dart';
import 'package:mye_commerce/presentation/intro/ui/screen/intro_screen.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthServices.init();
  try {
    // 1. Load Base url
    await dotenv.load(fileName: ".env");

    // 2. CHECK IF KEY LOADED AND PRINT TO TERMINAL
    final baseUrl = dotenv.env['BASE_URL'];

    if (baseUrl != null && baseUrl.isNotEmpty) {
      print("==========================================");
      print("✅ SUCCESS: .env file loaded successfully!");
      // Print just the first 3 characters for security
      print(" baseUrl found, starts with: ${baseUrl.length >= 3 ? baseUrl.substring(0, 3) : baseUrl}");
      print("==========================================");
    } else {
      print("==========================================");
      print("❌ ERROR: .env file loaded, but baseUrl is empty!");
      print("==========================================");
    }
  } catch (e) {
    print("==========================================");
    print("🛑 CRITICAL ERROR: Could not load .env file!");
    print("Error details: $e");
    print("==========================================");
  }

  runApp(const MyApp(
    home: IntroScreen(),
  ));
}

// lib/config/app_config.dart

class AppConfig {
  // ✅ Toggle this flag to switch between local and production
  static const bool isProduction = true;

  // ✅ Base URLs
  static const String devBaseUrl = 'http://10.0.2.2:8000/api/';
  static const String prodBaseUrl = 'https://afgnetworkapp-3.onrender.com/'; // 🔁 Replace with your real Render.com URL

  // ✅ Use correct base URL based on current mode
  static String get baseUrl => isProduction ? prodBaseUrl : devBaseUrl;
}

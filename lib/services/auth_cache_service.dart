import 'package:flutter/foundation.dart';

/// Service to handle persistent authentication data.
/// TODO: Integrate shared_preferences or flutter_secure_storage for real persistence.
class AuthCacheService {
  static String? _token;

  /// Sets the authentication token.
  static Future<void> setToken(String token) async {
    _token = token;
    debugPrint('🔐 Token cached in memory');
  }

  /// Retrieves the cached authentication token.
  static Future<String?> getToken() async {
    return _token;
  }

  /// Clears the cached authentication data.
  static Future<void> clearAuth() async {
    _token = null;
    debugPrint('🔐 Auth data cleared');
  }

  /// Checks if a user is currently authenticated.
  static Future<bool> isAuthenticated() async {
    return _token != null;
  }
}

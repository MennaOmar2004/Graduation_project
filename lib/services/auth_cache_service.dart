import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle persistent authentication data.
class AuthCacheService {
  static String? _token;

  /// Sets the authentication token.
  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    // Assuming child_token is the primary for app interaction if set manually here
    await prefs.setString("child_token", token);
    debugPrint('🔐 Token cached in memory and shared_preferences');
  }

  /// Retrieves the cached authentication token.
  static Future<String?> getToken() async {
    if (_token != null) return _token;
    
    final prefs = await SharedPreferences.getInstance();
    final childToken = prefs.getString("child_token");
    final parentToken = prefs.getString("parent_token");
    
    return childToken ?? parentToken;
  }

  /// Clears the cached authentication data.
  static Future<void> clearAuth() async {
    _token = null;
    debugPrint('🔐 Auth data cleared');
  }

  /// Checks if a user is currently authenticated.
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTokenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static const String _tokenKey = 'auth_token';
  static const String _adminKey = 'is_admin';
  static const String _emailKey = 'user_email';

  Future<void> saveUserToken(String token,
      {bool isAdmin = false, String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool(_adminKey, isAdmin);
    if (email != null) {
      await prefs.setString(_emailKey, email);
    }
  }

  Future<bool> getAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adminKey) ?? false;
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_adminKey);
    await prefs.remove(_emailKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getUserToken();
    return token != null;
  }
}

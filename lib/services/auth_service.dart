import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

class AuthService {
  static Future<bool> register(
      String username, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _getUsers(prefs);
    if (users.any((u) => u['email'] == email)) return false;

    users.add({
      'username': username,
      'email': email,
      'password': password,
      'role': 'user',
    });
    await prefs.setString('users', jsonEncode(users));
    return true;
  }

  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _getUsers(prefs);
    final user = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );
    if (user.isEmpty) return false;
    await StorageService.saveUser(user);
    return true;
  }

  static List<Map<String, dynamic>> _getUsers(SharedPreferences prefs) {
    final raw = prefs.getString('users');
    if (raw == null) {
      final seeded = [
        {
          'username': 'admin',
          'email': 'admin@travelbuddy.com',
          'password': 'admin123',
          'role': 'admin',
        }
      ];
      prefs.setString('users', jsonEncode(seeded));
      return seeded;
    }
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }
}
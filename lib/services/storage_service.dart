import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static Map<String, dynamic>? currentUser;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final userJson = _prefs.getString('currentUser');
    if (userJson != null) currentUser = jsonDecode(userJson);
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    currentUser = user;
    await _prefs.setString('currentUser', jsonEncode(user));
  }

  static Future<void> logout() async {
    currentUser = null;
    await _prefs.remove('currentUser');
  }

  static bool get isAdmin => currentUser?['role'] == 'admin';

  // ===== DESTINATIONS =====
  static List<Destination> getDestinations() {
    final raw = _prefs.getString('destinations');
    if (raw == null) {
      final seeded = Destination.seed();
      _prefs.setString(
          'destinations', jsonEncode(seeded.map((d) => d.toMap()).toList()));
      return seeded;
    }
    final list = jsonDecode(raw) as List;
    return list.map((m) => Destination.fromMap(m)).toList();
  }

  static Future<void> saveDestinations(List<Destination> list) async {
    await _prefs.setString(
        'destinations', jsonEncode(list.map((d) => d.toMap()).toList()));
  }

  // ===== CHECKLIST =====
  static List<Map<String, dynamic>> getChecklist(int destId) {
    final raw = _prefs.getString('checklist_$destId');
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  static Future<void> saveChecklist(
      int destId, List<Map<String, dynamic>> items) async {
    await _prefs.setString('checklist_$destId', jsonEncode(items));
  }

  // ===== JOURNAL =====
  static List<Map<String, dynamic>> getJournal(int destId) {
    final raw = _prefs.getString('journal_$destId');
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  static Future<void> saveJournal(
      int destId, List<Map<String, dynamic>> entries) async {
    await _prefs.setString('journal_$destId', jsonEncode(entries));
  }

  // ===== USERS (for admin panel) =====
  static List<Map<String, dynamic>> getAllUsers() {
    final raw = _prefs.getString('users');
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  static Future<void> deleteUser(String email) async {
    final users = getAllUsers();
    users.removeWhere((u) => u['email'] == email && u['role'] != 'admin');
    await _prefs.setString('users', jsonEncode(users));
  }
}
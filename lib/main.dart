import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'screens/login_screen.dart';
import 'screens/destinations_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const TravelBuddyApp());
}

class TravelBuddyApp extends StatelessWidget {
  const TravelBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = StorageService.currentUser;

    Widget home;
    if (user == null) {
      home = const LoginScreen();
    } else if (user['role'] == 'admin') {
      home = const AdminDashboardScreen();
    } else {
      home = const DestinationsScreen();
    }

    return MaterialApp(
      title: 'Travel Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: home,
    );
  }
}
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'destinations_screen.dart';
import 'admin_destinations_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<Map<String, dynamic>> _users = [];
  int _placesCount = 0;
  String _username = 'Admin';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _users = StorageService.getAllUsers();
      _placesCount = StorageService.getDestinations().length;
      _username = StorageService.currentUser?['username'] ?? 'Admin';
    });
  }

  Future<void> _deleteUser(String email) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete User?'),
        content: Text('Permanently delete $email?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StorageService.deleteUser(email);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalUsers = _users.where((u) => u['role'] == 'user').length;
    final totalAdmins = _users.where((u) => u['role'] == 'admin').length;

    return Scaffold(
      body: Container(
        decoration: AppTheme.bgGradient,
        child: SafeArea(
          child: Column(
            children: [
              // ===== TOP BAR =====
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    // ===== LOGO =====
                    Image.asset(
                      'assets/travel_buddy.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 10),
                    const Text('Admin Panel',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20)),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        await StorageService.logout();
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ===== CONTENT =====
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Greeting
                    Text('Hey, $_username! 🛡️',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800)),
                    const Text('Manage users and destinations',
                        style: TextStyle(color: Colors.white70)),

                    const SizedBox(height: 20),

                    // ===== STATS =====
                    Row(
                      children: [
                        Expanded(
                            child: _statCard('$totalUsers', 'Users',
                                AppColors.blue)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _statCard('$totalAdmins', 'Admins',
                                AppColors.coral)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _statCard('$_placesCount', 'Places',
                                AppColors.purple)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ===== QUICK ACTIONS =====
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('⚡ Quick Actions',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const DestinationsScreen()),
                                  ).then((_) => _load()),
                                  icon: const Icon(Icons.public, size: 18),
                                  label: const Text('Open Gallery'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const AdminDestinationsScreen()),
                                  ).then((_) => _load()),
                                  icon: const Icon(Icons.settings, size: 18),
                                  label: const Text('Manage'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== USER LIST =====
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('👥 All Users',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink)),
                          const SizedBox(height: 12),
                          ..._users.map((u) {
                            final isAdmin = u['role'] == 'admin';
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isAdmin
                                    ? AppColors.coral.withOpacity(0.08)
                                    : Colors.grey.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isAdmin
                                        ? AppColors.coral
                                        : AppColors.blue,
                                    child: Text(
                                      (u['username'] ?? '?')
                                          .toString()[0]
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(u['username'] ?? 'Unknown',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14)),
                                        Text(u['email'] ?? '',
                                            style: const TextStyle(
                                                color: AppColors.muted,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  if (isAdmin)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.coral,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Text('ADMIN',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800)),
                                    )
                                  else
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red, size: 20),
                                      onPressed: () =>
                                          _deleteUser(u['email']),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 12)),
          ],
        ),
      );
}
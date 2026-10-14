import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'destination_detail_screen.dart';
import 'budget_screen.dart';
import 'admin_destinations_screen.dart';
import 'admin_dashboard_screen.dart';
import 'login_screen.dart';

class DestinationsScreen extends StatefulWidget {
  const DestinationsScreen({super.key});
  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  final _search = TextEditingController();
  List _all = [];
  bool _isAdmin = false;
  String _username = 'Traveler';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _all = StorageService.getDestinations();
      _isAdmin = StorageService.isAdmin;
      _username = StorageService.currentUser?['username'] ?? 'Traveler';
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.toLowerCase();
    final filtered = _all
        .where((d) =>
            d.name.toLowerCase().contains(query) ||
            d.province.toLowerCase().contains(query))
        .toList();

    return Scaffold(
      body: Container(
        decoration: AppTheme.bgGradient,
        child: SafeArea(
          child: Column(
            children: [
              // ===== HEADER =====
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // ===== LOGO =====
                        Image.asset(
                          'assets/travel_buddy.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        const Text('Travel Buddy',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18)),
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
                    const SizedBox(height: 12),
                    Text('Hey, $_username! ✈️',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800)),
                    const Text('Where would you like to explore?',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _quickBtn(
                          icon: Icons.attach_money,
                          label: 'Budget Matcher',
                          color: AppColors.coral,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const BudgetScreen()),
                          ).then((_) => _refresh()),
                        ),
                        if (_isAdmin) ...[
                          _quickBtn(
                            icon: Icons.settings,
                            label: 'Manage',
                            color: AppColors.purple,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const AdminDestinationsScreen()),
                            ).then((_) => _refresh()),
                          ),
                          _quickBtn(
                            icon: Icons.shield,
                            label: 'Admin Panel',
                            color: AppColors.purpleDark,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const AdminDashboardScreen()),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search destinations...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ===== GALLERY =====
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('No destinations found',
                            style: TextStyle(color: Colors.white)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final d = filtered[i];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DestinationDetailScreen(destination: d),
                              ),
                            ).then((_) => _refresh()),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(24)),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: d.imageUrl,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Container(
                                              color: Colors.grey[200],
                                              height: 180),
                                          errorWidget: (_, __, ___) =>
                                              Container(
                                            height: 180,
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.image,
                                                size: 60,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              '~₱${d.estimatedBudget.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w800,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(d.name,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.ink)),
                                        const SizedBox(height: 4),
                                        Text(
                                            '📍 ${d.province} · ${d.category}',
                                            style: const TextStyle(
                                                color: AppColors.muted)),
                                        const SizedBox(height: 8),
                                        Text(
                                            '~₱${d.tripEstimate.toStringAsFixed(0)} · 3 days',
                                            style: const TextStyle(
                                                color: AppColors.coral,
                                                fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ],
          ),
        ),
      );
}
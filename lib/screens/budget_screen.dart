import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'destination_detail_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});
  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  double _budget = 10000;

  @override
  Widget build(BuildContext context) {
    final places = StorageService.getDestinations()
      ..sort((a, b) => a.tripEstimate.compareTo(b.tripEstimate));

    return Scaffold(
      body: Container(
        decoration: AppTheme.bgGradient,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white)),
                  const Text('💰 Budget Matcher',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800)),
                ]),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(children: [
                  const Text('Your Budget',
                      style: TextStyle(color: AppColors.muted)),
                  Text('₱${_budget.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: AppColors.coral)),
                  Slider(
                    value: _budget,
                    min: 3000,
                    max: 50000,
                    divisions: 94,
                    activeColor: AppColors.coral,
                    onChanged: (v) => setState(() => _budget = v),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: places.length,
                  itemBuilder: (_, i) {
                    final d = places[i];
                    final est = d.tripEstimate;
                    final fits = est <= _budget;

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                DestinationDetailScreen(destination: d)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(fits ? 1 : 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18)),
                                Text('📍 ${d.province}',
                                    style: const TextStyle(
                                        color: AppColors.muted)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₱${est.toStringAsFixed(0)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: fits
                                          ? AppColors.coral
                                          : Colors.grey)),
                              Text(fits ? '✅ Fits' : '❌ Over',
                                  style: TextStyle(
                                      color: fits
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12)),
                            ],
                          ),
                        ]),
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
}
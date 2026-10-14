import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/destination.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class DestinationDetailScreen extends StatefulWidget {
  final Destination destination;
  const DestinationDetailScreen({super.key, required this.destination});
  @override
  State<DestinationDetailScreen> createState() =>
      _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  late List<Map<String, dynamic>> _checklist;
  late List<Map<String, dynamic>> _journal;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
    _checklist = StorageService.getChecklist(widget.destination.id);
    if (_checklist.isEmpty) {
      _checklist = widget.destination.activities
          .split(',')
          .map((a) => {'name': a.trim(), 'done': false})
          .toList();
      StorageService.saveChecklist(widget.destination.id, _checklist);
    }
    _journal = StorageService.getJournal(widget.destination.id);
  }

  void _toggleItem(int i) {
    setState(() => _checklist[i]['done'] = !_checklist[i]['done']);
    StorageService.saveChecklist(widget.destination.id, _checklist);
  }

  void _addJournalEntry() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('New Journal Entry'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(hintText: 'Title')),
              const SizedBox(height: 10),
              TextField(
                  controller: contentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Content')),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (_, setD) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => IconButton(
                    onPressed: () => setD(() => rating = i + 1),
                    icon: Icon(i < rating ? Icons.star : Icons.star_border,
                        color: AppColors.gold),
                  )),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                _journal.add({
                  'title': titleCtrl.text,
                  'content': contentCtrl.text,
                  'rating': rating,
                  'date': DateTime.now().toIso8601String(),
                });
                StorageService.saveJournal(widget.destination.id, _journal);
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    return Scaffold(
      body: Container(
        decoration: AppTheme.bgGradient,
        child: SafeArea(
          child: Column(
            children: [
              Stack(children: [
                CachedNetworkImage(
                  imageUrl: d.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey[300],
                    child:
                        const Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
                ),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800)),
                      Text('📍 ${d.province}',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ]),
              TabBar(
                controller: _tab,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Activities'),
                  Tab(text: 'Journal'),
                  Tab(text: 'Details'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    _overview(d),
                    _activities(),
                    _journalTab(),
                    _details(d),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overview(Destination d) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          _glassCard(
              title: 'About ${d.name}',
              child:
                  Text(d.description, style: const TextStyle(height: 1.6))),
          _glassCard(
            title: '💸 Estimated Budget (3 days)',
            child: Column(children: [
              _costRow('✈️ Flight', '₱${d.avgFlightCost.toStringAsFixed(0)}'),
              _costRow('🏨 Hotel (3 nights)',
                  '₱${(d.avgHotelPerNight * 3).toStringAsFixed(0)}'),
              _costRow('🍽️ Food (3 days)',
                  '₱${(d.avgFoodPerDay * 3).toStringAsFixed(0)}'),
              const Divider(),
              _costRow('Total', '₱${d.tripEstimate.toStringAsFixed(0)}',
                  bold: true),
            ]),
          ),
          _glassCard(
            title: '🗺️ How to Get There',
            child: ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse(
                    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('${d.name} ${d.province}')}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url,
                      mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.map),
              label: const Text('Open in Google Maps'),
            ),
          ),
        ]),
      );

  Widget _costRow(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                  color: bold ? AppColors.coral : AppColors.ink)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                  color: bold ? AppColors.coral : AppColors.ink)),
        ]),
      );

  Widget _activities() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _glassCard(
            title: '🎯 Things to Do',
            child: Column(
              children: List.generate(_checklist.length, (i) {
                final item = _checklist[i];
                return CheckboxListTile(
                  value: item['done'],
                  onChanged: (_) => _toggleItem(i),
                  title: Text(item['name'],
                      style: TextStyle(
                          decoration: item['done']
                              ? TextDecoration.lineThrough
                              : null)),
                  activeColor: AppColors.coral,
                );
              }),
            ),
          ),
        ],
      );

  Widget _journalTab() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton.icon(
              onPressed: _addJournalEntry,
              icon: const Icon(Icons.add),
              label: const Text('Write New Entry')),
          const SizedBox(height: 16),
          ..._journal.reversed.map((j) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(
                      left: BorderSide(color: AppColors.coral, width: 5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(j['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                          5,
                          (i) => Icon(
                                i < (j['rating'] ?? 5)
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 16,
                                color: AppColors.gold,
                              )),
                    ),
                    const SizedBox(height: 8),
                    Text(j['content']),
                  ],
                ),
              )),
        ],
      );

  Widget _details(Destination d) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _glassCard(
            title: '📌 Quick Facts',
            child: Column(children: [
              _factRow('🏷️ Category', d.category),
              _factRow('🌤️ Best Time', d.bestTime),
              _factRow('📍 Province', d.province),
              _factRow('💰 Est. Budget',
                  '₱${d.estimatedBudget.toStringAsFixed(0)}'),
            ]),
          ),
          _glassCard(
            title: '🎯 Top Activities',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: d.activities
                  .split(',')
                  .map((a) => Chip(
                        label: Text(a.trim()),
                        backgroundColor:
                            AppColors.gold.withOpacity(0.3),
                      ))
                  .toList(),
            ),
          ),
        ],
      );

  Widget _factRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(color: AppColors.muted)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      );

  Widget _glassCard({required String title, required Widget child}) =>
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink)),
              const SizedBox(height: 12),
              child,
            ]),
      );
}
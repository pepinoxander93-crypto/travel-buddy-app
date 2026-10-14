import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class AdminDestinationsScreen extends StatefulWidget {
  const AdminDestinationsScreen({super.key});
  @override
  State<AdminDestinationsScreen> createState() =>
      _AdminDestinationsScreenState();
}

class _AdminDestinationsScreenState extends State<AdminDestinationsScreen> {
  late List<Destination> _places;

  @override
  void initState() {
    super.initState();
    _places = StorageService.getDestinations();
  }

  void _showForm({Destination? existing}) {
    final name = TextEditingController(text: existing?.name);
    final province = TextEditingController(text: existing?.province);
    final desc = TextEditingController(text: existing?.description);
    final image = TextEditingController(text: existing?.imageUrl);
    final category = TextEditingController(text: existing?.category);
    final bestTime = TextEditingController(text: existing?.bestTime);
    final activities = TextEditingController(text: existing?.activities);
    final flight = TextEditingController(
        text: existing?.avgFlightCost.toString() ?? '3000');
    final hotel = TextEditingController(
        text: existing?.avgHotelPerNight.toString() ?? '1500');
    final food = TextEditingController(
        text: existing?.avgFoodPerDay.toString() ?? '800');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(existing == null ? 'Add Destination' : 'Edit Destination',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(
                  controller: name,
                  decoration: const InputDecoration(hintText: 'Name')),
              const SizedBox(height: 10),
              TextField(
                  controller: province,
                  decoration: const InputDecoration(hintText: 'Province')),
              const SizedBox(height: 10),
              TextField(
                  controller: desc,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(hintText: 'Description')),
              const SizedBox(height: 10),
              TextField(
                  controller: image,
                  decoration:
                      const InputDecoration(hintText: 'Image URL')),
              const SizedBox(height: 10),
              TextField(
                  controller: category,
                  decoration:
                      const InputDecoration(hintText: 'Category')),
              const SizedBox(height: 10),
              TextField(
                  controller: bestTime,
                  decoration: const InputDecoration(
                      hintText: 'Best time to visit')),
              const SizedBox(height: 10),
              TextField(
                  controller: activities,
                  decoration: const InputDecoration(
                      hintText: 'Activities (comma-separated)')),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: flight,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(hintText: 'Flight ₱'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: hotel,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Hotel ₱'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: food,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Food ₱'),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final flightCost = double.tryParse(flight.text) ?? 0;
                    final hotelCost = double.tryParse(hotel.text) ?? 0;
                    final foodCost = double.tryParse(food.text) ?? 0;
                    final estimate =
                        flightCost + (hotelCost * 3) + (foodCost * 3);

                    final newPlace = Destination(
                      id: existing?.id ??
                          DateTime.now().millisecondsSinceEpoch,
                      name: name.text,
                      province: province.text,
                      description: desc.text,
                      imageUrl: image.text,
                      category: category.text,
                      bestTime: bestTime.text,
                      activities: activities.text,
                      avgFlightCost: flightCost,
                      avgHotelPerNight: hotelCost,
                      avgFoodPerDay: foodCost,
                      estimatedBudget: estimate,
                    );
                    setState(() {
                      if (existing == null) {
                        _places.add(newPlace);
                      } else {
                        final i = _places
                            .indexWhere((p) => p.id == existing.id);
                        if (i >= 0) _places[i] = newPlace;
                      }
                    });
                    StorageService.saveDestinations(_places);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _delete(Destination d) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Place?'),
        content: Text('Remove "${d.name}" permanently?'),
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
      setState(() => _places.removeWhere((p) => p.id == d.id));
      await StorageService.saveDestinations(_places);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text('⚙️ Manage Destinations',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: () => _showForm(),
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Place')),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _places.length,
                  itemBuilder: (_, i) {
                    final p = _places[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16)),
                              Text('${p.province} · ${p.category}',
                                  style: const TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 13)),
                              Text('~₱${p.estimatedBudget.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      color: AppColors.coral,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () => _showForm(existing: p),
                            icon: const Icon(Icons.edit,
                                color: AppColors.blue)),
                        IconButton(
                            onPressed: () => _delete(p),
                            icon: const Icon(Icons.delete,
                                color: Colors.red)),
                      ]),
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
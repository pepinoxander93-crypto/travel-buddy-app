class Destination {
  final int id;
  final String name;
  final String province;
  final String description;
  final String imageUrl;
  final String category;
  final String bestTime;
  final String activities;
  final double avgFlightCost;
  final double avgHotelPerNight;
  final double avgFoodPerDay;
  final double estimatedBudget;

  Destination({
    required this.id,
    required this.name,
    required this.province,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.bestTime,
    required this.activities,
    required this.avgFlightCost,
    required this.avgHotelPerNight,
    required this.avgFoodPerDay,
    required this.estimatedBudget,
  });

  double get tripEstimate =>
      avgFlightCost + (avgHotelPerNight * 3) + (avgFoodPerDay * 3);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'province': province,
        'description': description,
        'imageUrl': imageUrl,
        'category': category,
        'bestTime': bestTime,
        'activities': activities,
        'avgFlightCost': avgFlightCost,
        'avgHotelPerNight': avgHotelPerNight,
        'avgFoodPerDay': avgFoodPerDay,
        'estimatedBudget': estimatedBudget,
      };

  factory Destination.fromMap(Map<String, dynamic> m) => Destination(
        id: m['id'],
        name: m['name'],
        province: m['province'],
        description: m['description'],
        imageUrl: m['imageUrl'],
        category: m['category'],
        bestTime: m['bestTime'],
        activities: m['activities'],
        avgFlightCost: (m['avgFlightCost'] as num).toDouble(),
        avgHotelPerNight: (m['avgHotelPerNight'] as num).toDouble(),
        avgFoodPerDay: (m['avgFoodPerDay'] as num).toDouble(),
        estimatedBudget: (m['estimatedBudget'] as num).toDouble(),
      );

  static List<Destination> seed() => [
        Destination(
          id: 1,
          name: 'Boracay',
          province: 'Aklan',
          description:
              'World-famous white sand beach with vibrant nightlife and crystal-clear waters. Perfect for island hopping, parasailing, and sunset sailing.',
          imageUrl:
              'https://images.unsplash.com/photo-1518509562904-e7ef99cdcc86?w=800',
          category: 'Beach',
          bestTime: 'November to May',
          activities:
              'Island Hopping, Parasailing, Sunset Sailing, Scuba Diving',
          avgFlightCost: 3500,
          avgHotelPerNight: 2500,
          avgFoodPerDay: 1000,
          estimatedBudget: 14000,
        ),
        Destination(
          id: 2,
          name: 'Siargao',
          province: 'Surigao del Norte',
          description:
              'The surfing capital of the Philippines. Home to Cloud 9 and stunning lagoons.',
          imageUrl:
              'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=800',
          category: 'Island',
          bestTime: 'August to November',
          activities: 'Surfing, Island Hopping, Lagoon Tours, Motorbike Rental',
          avgFlightCost: 4500,
          avgHotelPerNight: 1800,
          avgFoodPerDay: 900,
          estimatedBudget: 12600,
        ),
        Destination(
          id: 3,
          name: 'Baguio',
          province: 'Benguet',
          description:
              'Summer Capital of the Philippines. Cool mountain air and pine trees.',
          imageUrl:
              'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?w=800',
          category: 'Mountain',
          bestTime: 'December to February',
          activities:
              'Burnham Park, Mines View, Strawberry Picking, Night Market',
          avgFlightCost: 2000,
          avgHotelPerNight: 1500,
          avgFoodPerDay: 700,
          estimatedBudget: 8600,
        ),
        Destination(
          id: 4,
          name: 'Palawan',
          province: 'Mimaropa',
          description:
              'Home to the Underground River, El Nido, and Coron. Voted one of the best islands in the world.',
          imageUrl:
              'https://images.unsplash.com/photo-1518509562904-e7ef99cdcc86?w=800',
          category: 'Beach',
          bestTime: 'March to May',
          activities: 'Underground River, Island Hopping, Wreck Diving',
          avgFlightCost: 5000,
          avgHotelPerNight: 2500,
          avgFoodPerDay: 1200,
          estimatedBudget: 16100,
        ),
        Destination(
          id: 5,
          name: 'Aklan',
          province: 'Western Visayas',
          description:
              'Beyond Boracay — the Ati-Atihan Festival and pristine rivers.',
          imageUrl:
              'https://images.unsplash.com/photo-1505228395891-9a51e7e86bf6?w=800',
          category: 'Cultural',
          bestTime: 'January (Ati-Atihan)',
          activities:
              'Ati-Atihan Festival, Kalibo Cathedral, Mangrove Tour',
          avgFlightCost: 3500,
          avgHotelPerNight: 1800,
          avgFoodPerDay: 800,
          estimatedBudget: 11300,
        ),
      ];
}
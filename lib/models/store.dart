class Store {
  final String id;
  final String name;
  final String category;
  final String assetImage; // Renaming for asset-first merchant strategy
  final String rating;
  final int reviewCount;
  final String deliveryTime;
  final String distance;
  final String location;
  final String description;
  final double deliveryFee;
  final bool isOpen;

  const Store({
    required this.id,
    required this.name,
    required this.category,
    required this.assetImage,
    this.rating = '4.5',
    this.reviewCount = 120,
    this.deliveryTime = '25-30 min',
    this.distance = '1.2 km',
    this.location = '123 Market Street, City Center',
    this.description = 'We serve the best gourmet meals with fresh local ingredients. Taste the difference in every bite.',
    this.deliveryFee = 2.50,
    this.isOpen = true,
  });
}

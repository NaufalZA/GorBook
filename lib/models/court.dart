class Court {
  final String id;
  final String name;
  final String type;
  final int price;
  final bool isAvailable;
  final double rating;
  final int reviewCount;

  Court({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
  });
}
class Gift {
  String? id;
  final String name;
  String? description;
  final String category;
  final double price;
  String? imageUrl;
  GiftStatus status;
  final String eventId;

  Gift({
    this.id,
    required this.name,
    this.description,
    required this.category,
    required this.price,
    this.imageUrl,
    this.status = GiftStatus.available,
    required this.eventId,
  });
}

enum GiftStatus { available, pledged }

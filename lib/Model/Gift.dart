class Gift {
  int? id;
  final String name;
  String? description;
  final String category;
  final double price;
  String? imageUrl;
  String status;
  final int eventId;
  final int isPublished;

  Gift(
      {this.id,
      required this.name,
      this.description,
      required this.category,
      required this.price,
      this.imageUrl,
      required this.status,
      required this.eventId,
      required this.isPublished});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'status': status,
      'eventId': eventId,
      'isPublished': isPublished,
    };
  }

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        category: json['category'],
        price: json['price'].toDouble(),
        imageUrl: json['imageUrl'],
        status: json['status'] ?? 'available',
        eventId: json['eventId'],
        isPublished: json['isPublished']);
  }
}

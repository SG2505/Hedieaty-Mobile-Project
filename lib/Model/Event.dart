class Event {
  int? id;
  final String? name;
  final DateTime date;
  String? location;
  String? description;
  String? category;
  final String? userId;
  String? status;
  final int isPublished;

  Event({
    this.id,
    required this.name,
    required this.date,
    this.location,
    this.description,
    required this.category,
    required this.userId,
    required this.status,
    required this.isPublished,
  });

  // Convert Event to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
      'category': category,
      'userId': userId,
      'status': status,
      'isPublished': isPublished == false ? 0 : 1,
    };
  }

  // Create Event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      name: json['name'] ?? "lol",
      date: DateTime.parse(json['date']),
      location: json['location'] ?? "loc",
      description: json['description'] ?? "desc",
      category: json['category'] ?? "cat",
      userId: json['userId'] ?? "usrId",
      status: json['status'] ?? 'completed',
      isPublished: json['isPublished'],
    );
  }
}

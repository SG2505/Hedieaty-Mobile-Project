class Event {
  String? id;
  final String name;
  final DateTime date;
  String? location;
  String? description;
  final String userId;
  EventStatus status;

  Event({
    this.id,
    required this.name,
    required this.date,
    this.location,
    this.description,
    required this.userId,
    this.status = EventStatus.upcoming,
  });
}

enum EventStatus { upcoming, current, past }

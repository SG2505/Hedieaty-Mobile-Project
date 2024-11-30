class AppUser {
  String? id; // Firebase Document ID
  final String name;
  final String email;
  final String phoneNumber;
  String? profilePictureUrl;
  Map<String, dynamic>? preferences;

  AppUser({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.id,
    this.profilePictureUrl,
    this.preferences,
  });

  // Convert User object to JSON for storing in Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'preferences': preferences,
    };
  }

  // Factory constructor to create user object from Firebase document
  factory AppUser.fromJson(Map<String, dynamic> json, {String? documentId}) {
    return AppUser(
      id: documentId ?? json['id'],
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
    );
  }
}

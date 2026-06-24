class StudentModel {
  final String uid;
  final String name;
  final String email;
  final String university;
  final String bio;
  final String profileImage;
  final List<String> skills;
  final List<String> connections;
  final DateTime createdAt;

  StudentModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.university,
    required this.bio,
    required this.profileImage,
    required this.skills,
    required this.connections,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'university': university,
      'bio': bio,
      'profileImage': profileImage,
      'skills': skills,
      'connections': connections,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      university: map['university'] ?? '',
      bio: map['bio'] ?? '',
      profileImage: map['profileImage'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      connections: List<String>.from(map['connections'] ?? []),
      createdAt: DateTime.parse(
          map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
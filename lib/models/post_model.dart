class PostModel {
  final String postId;
  final String uid;
  final String userName;
  final String userImage;
  final String university;
  final String title;
  final String description;
  final List<String> skillTags;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;

  PostModel({
    required this.postId,
    required this.uid,
    required this.userName,
    required this.userImage,
    required this.university,
    required this.title,
    required this.description,
    required this.skillTags,
    required this.likes,
    required this.likedBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'userName': userName,
      'userImage': userImage,
      'university': university,
      'title': title,
      'description': description,
      'skillTags': skillTags,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] ?? '',
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'] ?? '',
      university: map['university'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      skillTags: List<String>.from(map['skillTags'] ?? []),
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      createdAt: DateTime.parse(
          map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
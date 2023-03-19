// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String userId;
  final String username;
  final String profileImg;
  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.userId,
    required this.username,
    required this.profileImg,
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? userId,
    String? username,
    String? profileImg,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profileImg: profileImg ?? this.profileImg,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'userId': userId,
      'username': username,
      'profileImg': profileImg,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      username: map['username'] as String,
      profileImg: map['profileImg'] as String,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, userId: $userId, username: $username, profileImg: $profileImg)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.userId == userId &&
        other.username == username &&
        other.profileImg == profileImg;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        postId.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        profileImg.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);
}

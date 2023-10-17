// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chat {
  final String text;
  final String imageUrl;
  final String userName;
  final String userId;
  Chat({
    required this.text,
    required this.imageUrl,
    required this.userName,
    required this.userId,
  });

  Chat copyWith({
    String? text,
    String? imageUrl,
    String? userName,
    String? userId,
  }) {
    return Chat(
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'imageUrl': imageUrl,
      'userName': userName,
      'userId': userId,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      text: map['text'] as String,
      imageUrl: map['imageUrl'] as String,
      userName: map['userName'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(text: $text, imageUrl: $imageUrl, userName: $userName, userId: $userId)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;
  
    return 
      other.text == text &&
      other.imageUrl == imageUrl &&
      other.userName == userName &&
      other.userId == userId;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      imageUrl.hashCode ^
      userName.hashCode ^
      userId.hashCode;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String password;
  final String id;
  final String photoUrl;
  final String username;
  final String bio;
  final Map followers;
  final Map following;

  const UserModel({required this.password, required this.username, required this.id, required this.photoUrl, required this.email, required this.bio, required this.followers, required this.following});

  factory UserModel.fromDocument(DocumentSnapshot document) {
    return UserModel(
      email: document['email'],
      password: document['password'],
      username: document['username'],
      photoUrl: document['photoUrl'],
      id: document.id,
      bio: document['bio'],
      followers: document['followers'],
      following: document['following'],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "username": username,
        "password": password,
        "PhotoUrl": photoUrl,
        "bio": bio,
        "Followers": followers,
        "Following": following,
      };
}

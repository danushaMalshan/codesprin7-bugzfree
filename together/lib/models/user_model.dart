import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? username;
  String? userId;
  String? email;
  String? age;
  bool isAdmin;
  String? img;
  List<dynamic> categories;

  UserModel(
     { this.id,
       this.username,
       this.userId,
       this.email,
       this.age,
       required this.isAdmin,
       this.img,required this.categories});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
        id: doc.id,
        username: data['username'],
        userId: data['user_id'],
        email: data['email'],
        age: data['age'],
        isAdmin: data['is_admin'],
        img: data['img'],categories: data['categories']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'user_id': userId,
      'email': email,
      'age': age,
      'is_admin': isAdmin,
      'img': img,
      'categories':categories
    };
  }
}

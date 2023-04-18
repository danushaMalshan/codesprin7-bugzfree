import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String username;
  String user_id;
  String email;
  String age;
  bool is_admin;
  String img;
  List<int> categories;

  UserModel(
      {required this.id,
      required this.username,
      required this.user_id,
      required this.email,
      required this.age,
      required this.is_admin,
      required this.img,required this.categories});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
        id: doc.id,
        username: data['username'],
        user_id: data['user_id'],
        email: data['email'],
        age: data['age'],
        is_admin: data['is_admin'],
        img: data['img'],categories: data['categories']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'user_id': user_id,
      'email': email,
      'age': age,
      'is_admin': is_admin,
      'img': img,
      'categories':categories
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  int id;
  String image;
  String name;
  int value;

  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
    required this.value,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return CategoryModel(
      id: data['id'],
      image: data['image'],
      name: data['name'],
      value: data['value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'value': value,
    };
  }
}

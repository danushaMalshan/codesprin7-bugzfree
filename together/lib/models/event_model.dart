import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String name;
  String organizer_id;
  String description;
  DateTime start_date;
  DateTime end_date;
  int category;
  double latitude;
  double longitude;
  String cover_image;
  List<dynamic> images;
  bool is_approve;
  String location;
  List<dynamic> tickets;

  EventModel(
      {required this.id,
      required this.name,
      required this.organizer_id,
      required this.description,
      required this.start_date,
      required this.end_date,
      required this.category,
      required this.latitude,
      required this.longitude,
      required this.cover_image,
      required this.images,
      required this.is_approve,
      required this.location,
      required this.tickets});

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return EventModel(
        id: doc.id,
        name: data['name'],
        organizer_id: data['organizer_id'],
        description: data['description'],
        start_date: (data['start_date'] as Timestamp).toDate(),
        end_date: (data['end_date'] as Timestamp).toDate(),
        category: data['category'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        cover_image: data['cover_image'],
        images: data['images'],
        is_approve: data['is_approve'],
        location: data['location'],
        tickets: data['tickets']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'organizer_id': organizer_id,
      'description': description,
      'start_date': start_date,
      'end_date': end_date,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'cover_image': cover_image,
      'images': images,
      'is_approve': is_approve,
      'location': location,
      'tickets': tickets
    };
  }
}

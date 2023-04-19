import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String? name;
  String? organizerId;
  String? description;
  DateTime startDate;
  DateTime endDate;
  int category;
  double latitude;
  double longitude;
  String? coverImage;
  List<dynamic>? images;
  bool isApprove;
  String location;
  String? ticketReservationLink;
  List<dynamic>? tickets;

  EventModel(
      {this.id,
      this.name,
      this.organizerId,
      this.description,
      required this.startDate,
      required this.endDate,
      required this.category,
      required this.latitude,
      required this.longitude,
      this.coverImage,
      this.images,
      required this.isApprove,
      required this.location,
      required this.ticketReservationLink,
      this.tickets});

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return EventModel(
        id: doc.id,
        name: data['name'],
        organizerId: data['organizer_id'],
        description: data['description'],
        startDate: (data['start_date'] as Timestamp).toDate(),
        endDate: (data['end_date'] as Timestamp).toDate(),
        category: data['category'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        coverImage: data['cover_image'],
        images: data['images'],
        isApprove: data['is_approve'],
        location: data['location'],
        ticketReservationLink: data['ticket_reservation'],
        tickets: data['tickets']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'organizer_id': organizerId,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'cover_image': coverImage,
      'images': images,
      'is_approve': isApprove,
      'location': location,
      'ticket_reservation': ticketReservationLink,
      'tickets': tickets
    };
  }
}

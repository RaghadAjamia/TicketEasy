import 'package:cloud_firestore/cloud_firestore.dart';

class Tickets {
  String date;
  Timestamp time;
  String location;

  Tickets({
    required this.date,
    required this.time,
    required this.location,
  });

  factory Tickets.fromMap(Map<String, dynamic> data) {
    return Tickets(
      date: data['Date'] ?? '',
      time: data['Time'] ?? Timestamp.now(),
      location: data['Location'] ?? 'JUST',
    );
  }

  String get getDate => date;
  Timestamp get getTime => time;
  String get getLocation => location;
}

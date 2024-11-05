import 'package:cloud_firestore/cloud_firestore.dart';

class Flight {
  final String id;
  final DateTime departureTime;
  final String departureAirport;
  final Duration boardingDuration;
  final Duration securityDuration;
  final Duration travelDuration;
  final Duration preparationDuration;

  Flight({
    required this.id,
    required this.departureTime,
    required this.departureAirport,
    required this.boardingDuration,
    required this.securityDuration,
    required this.travelDuration,
    required this.preparationDuration,
  });

  DateTime get gateClosingTime => departureTime.subtract(boardingDuration);
  DateTime get arrivalTime => gateClosingTime.subtract(securityDuration);
  DateTime get leaveHomeTime => arrivalTime.subtract(travelDuration);
  DateTime get wakeUpTime => leaveHomeTime.subtract(preparationDuration);

  Map<String, dynamic> toJson() {
    return {
      'departureTime': Timestamp.fromDate(departureTime),
      'departureAirport': departureAirport,
      'boardingDuration': boardingDuration.inMinutes,
      'securityDuration': securityDuration.inMinutes,
      'travelDuration': travelDuration.inMinutes,
      'preparationDuration': preparationDuration.inMinutes,
    };
  }

  factory Flight.fromJson(Map<String, dynamic> json, String id) {
    return Flight(
      id: id,
      departureTime: (json['departureTime'] as Timestamp).toDate(),
      departureAirport: json['departureAirport'],
      boardingDuration: Duration(minutes: json['boardingDuration']),
      securityDuration: Duration(minutes: json['securityDuration']),
      travelDuration: Duration(minutes: json['travelDuration']),
      preparationDuration: Duration(minutes: json['preparationDuration']),
    );
  }
}
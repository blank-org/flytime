import 'package:flutter/material.dart';
import 'package:flight_countdown/models/flight.dart';
import 'package:flight_countdown/utils/time_formatter.dart';
import 'package:flight_countdown/widgets/countdown_timer.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;

  const FlightCard({Key? key, required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text('Flight to ${flight.departureAirport}'),
        subtitle: Text(formatDateTime(flight.departureTime)),
        children: [
          TimelineItem(
            title: 'Wake Up',
            time: flight.wakeUpTime,
            icon: Icons.alarm,
          ),
          TimelineItem(
            title: 'Leave Home',
            time: flight.leaveHomeTime,
            icon: Icons.home,
          ),
          TimelineItem(
            title: 'Airport Arrival',
            time: flight.arrivalTime,
            icon: Icons.airport_shuttle,
          ),
          TimelineItem(
            title: 'Gate Closes',
            time: flight.gateClosingTime,
            icon: Icons.door_front_door,
          ),
          TimelineItem(
            title: 'Departure',
            time: flight.departureTime,
            icon: Icons.flight_takeoff,
          ),
        ],
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final DateTime time;
  final IconData icon;

  const TimelineItem({
    Key? key,
    required this.title,
    required this.time,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(formatDateTime(time)),
      trailing: CountdownTimer(targetTime: time),
    );
  }
}

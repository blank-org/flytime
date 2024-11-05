import 'package:flutter/material.dart';
import 'package:flight_countdown/screens/add_flight_screen.dart';

class AddFlightButton extends StatelessWidget {
  const AddFlightButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddFlightScreen()),
        );
      },
      child: const Icon(Icons.add),
      tooltip: 'Add Flight',
    );
  }
}
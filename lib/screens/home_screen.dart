import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flight_countdown/widgets/flight_list.dart';
import 'package:flight_countdown/widgets/add_flight_button.dart';
import 'package:flight_countdown/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Countdown'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!authProvider.isAuthenticated) {
            return const Center(
              child: Text('Please sign in to view your flights'),
            );
          }

          return const FlightList();
        },
      ),
      floatingActionButton: const AddFlightButton(),
    );
  }
}
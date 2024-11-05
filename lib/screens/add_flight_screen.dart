import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flight_countdown/providers/auth_provider.dart';
import 'package:flight_countdown/models/flight.dart';

class AddFlightScreen extends StatefulWidget {
  const AddFlightScreen({Key? key}) : super(key: key);

  @override
  State<AddFlightScreen> createState() => _AddFlightScreenState();
}

class _AddFlightScreenState extends State<AddFlightScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _departureTime = DateTime.now().add(const Duration(days: 1));
  String _departureAirport = '';
  int _boardingDuration = 30;
  int _securityDuration = 60;
  int _travelDuration = 60;
  int _preparationDuration = 60;

  Future<void> _saveFlight() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final userId = context.read<AuthProvider>().user?.uid;
    if (userId == null) return;

    final flight = Flight(
      id: '',
      departureTime: _departureTime,
      departureAirport: _departureAirport,
      boardingDuration: Duration(minutes: _boardingDuration),
      securityDuration: Duration(minutes: _securityDuration),
      travelDuration: Duration(minutes: _travelDuration),
      preparationDuration: Duration(minutes: _preparationDuration),
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('flights')
          .add(flight.toJson());
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving flight: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flight'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Departure Airport',
                hintText: 'Enter airport code (e.g., JFK)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an airport';
                }
                return null;
              },
              onSaved: (value) => _departureAirport = value!,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Departure Time'),
              subtitle: Text(_departureTime.toString()),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _departureTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_departureTime),
                  );
                  if (time != null) {
                    setState(() {
                      _departureTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            _buildDurationField(
              'Boarding Duration (minutes)',
              _boardingDuration,
              (value) => _boardingDuration = value,
            ),
            _buildDurationField(
              'Security Duration (minutes)',
              _securityDuration,
              (value) => _securityDuration = value,
            ),
            _buildDurationField(
              'Travel Duration (minutes)',
              _travelDuration,
              (value) => _travelDuration = value,
            ),
            _buildDurationField(
              'Preparation Duration (minutes)',
              _preparationDuration,
              (value) => _preparationDuration = value,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveFlight,
              child: const Text('Save Flight'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationField(
    String label,
    int initialValue,
    void Function(int) onChanged,
  ) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      initialValue: initialValue.toString(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a duration';
        }
        final duration = int.tryParse(value);
        if (duration == null || duration <= 0) {
          return 'Please enter a valid duration';
        }
        return null;
      },
      onSaved: (value) => onChanged(int.parse(value!)),
    );
  }
}
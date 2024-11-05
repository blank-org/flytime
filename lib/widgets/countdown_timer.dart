import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetTime;

  const CountdownTimer({
    Key? key,
    required this.targetTime,
  }) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTimeLeft();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final difference = widget.targetTime.difference(now);

    if (mounted) {
      setState(() {
        _timeLeft = difference;
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Past';
    }

    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    if (days > 0) {
      return '${days}d ${hours}h';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_timeLeft),
      style: TextStyle(
        color: _timeLeft.isNegative
            ? Theme.of(context).colorScheme.error
            : null,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

class LiveTimer extends StatefulWidget {
  const LiveTimer({
    super.key,
    this.width,
    this.height,
    required this.startTime,
    required this.textColor,
    required this.backgroundColor,
    required this.textSize,
  });

  final double? width;
  final double? height;
  final DateTime startTime;
  final Color textColor;
  final Color backgroundColor;
  final int textSize;

  @override
  State<LiveTimer> createState() => _LiveTimerState();
}

class _LiveTimerState extends State<LiveTimer> {
  late Timer _ticker;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.startTime);

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(widget.startTime);
      });
    });
  }

  String _formatElapsed(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      color: widget.backgroundColor,
      child: Text(
        _formatElapsed(_elapsed),
        style: TextStyle(
          color: widget.textColor,
          fontSize: widget.textSize.toDouble(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

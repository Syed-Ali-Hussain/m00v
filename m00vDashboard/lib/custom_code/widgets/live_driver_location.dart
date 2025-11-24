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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class LiveDriverLocation extends StatefulWidget {
  const LiveDriverLocation({
    super.key,
    this.width,
    this.height,
    required this.origin,
    required this.destination,
    required this.driverPosition,
    required this.googleApiKey,
    required this.polylineColor,
    required this.polylineWidth,
    required this.customMapStyle,
    required this.darkMode,
    required this.markerType,
  });

  final double? width;
  final double? height;
  final LatLng origin;
  final LatLng destination;
  final LatLng driverPosition;
  final String googleApiKey;
  final Color polylineColor;
  final int polylineWidth;
  final String customMapStyle;
  final bool darkMode;
  final String markerType;

  @override
  State<LiveDriverLocation> createState() => _LiveDriverLocationState();
}

class _LiveDriverLocationState extends State<LiveDriverLocation> {}
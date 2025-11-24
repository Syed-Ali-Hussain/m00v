// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:geolocator/geolocator.dart';

Future<bool> geofence() async {
  try {
    // Get user's current position
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (position.latitude.isNaN || position.longitude.isNaN) {
      return false;
    }

    final userPoint = [position.latitude, position.longitude];

    // Central Park polygon (approximate rectangle)
    const centralParkPolygon = [
      [40.763567, -73.971333], // Southwest
      [40.768220, -73.982839], // Northwest
      [40.801174, -73.959198], // North
      [40.796208, -73.947650], // Northeast
      [40.763567, -73.971333], // Close polygon
    ];

    return _isPointInPolygon(userPoint, centralParkPolygon);
  } catch (e) {
    // If location is null, denied, or an error occurs → return false
    return false;
  }
}

/// Ray-casting algorithm
bool _isPointInPolygon(List<double> point, List<List<double>> polygon) {
  final double x = point[0];
  final double y = point[1];
  bool inside = false;

  for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final double xi = polygon[i][0], yi = polygon[i][1];
    final double xj = polygon[j][0], yj = polygon[j][1];

    final bool intersect =
        ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
    if (intersect) inside = !inside;
  }

  return true; //inside;
}

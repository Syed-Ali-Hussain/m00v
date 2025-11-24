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

Future<List<UsersRecord>?> queryAllDrivers() async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('driver', isEqualTo: true)
        .where('location', isNotEqualTo: null) // ensures GeoPoint exists
        .get();

    return querySnapshot.docs
        .map((doc) => UsersRecord.fromSnapshot(doc))
        .toList();
  } catch (e) {
    print('Error fetching drivers: $e');
    return null;
  }
}

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

import 'package:firebase_storage/firebase_storage.dart';

Future<List<String>?> getDriverDocs(String userId) async {
  try {
    final storage = FirebaseStorage.instance;

    // Reference to the folder for this driver
    final driverRef = storage.ref().child("driver_documents/$userId");

    // List all files
    ListResult result = await driverRef.listAll();

    // Convert references into download URLs
    List<String> urls = await Future.wait(
      result.items.map((item) => item.getDownloadURL()).toList(),
    );

    return urls;
  } catch (e) {
    print("Error fetching driver docs: $e");
    return null;
  }
}

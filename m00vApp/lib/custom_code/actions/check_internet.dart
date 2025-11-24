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

import 'package:http/http.dart' as http;

Future<bool> checkInternet() async {
  // Add your function code here!
  try {
    final response = await http
        .get(Uri.parse('https://clients3.google.com/generate_204'))
        .timeout(const Duration(seconds: 3));
    return response.statusCode == 204;
  } catch (_) {
    return false;
  }
}

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

import 'package:firebase_auth/firebase_auth.dart';

Future<bool> unlinkPhoneAction() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.unlink('phone');
      return true;
    } else {
      throw Exception("No logged-in user");
    }
  } catch (e) {
    print('Error unlinking phone: $e');
    return false;
  }
}

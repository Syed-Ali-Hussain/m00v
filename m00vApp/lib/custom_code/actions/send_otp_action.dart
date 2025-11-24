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
import 'dart:async';

Future<String> sendOtpAction(String phoneNumber) async {
  final Completer<String> completer = Completer();

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: const Duration(seconds: 60),
    verificationCompleted: (PhoneAuthCredential credential) {
      // Auto verification for some phones
      if (!completer.isCompleted) {
        completer.complete('');
      }
    },
    verificationFailed: (FirebaseAuthException e) {
      if (!completer.isCompleted) {
        completer.completeError(e.message ?? 'OTP send failed');
      }
    },
    codeSent: (String verificationId, int? resendToken) {
      if (!completer.isCompleted) {
        completer.complete(verificationId); // ✅ return verificationId
      }
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      if (!completer.isCompleted) {
        completer.complete(verificationId);
      }
    },
  );

  return completer.future;
}

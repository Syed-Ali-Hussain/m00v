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

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<String?> uploadRideTypeImage() async {
  // Add your function code here!
  try {
    // Pick image (jpg/png/webp/pdf if needed)
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      withData: kIsWeb, // needed for web
    );

    if (result == null) {
      print("No file selected");
      return null;
    }

    final fileName = result.files.single.name; // keep original name
    final ref = FirebaseStorage.instance.ref().child('rideTypes/$fileName');

    if (kIsWeb) {
      final bytes = result.files.single.bytes;
      if (bytes == null) {
        print("No file bytes found");
        return null;
      }
      await ref.putData(bytes);
    } else {
      final path = result.files.single.path;
      if (path == null) {
        print("No file path found");
        return null;
      }
      await ref.putFile(File(path));
    }

    // Return the download URL with access token
    final url = await ref.getDownloadURL();
    return url;
  } catch (e) {
    print("Error uploading rideType image: $e");
    return null;
  }
}

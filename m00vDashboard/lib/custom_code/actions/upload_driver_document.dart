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

Future<bool> uploadDriverDocument(
  String driverUID,
  String fileNameBase,
) async {
  try {
    if (driverUID.isEmpty || fileNameBase.isEmpty) {
      print('Invalid input');
      return false;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: kIsWeb, // get bytes if on web
    );

    if (result == null) {
      print('No file selected');
      return false;
    }

    String extension = result.files.single.extension ?? 'jpg';
    String fullFileName = '$fileNameBase.$extension';
    final ref = FirebaseStorage.instance
        .ref()
        .child('driver_documents/$driverUID/$fullFileName');

    if (kIsWeb) {
      // Web upload
      final bytes = result.files.single.bytes;
      if (bytes == null) {
        print('No bytes found for selected file');
        return false;
      }
      await ref.putData(bytes);
    } else {
      // Mobile/Desktop upload
      final path = result.files.single.path;
      if (path == null) {
        print('No file path found');
        return false;
      }
      await ref.putFile(File(path));
    }

    return true;
  } catch (e) {
    print('Error uploading document: $e');
    return false;
  }
}

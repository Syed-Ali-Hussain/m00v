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

import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({
    super.key,
    this.width,
    this.height,
    required this.inputText,
    required this.qrMainColor,
  });

  final double? width;
  final double? height;
  final String inputText;
  final Color qrMainColor;

  @override
  State<GenerateQRCode> createState() => _GenerateQRCodeState();
}

class _GenerateQRCodeState extends State<GenerateQRCode> {
  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: widget.inputText,
      version: QrVersions.auto,
      size: widget.width ?? widget.height ?? 200, // fallback size
      backgroundColor: Colors.transparent,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: widget.qrMainColor,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: widget.qrMainColor,
      ),
    );
  }
}

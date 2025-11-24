import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataLav = false;
  FFUploadedFile uploadedLocalFile_uploadDataLav =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataLav = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

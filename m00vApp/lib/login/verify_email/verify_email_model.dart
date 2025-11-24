import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'verify_email_widget.dart' show VerifyEmailWidget;
import 'package:flutter/material.dart';

class VerifyEmailModel extends FlutterFlowModel<VerifyEmailWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}

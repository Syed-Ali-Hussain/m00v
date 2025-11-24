import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'pick_passenger_widget.dart' show PickPassengerWidget;
import 'package:flutter/material.dart';

class PickPassengerModel extends FlutterFlowModel<PickPassengerWidget> {
  ///  Local state fields for this page.

  bool arrived = false;

  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}

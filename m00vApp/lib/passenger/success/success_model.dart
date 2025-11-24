import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'success_widget.dart' show SuccessWidget;
import 'package:flutter/material.dart';

class SuccessModel extends FlutterFlowModel<SuccessWidget> {
  ///  Local state fields for this page.

  double? rating;

  ///  State fields for stateful widgets in this page.

  // State field(s) for RatingBar widget.
  double? ratingBarValue;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  UsersRecord? driverUserDoc;
  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  DriversRecord? driverDoc;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

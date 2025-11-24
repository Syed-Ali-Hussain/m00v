import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'take_phone_number_widget.dart' show TakePhoneNumberWidget;
import 'package:flutter/material.dart';

class TakePhoneNumberModel extends FlutterFlowModel<TakePhoneNumberWidget> {
  ///  Local state fields for this page.

  String? id;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - sendOtpAction] action in Button widget.
  String? otpSent;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

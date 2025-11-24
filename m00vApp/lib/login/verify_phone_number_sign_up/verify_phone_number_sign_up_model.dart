import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'verify_phone_number_sign_up_widget.dart'
    show VerifyPhoneNumberSignUpWidget;
import 'package:flutter/material.dart';

class VerifyPhoneNumberSignUpModel
    extends FlutterFlowModel<VerifyPhoneNumberSignUpWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Bottom Sheet - userName] action in Button widget.
  String? name1;
  // Stores action output result for [Bottom Sheet - DriverOrPassenger] action in Button widget.
  bool? driver1;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  DriversRecord? driverCreated;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
  }
}

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'create_account_widget.dart' show CreateAccountWidget;
import 'package:flutter/material.dart';

class CreateAccountModel extends FlutterFlowModel<CreateAccountWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for SignUpEmail widget.
  FocusNode? signUpEmailFocusNode;
  TextEditingController? signUpEmailTextController;
  String? Function(BuildContext, String?)? signUpEmailTextControllerValidator;
  String? _signUpEmailTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email Address is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for SignUpPass widget.
  FocusNode? signUpPassFocusNode;
  TextEditingController? signUpPassTextController;
  late bool signUpPassVisibility;
  String? Function(BuildContext, String?)? signUpPassTextControllerValidator;
  String? _signUpPassTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    }

    if (val.length < 8) {
      return 'Your password must include:\n\t•\tAt least 8 characters\n\t•\tAt least one lowercase letter (a–z)\n\t•\tAt least one uppercase letter (A–Z)\n\t•\tAt least one number (0–9)\n\t•\tAt least one special symbol (e.g. ! @ # \$ %)';
    }

    if (!RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9]).{8,}\$')
        .hasMatch(val)) {
      return 'Your password must include:\n\t•\tAt least 8 characters\n\t•\tAt least one lowercase letter (a–z)\n\t•\tAt least one uppercase letter (A–Z)\n\t•\tAt least one number (0–9)\n\t•\tAt least one special symbol (e.g. ! @ # \$ %)';
    }
    return null;
  }

  // Stores action output result for [Bottom Sheet - phoneNumber] action in Button widget.
  String? number1;
  // Stores action output result for [Bottom Sheet - userName] action in Button widget.
  String? name;
  // Stores action output result for [Bottom Sheet - DriverOrPassenger] action in Button widget.
  bool? driver;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  DriversRecord? driverDocMade;
  // State field(s) for logInEmail widget.
  FocusNode? logInEmailFocusNode;
  TextEditingController? logInEmailTextController;
  String? Function(BuildContext, String?)? logInEmailTextControllerValidator;
  // State field(s) for logInPass widget.
  FocusNode? logInPassFocusNode;
  TextEditingController? logInPassTextController;
  late bool logInPassVisibility;
  String? Function(BuildContext, String?)? logInPassTextControllerValidator;
  // Stores action output result for [Bottom Sheet - phoneNumber] action in Button widget.
  String? phoneNumber;

  @override
  void initState(BuildContext context) {
    signUpEmailTextControllerValidator = _signUpEmailTextControllerValidator;
    signUpPassVisibility = false;
    signUpPassTextControllerValidator = _signUpPassTextControllerValidator;
    logInPassVisibility = false;
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    signUpEmailFocusNode?.dispose();
    signUpEmailTextController?.dispose();

    signUpPassFocusNode?.dispose();
    signUpPassTextController?.dispose();

    logInEmailFocusNode?.dispose();
    logInEmailTextController?.dispose();

    logInPassFocusNode?.dispose();
    logInPassTextController?.dispose();
  }
}

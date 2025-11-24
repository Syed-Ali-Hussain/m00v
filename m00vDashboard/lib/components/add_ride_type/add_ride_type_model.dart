import '/flutter_flow/flutter_flow_util.dart';
import 'add_ride_type_widget.dart' show AddRideTypeWidget;
import 'package:flutter/material.dart';

class AddRideTypeModel extends FlutterFlowModel<AddRideTypeWidget> {
  ///  Local state fields for this component.

  String imagePath =
      'https://images.unsplash.com/photo-1602500491514-ed552dd7ab64?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxMnx8Y2FsbWluZyUyMG5hdHVyZXxlbnwwfHx8fDE3NTU2NDEwNTZ8MA&ixlib=rb-4.1.0&q=80&w=1080';

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - uploadRideTypeImage] action in Image widget.
  String? imageUploaded;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}

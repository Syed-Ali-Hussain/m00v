import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'driver_docs_widget.dart' show DriverDocsWidget;
import 'package:flutter/material.dart';

class DriverDocsModel extends FlutterFlowModel<DriverDocsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Custom Action - getDriverDocs] action in Container widget.
  List<String>? docsGot;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

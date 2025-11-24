import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dropoff_widget.dart' show DropoffWidget;
import 'package:flutter/material.dart';

class DropoffModel extends FlutterFlowModel<DropoffWidget> {
  ///  Local state fields for this component.

  List<dynamic> searchResults = [];
  void addToSearchResults(dynamic item) => searchResults.add(item);
  void removeFromSearchResults(dynamic item) => searchResults.remove(item);
  void removeAtIndexFromSearchResults(int index) =>
      searchResults.removeAt(index);
  void insertAtIndexInSearchResults(int index, dynamic item) =>
      searchResults.insert(index, item);
  void updateSearchResultsAtIndex(int index, Function(dynamic) updateFn) =>
      searchResults[index] = updateFn(searchResults[index]);

  dynamic chosen;

  LatLng? point;

  String? title;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (Places Autocomplete)] action in TextField widget.
  ApiCallResponse? autoCompleteResults;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

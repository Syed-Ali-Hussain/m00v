import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'famous_points_widget.dart' show FamousPointsWidget;
import 'package:flutter/material.dart';

class FamousPointsModel extends FlutterFlowModel<FamousPointsWidget> {
  ///  Local state fields for this component.

  List<FamousPointsRecord> selected = [];
  void addToSelected(FamousPointsRecord item) => selected.add(item);
  void removeFromSelected(FamousPointsRecord item) => selected.remove(item);
  void removeAtIndexFromSelected(int index) => selected.removeAt(index);
  void insertAtIndexInSelected(int index, FamousPointsRecord item) =>
      selected.insert(index, item);
  void updateSelectedAtIndex(
          int index, Function(FamousPointsRecord) updateFn) =>
      selected[index] = updateFn(selected[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

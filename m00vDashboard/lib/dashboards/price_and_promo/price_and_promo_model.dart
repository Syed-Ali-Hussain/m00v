import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'price_and_promo_widget.dart' show PriceAndPromoWidget;
import 'package:flutter/material.dart';

class PriceAndPromoModel extends FlutterFlowModel<PriceAndPromoWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Stores action output result for [Custom Action - uploadRideTypeImage] action in Image widget.
  String? imageUploaded;
  // State field(s) for Checkbox widget.
  Map<PromoCodesRecord, bool> checkboxValueMap = {};
  List<PromoCodesRecord> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}

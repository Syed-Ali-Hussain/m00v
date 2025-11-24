import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'famous_points_widget.dart' show FamousPointsWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FamousPointsModel extends FlutterFlowModel<FamousPointsWidget> {
  ///  Local state fields for this component.

  FamousPointsRecord? selected;

  ///  State fields for stateful widgets in this component.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

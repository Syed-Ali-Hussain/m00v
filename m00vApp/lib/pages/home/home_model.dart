import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Read Document] action in Home widget.
  DriversRecord? driverDoc;
  // Stores action output result for [Backend Call - Read Document] action in Home widget.
  RidesRecord? rideGot;
  // Stores action output result for [Backend Call - Create Document] action in Home widget.
  DriversRecord? newDriverCreated;
  // Stores action output result for [Backend Call - Read Document] action in Home widget.
  RidesRecord? rideGotPassenger;
  // Stores action output result for [Custom Action - queryAllDrivers] action in Home widget.
  List<UsersRecord>? allDriver;
  // Stores action output result for [Bottom Sheet - famousPoints] action in Button widget.
  List<FamousPointsRecord>? pointsGot;
  // Stores action output result for [Custom Action - randomNumber] action in Button widget.
  String? uuid;
  // Stores action output result for [Bottom Sheet - pickUp] action in Button widget.
  LatLng? pickUpGot;
  // Stores action output result for [Custom Action - geofence] action in Button widget.
  bool? inArea;
  // Stores action output result for [Bottom Sheet - selectRideType] action in Button widget.
  RideTypesRecord? vehicleType;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  RidesRecord? rideCreated;
  // Stores action output result for [Custom Action - queryAllDrivers] action in Button widget.
  List<UsersRecord>? allDrivers;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

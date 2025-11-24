import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'where_to_widget.dart' show WhereToWidget;
import 'package:flutter/material.dart';

class WhereToModel extends FlutterFlowModel<WhereToWidget> {
  ///  Local state fields for this page.

  String? sessionTokenUUID;

  List<dynamic> searchResult = [];
  void addToSearchResult(dynamic item) => searchResult.add(item);
  void removeFromSearchResult(dynamic item) => searchResult.remove(item);
  void removeAtIndexFromSearchResult(int index) => searchResult.removeAt(index);
  void insertAtIndexInSearchResult(int index, dynamic item) =>
      searchResult.insert(index, item);
  void updateSearchResultAtIndex(int index, Function(dynamic) updateFn) =>
      searchResult[index] = updateFn(searchResult[index]);

  RideTypesRecord? rideType;

  bool tapped = false;

  List<DropoffStruct> locations = [];
  void addToLocations(DropoffStruct item) => locations.add(item);
  void removeFromLocations(DropoffStruct item) => locations.remove(item);
  void removeAtIndexFromLocations(int index) => locations.removeAt(index);
  void insertAtIndexInLocations(int index, DropoffStruct item) =>
      locations.insert(index, item);
  void updateLocationsAtIndex(int index, Function(DropoffStruct) updateFn) =>
      locations[index] = updateFn(locations[index]);

  LatLng? pickup;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - randomNumber] action in whereTo widget.
  String? sessionToken;
  // Stores action output result for [Bottom Sheet - pickUp] action in whereTo widget.
  LatLng? pickUpGot;
  // Stores action output result for [Custom Action - geofence] action in whereTo widget.
  bool? inArea;
  // Stores action output result for [Bottom Sheet - dropoff] action in whereTo widget.
  DropoffStruct? firstDropoff;
  // Stores action output result for [Bottom Sheet - dropoff] action in Button widget.
  DropoffStruct? dropoffgot;
  // Stores action output result for [Bottom Sheet - selectRideType] action in Container widget.
  RideTypesRecord? rideTypeSelectedNow;
  // Stores action output result for [Backend Call - Create Document] action in Container widget.
  RidesRecord? rideCreated;
  // Stores action output result for [Custom Action - queryAllDrivers] action in Container widget.
  List<UsersRecord>? driversGot;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

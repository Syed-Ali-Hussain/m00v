// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class DropoffStruct extends FFFirebaseStruct {
  DropoffStruct({
    LatLng? location,
    String? name,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _location = location,
        _name = name,
        super(firestoreUtilData);

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  set location(LatLng? val) => _location = val;

  bool hasLocation() => _location != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  static DropoffStruct fromMap(Map<String, dynamic> data) => DropoffStruct(
        location: data['location'] as LatLng?,
        name: data['name'] as String?,
      );

  static DropoffStruct? maybeFromMap(dynamic data) =>
      data is Map ? DropoffStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'location': _location,
        'name': _name,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'location': serializeParam(
          _location,
          ParamType.LatLng,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
      }.withoutNulls;

  static DropoffStruct fromSerializableMap(Map<String, dynamic> data) =>
      DropoffStruct(
        location: deserializeParam(
          data['location'],
          ParamType.LatLng,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DropoffStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DropoffStruct &&
        location == other.location &&
        name == other.name;
  }

  @override
  int get hashCode => const ListEquality().hash([location, name]);
}

DropoffStruct createDropoffStruct({
  LatLng? location,
  String? name,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DropoffStruct(
      location: location,
      name: name,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DropoffStruct? updateDropoffStruct(
  DropoffStruct? dropoff, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dropoff
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDropoffStructData(
  Map<String, dynamic> firestoreData,
  DropoffStruct? dropoff,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dropoff == null) {
    return;
  }
  if (dropoff.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dropoff.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dropoffData = getDropoffFirestoreData(dropoff, forFieldValue);
  final nestedData = dropoffData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = dropoff.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDropoffFirestoreData(
  DropoffStruct? dropoff, [
  bool forFieldValue = false,
]) {
  if (dropoff == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dropoff.toMap());

  // Add any Firestore field values
  dropoff.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDropoffListFirestoreData(
  List<DropoffStruct>? dropoffs,
) =>
    dropoffs?.map((e) => getDropoffFirestoreData(e, true)).toList() ?? [];

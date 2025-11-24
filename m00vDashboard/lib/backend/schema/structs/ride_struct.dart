// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class RideStruct extends FFFirebaseStruct {
  RideStruct({
    LatLng? start,
    LatLng? end,
    DateTime? startTime,
    DateTime? endTime,
    double? price,
    DocumentReference? customer,
    DocumentReference? driver,
    bool? paid,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _start = start,
        _end = end,
        _startTime = startTime,
        _endTime = endTime,
        _price = price,
        _customer = customer,
        _driver = driver,
        _paid = paid,
        super(firestoreUtilData);

  // "start" field.
  LatLng? _start;
  LatLng? get start => _start;
  set start(LatLng? val) => _start = val;

  bool hasStart() => _start != null;

  // "end" field.
  LatLng? _end;
  LatLng? get end => _end;
  set end(LatLng? val) => _end = val;

  bool hasEnd() => _end != null;

  // "startTime" field.
  DateTime? _startTime;
  DateTime? get startTime => _startTime;
  set startTime(DateTime? val) => _startTime = val;

  bool hasStartTime() => _startTime != null;

  // "endTime" field.
  DateTime? _endTime;
  DateTime? get endTime => _endTime;
  set endTime(DateTime? val) => _endTime = val;

  bool hasEndTime() => _endTime != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "customer" field.
  DocumentReference? _customer;
  DocumentReference? get customer => _customer;
  set customer(DocumentReference? val) => _customer = val;

  bool hasCustomer() => _customer != null;

  // "driver" field.
  DocumentReference? _driver;
  DocumentReference? get driver => _driver;
  set driver(DocumentReference? val) => _driver = val;

  bool hasDriver() => _driver != null;

  // "paid" field.
  bool? _paid;
  bool get paid => _paid ?? false;
  set paid(bool? val) => _paid = val;

  bool hasPaid() => _paid != null;

  static RideStruct fromMap(Map<String, dynamic> data) => RideStruct(
        start: data['start'] as LatLng?,
        end: data['end'] as LatLng?,
        startTime: data['startTime'] as DateTime?,
        endTime: data['endTime'] as DateTime?,
        price: castToType<double>(data['price']),
        customer: data['customer'] as DocumentReference?,
        driver: data['driver'] as DocumentReference?,
        paid: data['paid'] as bool?,
      );

  static RideStruct? maybeFromMap(dynamic data) =>
      data is Map ? RideStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'start': _start,
        'end': _end,
        'startTime': _startTime,
        'endTime': _endTime,
        'price': _price,
        'customer': _customer,
        'driver': _driver,
        'paid': _paid,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'start': serializeParam(
          _start,
          ParamType.LatLng,
        ),
        'end': serializeParam(
          _end,
          ParamType.LatLng,
        ),
        'startTime': serializeParam(
          _startTime,
          ParamType.DateTime,
        ),
        'endTime': serializeParam(
          _endTime,
          ParamType.DateTime,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'customer': serializeParam(
          _customer,
          ParamType.DocumentReference,
        ),
        'driver': serializeParam(
          _driver,
          ParamType.DocumentReference,
        ),
        'paid': serializeParam(
          _paid,
          ParamType.bool,
        ),
      }.withoutNulls;

  static RideStruct fromSerializableMap(Map<String, dynamic> data) =>
      RideStruct(
        start: deserializeParam(
          data['start'],
          ParamType.LatLng,
          false,
        ),
        end: deserializeParam(
          data['end'],
          ParamType.LatLng,
          false,
        ),
        startTime: deserializeParam(
          data['startTime'],
          ParamType.DateTime,
          false,
        ),
        endTime: deserializeParam(
          data['endTime'],
          ParamType.DateTime,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        customer: deserializeParam(
          data['customer'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
        driver: deserializeParam(
          data['driver'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
        paid: deserializeParam(
          data['paid'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'RideStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RideStruct &&
        start == other.start &&
        end == other.end &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        price == other.price &&
        customer == other.customer &&
        driver == other.driver &&
        paid == other.paid;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([start, end, startTime, endTime, price, customer, driver, paid]);
}

RideStruct createRideStruct({
  LatLng? start,
  LatLng? end,
  DateTime? startTime,
  DateTime? endTime,
  double? price,
  DocumentReference? customer,
  DocumentReference? driver,
  bool? paid,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RideStruct(
      start: start,
      end: end,
      startTime: startTime,
      endTime: endTime,
      price: price,
      customer: customer,
      driver: driver,
      paid: paid,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RideStruct? updateRideStruct(
  RideStruct? ride, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    ride
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRideStructData(
  Map<String, dynamic> firestoreData,
  RideStruct? ride,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (ride == null) {
    return;
  }
  if (ride.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && ride.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final rideData = getRideFirestoreData(ride, forFieldValue);
  final nestedData = rideData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = ride.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRideFirestoreData(
  RideStruct? ride, [
  bool forFieldValue = false,
]) {
  if (ride == null) {
    return {};
  }
  final firestoreData = mapToFirestore(ride.toMap());

  // Add any Firestore field values
  ride.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRideListFirestoreData(
  List<RideStruct>? rides,
) =>
    rides?.map((e) => getRideFirestoreData(e, true)).toList() ?? [];

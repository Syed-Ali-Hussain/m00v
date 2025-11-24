import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RidesRecord extends FirestoreRecord {
  RidesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "startTime" field.
  DateTime? _startTime;
  DateTime? get startTime => _startTime;
  bool hasStartTime() => _startTime != null;

  // "endTime" field.
  DateTime? _endTime;
  DateTime? get endTime => _endTime;
  bool hasEndTime() => _endTime != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "paid" field.
  bool? _paid;
  bool get paid => _paid ?? false;
  bool hasPaid() => _paid != null;

  // "customer" field.
  DocumentReference? _customer;
  DocumentReference? get customer => _customer;
  bool hasCustomer() => _customer != null;

  // "driver" field.
  DocumentReference? _driver;
  DocumentReference? get driver => _driver;
  bool hasDriver() => _driver != null;

  // "rideType" field.
  DocumentReference? _rideType;
  DocumentReference? get rideType => _rideType;
  bool hasRideType() => _rideType != null;

  // "accepted" field.
  bool? _accepted;
  bool get accepted => _accepted ?? false;
  bool hasAccepted() => _accepted != null;

  // "destinationName" field.
  String? _destinationName;
  String get destinationName => _destinationName ?? '';
  bool hasDestinationName() => _destinationName != null;

  // "end" field.
  LatLng? _end;
  LatLng? get end => _end;
  bool hasEnd() => _end != null;

  // "start" field.
  LatLng? _start;
  LatLng? get start => _start;
  bool hasStart() => _start != null;

  // "completedButNotPaid" field.
  bool? _completedButNotPaid;
  bool get completedButNotPaid => _completedButNotPaid ?? false;
  bool hasCompletedButNotPaid() => _completedButNotPaid != null;

  // "started" field.
  bool? _started;
  bool get started => _started ?? false;
  bool hasStarted() => _started != null;

  // "pickupTime" field.
  DateTime? _pickupTime;
  DateTime? get pickupTime => _pickupTime;
  bool hasPickupTime() => _pickupTime != null;

  // "canceled" field.
  bool? _canceled;
  bool get canceled => _canceled ?? false;
  bool hasCanceled() => _canceled != null;

  // "paidAt" field.
  DateTime? _paidAt;
  DateTime? get paidAt => _paidAt;
  bool hasPaidAt() => _paidAt != null;

  void _initializeFields() {
    _startTime = snapshotData['startTime'] as DateTime?;
    _endTime = snapshotData['endTime'] as DateTime?;
    _price = castToType<double>(snapshotData['price']);
    _paid = snapshotData['paid'] as bool?;
    _customer = snapshotData['customer'] as DocumentReference?;
    _driver = snapshotData['driver'] as DocumentReference?;
    _rideType = snapshotData['rideType'] as DocumentReference?;
    _accepted = snapshotData['accepted'] as bool?;
    _destinationName = snapshotData['destinationName'] as String?;
    _end = snapshotData['end'] as LatLng?;
    _start = snapshotData['start'] as LatLng?;
    _completedButNotPaid = snapshotData['completedButNotPaid'] as bool?;
    _started = snapshotData['started'] as bool?;
    _pickupTime = snapshotData['pickupTime'] as DateTime?;
    _canceled = snapshotData['canceled'] as bool?;
    _paidAt = snapshotData['paidAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('rides');

  static Stream<RidesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RidesRecord.fromSnapshot(s));

  static Future<RidesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RidesRecord.fromSnapshot(s));

  static RidesRecord fromSnapshot(DocumentSnapshot snapshot) => RidesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RidesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RidesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RidesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RidesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRidesRecordData({
  DateTime? startTime,
  DateTime? endTime,
  double? price,
  bool? paid,
  DocumentReference? customer,
  DocumentReference? driver,
  DocumentReference? rideType,
  bool? accepted,
  String? destinationName,
  LatLng? end,
  LatLng? start,
  bool? completedButNotPaid,
  bool? started,
  DateTime? pickupTime,
  bool? canceled,
  DateTime? paidAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'startTime': startTime,
      'endTime': endTime,
      'price': price,
      'paid': paid,
      'customer': customer,
      'driver': driver,
      'rideType': rideType,
      'accepted': accepted,
      'destinationName': destinationName,
      'end': end,
      'start': start,
      'completedButNotPaid': completedButNotPaid,
      'started': started,
      'pickupTime': pickupTime,
      'canceled': canceled,
      'paidAt': paidAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class RidesRecordDocumentEquality implements Equality<RidesRecord> {
  const RidesRecordDocumentEquality();

  @override
  bool equals(RidesRecord? e1, RidesRecord? e2) {
    return e1?.startTime == e2?.startTime &&
        e1?.endTime == e2?.endTime &&
        e1?.price == e2?.price &&
        e1?.paid == e2?.paid &&
        e1?.customer == e2?.customer &&
        e1?.driver == e2?.driver &&
        e1?.rideType == e2?.rideType &&
        e1?.accepted == e2?.accepted &&
        e1?.destinationName == e2?.destinationName &&
        e1?.end == e2?.end &&
        e1?.start == e2?.start &&
        e1?.completedButNotPaid == e2?.completedButNotPaid &&
        e1?.started == e2?.started &&
        e1?.pickupTime == e2?.pickupTime &&
        e1?.canceled == e2?.canceled &&
        e1?.paidAt == e2?.paidAt;
  }

  @override
  int hash(RidesRecord? e) => const ListEquality().hash([
        e?.startTime,
        e?.endTime,
        e?.price,
        e?.paid,
        e?.customer,
        e?.driver,
        e?.rideType,
        e?.accepted,
        e?.destinationName,
        e?.end,
        e?.start,
        e?.completedButNotPaid,
        e?.started,
        e?.pickupTime,
        e?.canceled,
        e?.paidAt
      ]);

  @override
  bool isValidKey(Object? o) => o is RidesRecord;
}

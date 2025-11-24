import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RideTypesRecord extends FirestoreRecord {
  RideTypesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "carImage" field.
  String? _carImage;
  String get carImage => _carImage ?? '';
  bool hasCarImage() => _carImage != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "owner" field.
  DocumentReference? _owner;
  DocumentReference? get owner => _owner;
  bool hasOwner() => _owner != null;

  // "pricePerMin" field.
  double? _pricePerMin;
  double get pricePerMin => _pricePerMin ?? 0.0;
  bool hasPricePerMin() => _pricePerMin != null;

  // "driverPercentageShare" field.
  double? _driverPercentageShare;
  double get driverPercentageShare => _driverPercentageShare ?? 0.0;
  bool hasDriverPercentageShare() => _driverPercentageShare != null;

  void _initializeFields() {
    _carImage = snapshotData['carImage'] as String?;
    _name = snapshotData['name'] as String?;
    _owner = snapshotData['owner'] as DocumentReference?;
    _pricePerMin = castToType<double>(snapshotData['pricePerMin']);
    _driverPercentageShare =
        castToType<double>(snapshotData['driverPercentageShare']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('rideTypes');

  static Stream<RideTypesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RideTypesRecord.fromSnapshot(s));

  static Future<RideTypesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RideTypesRecord.fromSnapshot(s));

  static RideTypesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RideTypesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RideTypesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RideTypesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RideTypesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RideTypesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRideTypesRecordData({
  String? carImage,
  String? name,
  DocumentReference? owner,
  double? pricePerMin,
  double? driverPercentageShare,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'carImage': carImage,
      'name': name,
      'owner': owner,
      'pricePerMin': pricePerMin,
      'driverPercentageShare': driverPercentageShare,
    }.withoutNulls,
  );

  return firestoreData;
}

class RideTypesRecordDocumentEquality implements Equality<RideTypesRecord> {
  const RideTypesRecordDocumentEquality();

  @override
  bool equals(RideTypesRecord? e1, RideTypesRecord? e2) {
    return e1?.carImage == e2?.carImage &&
        e1?.name == e2?.name &&
        e1?.owner == e2?.owner &&
        e1?.pricePerMin == e2?.pricePerMin &&
        e1?.driverPercentageShare == e2?.driverPercentageShare;
  }

  @override
  int hash(RideTypesRecord? e) => const ListEquality().hash([
        e?.carImage,
        e?.name,
        e?.owner,
        e?.pricePerMin,
        e?.driverPercentageShare
      ]);

  @override
  bool isValidKey(Object? o) => o is RideTypesRecord;
}

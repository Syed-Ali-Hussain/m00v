import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FamousPointsRecord extends FirestoreRecord {
  FamousPointsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "details" field.
  String? _details;
  String get details => _details ?? '';
  bool hasDetails() => _details != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "latLong" field.
  LatLng? _latLong;
  LatLng? get latLong => _latLong;
  bool hasLatLong() => _latLong != null;

  void _initializeFields() {
    _image = snapshotData['image'] as String?;
    _details = snapshotData['details'] as String?;
    _title = snapshotData['title'] as String?;
    _latLong = snapshotData['latLong'] as LatLng?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('famousPoints');

  static Stream<FamousPointsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FamousPointsRecord.fromSnapshot(s));

  static Future<FamousPointsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FamousPointsRecord.fromSnapshot(s));

  static FamousPointsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FamousPointsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FamousPointsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FamousPointsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FamousPointsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FamousPointsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFamousPointsRecordData({
  String? image,
  String? details,
  String? title,
  LatLng? latLong,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'image': image,
      'details': details,
      'title': title,
      'latLong': latLong,
    }.withoutNulls,
  );

  return firestoreData;
}

class FamousPointsRecordDocumentEquality
    implements Equality<FamousPointsRecord> {
  const FamousPointsRecordDocumentEquality();

  @override
  bool equals(FamousPointsRecord? e1, FamousPointsRecord? e2) {
    return e1?.image == e2?.image &&
        e1?.details == e2?.details &&
        e1?.title == e2?.title &&
        e1?.latLong == e2?.latLong;
  }

  @override
  int hash(FamousPointsRecord? e) =>
      const ListEquality().hash([e?.image, e?.details, e?.title, e?.latLong]);

  @override
  bool isValidKey(Object? o) => o is FamousPointsRecord;
}

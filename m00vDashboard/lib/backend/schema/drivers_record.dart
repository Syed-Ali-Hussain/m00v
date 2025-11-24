import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DriversRecord extends FirestoreRecord {
  DriversRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userId" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "ratings" field.
  List<RatingStruct>? _ratings;
  List<RatingStruct> get ratings => _ratings ?? const [];
  bool hasRatings() => _ratings != null;

  // "isApproved" field.
  bool? _isApproved;
  bool get isApproved => _isApproved ?? false;
  bool hasIsApproved() => _isApproved != null;

  // "isOnline" field.
  bool? _isOnline;
  bool get isOnline => _isOnline ?? false;
  bool hasIsOnline() => _isOnline != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "blocked" field.
  bool? _blocked;
  bool get blocked => _blocked ?? false;
  bool hasBlocked() => _blocked != null;

  // "rideType" field.
  DocumentReference? _rideType;
  DocumentReference? get rideType => _rideType;
  bool hasRideType() => _rideType != null;

  void _initializeFields() {
    _userId = snapshotData['userId'] as DocumentReference?;
    _ratings = getStructList(
      snapshotData['ratings'],
      RatingStruct.fromMap,
    );
    _isApproved = snapshotData['isApproved'] as bool?;
    _isOnline = snapshotData['isOnline'] as bool?;
    _image = snapshotData['image'] as String?;
    _blocked = snapshotData['blocked'] as bool?;
    _rideType = snapshotData['rideType'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('drivers');

  static Stream<DriversRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DriversRecord.fromSnapshot(s));

  static Future<DriversRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DriversRecord.fromSnapshot(s));

  static DriversRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DriversRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DriversRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DriversRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DriversRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DriversRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDriversRecordData({
  DocumentReference? userId,
  bool? isApproved,
  bool? isOnline,
  String? image,
  bool? blocked,
  DocumentReference? rideType,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userId': userId,
      'isApproved': isApproved,
      'isOnline': isOnline,
      'image': image,
      'blocked': blocked,
      'rideType': rideType,
    }.withoutNulls,
  );

  return firestoreData;
}

class DriversRecordDocumentEquality implements Equality<DriversRecord> {
  const DriversRecordDocumentEquality();

  @override
  bool equals(DriversRecord? e1, DriversRecord? e2) {
    const listEquality = ListEquality();
    return e1?.userId == e2?.userId &&
        listEquality.equals(e1?.ratings, e2?.ratings) &&
        e1?.isApproved == e2?.isApproved &&
        e1?.isOnline == e2?.isOnline &&
        e1?.image == e2?.image &&
        e1?.blocked == e2?.blocked &&
        e1?.rideType == e2?.rideType;
  }

  @override
  int hash(DriversRecord? e) => const ListEquality().hash([
        e?.userId,
        e?.ratings,
        e?.isApproved,
        e?.isOnline,
        e?.image,
        e?.blocked,
        e?.rideType
      ]);

  @override
  bool isValidKey(Object? o) => o is DriversRecord;
}

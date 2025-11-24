import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PromoCodesRecord extends FirestoreRecord {
  PromoCodesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "expTime" field.
  DateTime? _expTime;
  DateTime? get expTime => _expTime;
  bool hasExpTime() => _expTime != null;

  // "claimed" field.
  bool? _claimed;
  bool get claimed => _claimed ?? false;
  bool hasClaimed() => _claimed != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  bool hasText() => _text != null;

  // "discountPercentage" field.
  double? _discountPercentage;
  double get discountPercentage => _discountPercentage ?? 0.0;
  bool hasDiscountPercentage() => _discountPercentage != null;

  // "absoluteDiscount" field.
  double? _absoluteDiscount;
  double get absoluteDiscount => _absoluteDiscount ?? 0.0;
  bool hasAbsoluteDiscount() => _absoluteDiscount != null;

  // "owner" field.
  DocumentReference? _owner;
  DocumentReference? get owner => _owner;
  bool hasOwner() => _owner != null;

  void _initializeFields() {
    _expTime = snapshotData['expTime'] as DateTime?;
    _claimed = snapshotData['claimed'] as bool?;
    _text = snapshotData['text'] as String?;
    _discountPercentage =
        castToType<double>(snapshotData['discountPercentage']);
    _absoluteDiscount = castToType<double>(snapshotData['absoluteDiscount']);
    _owner = snapshotData['owner'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('promoCodes');

  static Stream<PromoCodesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PromoCodesRecord.fromSnapshot(s));

  static Future<PromoCodesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PromoCodesRecord.fromSnapshot(s));

  static PromoCodesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PromoCodesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PromoCodesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PromoCodesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PromoCodesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PromoCodesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPromoCodesRecordData({
  DateTime? expTime,
  bool? claimed,
  String? text,
  double? discountPercentage,
  double? absoluteDiscount,
  DocumentReference? owner,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'expTime': expTime,
      'claimed': claimed,
      'text': text,
      'discountPercentage': discountPercentage,
      'absoluteDiscount': absoluteDiscount,
      'owner': owner,
    }.withoutNulls,
  );

  return firestoreData;
}

class PromoCodesRecordDocumentEquality implements Equality<PromoCodesRecord> {
  const PromoCodesRecordDocumentEquality();

  @override
  bool equals(PromoCodesRecord? e1, PromoCodesRecord? e2) {
    return e1?.expTime == e2?.expTime &&
        e1?.claimed == e2?.claimed &&
        e1?.text == e2?.text &&
        e1?.discountPercentage == e2?.discountPercentage &&
        e1?.absoluteDiscount == e2?.absoluteDiscount &&
        e1?.owner == e2?.owner;
  }

  @override
  int hash(PromoCodesRecord? e) => const ListEquality().hash([
        e?.expTime,
        e?.claimed,
        e?.text,
        e?.discountPercentage,
        e?.absoluteDiscount,
        e?.owner
      ]);

  @override
  bool isValidKey(Object? o) => o is PromoCodesRecord;
}

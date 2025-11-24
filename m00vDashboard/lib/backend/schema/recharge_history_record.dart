import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RechargeHistoryRecord extends FirestoreRecord {
  RechargeHistoryRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  bool hasAmount() => _amount != null;

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "input" field.
  bool? _input;
  bool get input => _input ?? false;
  bool hasInput() => _input != null;

  // "rideRef" field.
  DocumentReference? _rideRef;
  DocumentReference? get rideRef => _rideRef;
  bool hasRideRef() => _rideRef != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _date = snapshotData['date'] as DateTime?;
    _amount = castToType<double>(snapshotData['amount']);
    _user = snapshotData['user'] as DocumentReference?;
    _input = snapshotData['input'] as bool?;
    _rideRef = snapshotData['rideRef'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('rechargeHistory')
          : FirebaseFirestore.instance.collectionGroup('rechargeHistory');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('rechargeHistory').doc(id);

  static Stream<RechargeHistoryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RechargeHistoryRecord.fromSnapshot(s));

  static Future<RechargeHistoryRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RechargeHistoryRecord.fromSnapshot(s));

  static RechargeHistoryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RechargeHistoryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RechargeHistoryRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RechargeHistoryRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RechargeHistoryRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RechargeHistoryRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRechargeHistoryRecordData({
  DateTime? date,
  double? amount,
  DocumentReference? user,
  bool? input,
  DocumentReference? rideRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'date': date,
      'amount': amount,
      'user': user,
      'input': input,
      'rideRef': rideRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class RechargeHistoryRecordDocumentEquality
    implements Equality<RechargeHistoryRecord> {
  const RechargeHistoryRecordDocumentEquality();

  @override
  bool equals(RechargeHistoryRecord? e1, RechargeHistoryRecord? e2) {
    return e1?.date == e2?.date &&
        e1?.amount == e2?.amount &&
        e1?.user == e2?.user &&
        e1?.input == e2?.input &&
        e1?.rideRef == e2?.rideRef;
  }

  @override
  int hash(RechargeHistoryRecord? e) => const ListEquality()
      .hash([e?.date, e?.amount, e?.user, e?.input, e?.rideRef]);

  @override
  bool isValidKey(Object? o) => o is RechargeHistoryRecord;
}

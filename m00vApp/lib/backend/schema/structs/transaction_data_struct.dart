// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class TransactionDataStruct extends FFFirebaseStruct {
  TransactionDataStruct({
    DateTime? date,
    double? amount,
    DocumentReference? rideRef,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _date = date,
        _amount = amount,
        _rideRef = rideRef,
        super(firestoreUtilData);

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  set date(DateTime? val) => _date = val;

  bool hasDate() => _date != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  set amount(double? val) => _amount = val;

  void incrementAmount(double amount) => amount = amount + amount;

  bool hasAmount() => _amount != null;

  // "rideRef" field.
  DocumentReference? _rideRef;
  DocumentReference? get rideRef => _rideRef;
  set rideRef(DocumentReference? val) => _rideRef = val;

  bool hasRideRef() => _rideRef != null;

  static TransactionDataStruct fromMap(Map<String, dynamic> data) =>
      TransactionDataStruct(
        date: data['date'] as DateTime?,
        amount: castToType<double>(data['amount']),
        rideRef: data['rideRef'] as DocumentReference?,
      );

  static TransactionDataStruct? maybeFromMap(dynamic data) => data is Map
      ? TransactionDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'date': _date,
        'amount': _amount,
        'rideRef': _rideRef,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'date': serializeParam(
          _date,
          ParamType.DateTime,
        ),
        'amount': serializeParam(
          _amount,
          ParamType.double,
        ),
        'rideRef': serializeParam(
          _rideRef,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static TransactionDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      TransactionDataStruct(
        date: deserializeParam(
          data['date'],
          ParamType.DateTime,
          false,
        ),
        amount: deserializeParam(
          data['amount'],
          ParamType.double,
          false,
        ),
        rideRef: deserializeParam(
          data['rideRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['rides'],
        ),
      );

  @override
  String toString() => 'TransactionDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TransactionDataStruct &&
        date == other.date &&
        amount == other.amount &&
        rideRef == other.rideRef;
  }

  @override
  int get hashCode => const ListEquality().hash([date, amount, rideRef]);
}

TransactionDataStruct createTransactionDataStruct({
  DateTime? date,
  double? amount,
  DocumentReference? rideRef,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TransactionDataStruct(
      date: date,
      amount: amount,
      rideRef: rideRef,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TransactionDataStruct? updateTransactionDataStruct(
  TransactionDataStruct? transactionData, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    transactionData
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTransactionDataStructData(
  Map<String, dynamic> firestoreData,
  TransactionDataStruct? transactionData,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (transactionData == null) {
    return;
  }
  if (transactionData.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && transactionData.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final transactionDataData =
      getTransactionDataFirestoreData(transactionData, forFieldValue);
  final nestedData =
      transactionDataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = transactionData.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTransactionDataFirestoreData(
  TransactionDataStruct? transactionData, [
  bool forFieldValue = false,
]) {
  if (transactionData == null) {
    return {};
  }
  final firestoreData = mapToFirestore(transactionData.toMap());

  // Add any Firestore field values
  transactionData.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTransactionDataListFirestoreData(
  List<TransactionDataStruct>? transactionDatas,
) =>
    transactionDatas
        ?.map((e) => getTransactionDataFirestoreData(e, true))
        .toList() ??
    [];

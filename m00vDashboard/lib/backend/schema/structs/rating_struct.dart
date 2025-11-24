// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class RatingStruct extends FFFirebaseStruct {
  RatingStruct({
    String? raterName,
    double? ratingGiven,
    String? reviewGiven,
    DocumentReference? refOfUserWhoRated,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _raterName = raterName,
        _ratingGiven = ratingGiven,
        _reviewGiven = reviewGiven,
        _refOfUserWhoRated = refOfUserWhoRated,
        super(firestoreUtilData);

  // "raterName" field.
  String? _raterName;
  String get raterName => _raterName ?? '';
  set raterName(String? val) => _raterName = val;

  bool hasRaterName() => _raterName != null;

  // "ratingGiven" field.
  double? _ratingGiven;
  double get ratingGiven => _ratingGiven ?? 0.0;
  set ratingGiven(double? val) => _ratingGiven = val;

  void incrementRatingGiven(double amount) =>
      ratingGiven = ratingGiven + amount;

  bool hasRatingGiven() => _ratingGiven != null;

  // "reviewGiven" field.
  String? _reviewGiven;
  String get reviewGiven => _reviewGiven ?? '';
  set reviewGiven(String? val) => _reviewGiven = val;

  bool hasReviewGiven() => _reviewGiven != null;

  // "refOfUserWhoRated" field.
  DocumentReference? _refOfUserWhoRated;
  DocumentReference? get refOfUserWhoRated => _refOfUserWhoRated;
  set refOfUserWhoRated(DocumentReference? val) => _refOfUserWhoRated = val;

  bool hasRefOfUserWhoRated() => _refOfUserWhoRated != null;

  static RatingStruct fromMap(Map<String, dynamic> data) => RatingStruct(
        raterName: data['raterName'] as String?,
        ratingGiven: castToType<double>(data['ratingGiven']),
        reviewGiven: data['reviewGiven'] as String?,
        refOfUserWhoRated: data['refOfUserWhoRated'] as DocumentReference?,
      );

  static RatingStruct? maybeFromMap(dynamic data) =>
      data is Map ? RatingStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'raterName': _raterName,
        'ratingGiven': _ratingGiven,
        'reviewGiven': _reviewGiven,
        'refOfUserWhoRated': _refOfUserWhoRated,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'raterName': serializeParam(
          _raterName,
          ParamType.String,
        ),
        'ratingGiven': serializeParam(
          _ratingGiven,
          ParamType.double,
        ),
        'reviewGiven': serializeParam(
          _reviewGiven,
          ParamType.String,
        ),
        'refOfUserWhoRated': serializeParam(
          _refOfUserWhoRated,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static RatingStruct fromSerializableMap(Map<String, dynamic> data) =>
      RatingStruct(
        raterName: deserializeParam(
          data['raterName'],
          ParamType.String,
          false,
        ),
        ratingGiven: deserializeParam(
          data['ratingGiven'],
          ParamType.double,
          false,
        ),
        reviewGiven: deserializeParam(
          data['reviewGiven'],
          ParamType.String,
          false,
        ),
        refOfUserWhoRated: deserializeParam(
          data['refOfUserWhoRated'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
      );

  @override
  String toString() => 'RatingStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RatingStruct &&
        raterName == other.raterName &&
        ratingGiven == other.ratingGiven &&
        reviewGiven == other.reviewGiven &&
        refOfUserWhoRated == other.refOfUserWhoRated;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([raterName, ratingGiven, reviewGiven, refOfUserWhoRated]);
}

RatingStruct createRatingStruct({
  String? raterName,
  double? ratingGiven,
  String? reviewGiven,
  DocumentReference? refOfUserWhoRated,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RatingStruct(
      raterName: raterName,
      ratingGiven: ratingGiven,
      reviewGiven: reviewGiven,
      refOfUserWhoRated: refOfUserWhoRated,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RatingStruct? updateRatingStruct(
  RatingStruct? rating, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    rating
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRatingStructData(
  Map<String, dynamic> firestoreData,
  RatingStruct? rating,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (rating == null) {
    return;
  }
  if (rating.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && rating.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final ratingData = getRatingFirestoreData(rating, forFieldValue);
  final nestedData = ratingData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = rating.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRatingFirestoreData(
  RatingStruct? rating, [
  bool forFieldValue = false,
]) {
  if (rating == null) {
    return {};
  }
  final firestoreData = mapToFirestore(rating.toMap());

  // Add any Firestore field values
  rating.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRatingListFirestoreData(
  List<RatingStruct>? ratings,
) =>
    ratings?.map((e) => getRatingFirestoreData(e, true)).toList() ?? [];

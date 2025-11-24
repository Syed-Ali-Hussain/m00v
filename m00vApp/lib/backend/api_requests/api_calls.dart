import 'dart:convert';
import '../cloud_functions/cloud_functions.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class DistanceMatrixCall {
  static Future<ApiCallResponse> call({
    String? originLocation = '',
    String? destinationLocation = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'DistanceMatrixCall',
        'variables': {
          'originLocation': originLocation,
          'destinationLocation': destinationLocation,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  static String? distance(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.rows[:].elements[:].distance.text''',
      ));
  static String? duration(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.rows[:].elements[:].duration.text''',
      ));
  static List<String>? destinationAddress(dynamic response) => (getJsonField(
        response,
        r'''$.destination_addresses''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? originAddress(dynamic response) => (getJsonField(
        response,
        r'''$.origin_addresses''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class PlacesAutocompleteCall {
  static Future<ApiCallResponse> call({
    String? searched = '',
    String? userLocation = '',
    String? sessionToken = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'PlacesAutocompleteCall',
        'variables': {
          'searched': searched,
          'userLocation': userLocation,
          'sessionToken': sessionToken,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  static List<String>? mainText(dynamic response) => (getJsonField(
        response,
        r'''$.predictions[:].structured_formatting.main_text''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? secondaryText(dynamic response) => (getJsonField(
        response,
        r'''$.predictions[:].structured_formatting.secondary_text''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? placeId(dynamic response) => (getJsonField(
        response,
        r'''$.predictions[:].place_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? description(dynamic response) => (getJsonField(
        response,
        r'''$.predictions[:].description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? predictions(dynamic response) => getJsonField(
        response,
        r'''$.predictions''',
        true,
      ) as List?;
}

class PlaceDetailsCall {
  static Future<ApiCallResponse> call({
    String? placeId = '',
    String? sessionToken = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'PlaceDetailsCall',
        'variables': {
          'placeId': placeId,
          'sessionToken': sessionToken,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  static dynamic location(dynamic response) => getJsonField(
        response,
        r'''$.result.geometry.location''',
      );
  static String? icon(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.result.icon''',
      ));
  static String? iconBgColor(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.result.icon_background_color''',
      ));
  static double? locationLat(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.result.geometry.location.lat''',
      ));
  static double? locationLong(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.result.geometry.location.lng''',
      ));
  static String? name(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.result.name''',
      ));
}

class StripePayoutCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'Stripe Payout',
      apiUrl: 'https://api.stripe.com/v1/accounts',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Bearer sk_test_51RkPuk4GlevFltImaDKE0dBKkYITiyCNgc0PROkvctA8L41b5nWxGuoZPx7Ne09mLTqmQxGwBvUnCcl8Jui6c04x00peScTe0M',
      },
      params: {
        'type': "custom",
        'country': "US",
        'email': "testuser@example.com",
        'capabilities[card_payments][requested]': true,
        'capabilities[transfers][requested]': true,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

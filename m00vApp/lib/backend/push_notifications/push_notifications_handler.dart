import 'dart:async';

import 'serialization_util.dart';
import '/backend/backend.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


final _handledMessageIds = <String?>{};

class PushNotificationsHandler extends StatefulWidget {
  const PushNotificationsHandler({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  _PushNotificationsHandlerState createState() =>
      _PushNotificationsHandlerState();
}

class _PushNotificationsHandlerState extends State<PushNotificationsHandler> {
  bool _loading = false;

  Future handleOpenedPushNotification() async {
    if (isWeb) {
      return;
    }

    final notification = await FirebaseMessaging.instance.getInitialMessage();
    if (notification != null) {
      await _handlePushNotification(notification);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handlePushNotification);
  }

  Future _handlePushNotification(RemoteMessage message) async {
    if (_handledMessageIds.contains(message.messageId)) {
      return;
    }
    _handledMessageIds.add(message.messageId);

    safeSetState(() => _loading = true);
    try {
      final initialPageName = message.data['initialPageName'] as String;
      final initialParameterData = getInitialParameterData(message.data);
      final parametersBuilder = parametersBuilderMap[initialPageName];
      if (parametersBuilder != null) {
        final parameterData = await parametersBuilder(initialParameterData);
        if (mounted) {
          context.pushNamed(
            initialPageName,
            pathParameters: parameterData.pathParameters,
            extra: parameterData.extra,
          );
        } else {
          appNavigatorKey.currentContext?.pushNamed(
            initialPageName,
            pathParameters: parameterData.pathParameters,
            extra: parameterData.extra,
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      safeSetState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      handleOpenedPushNotification();
    });
  }

  @override
  Widget build(BuildContext context) => _loading
      ? Container(
          color: Colors.white,
          child: Image.asset(
            'assets/images/image.png',
            fit: BoxFit.contain,
          ),
        )
      : widget.child;
}

class ParameterData {
  const ParameterData(
      {this.requiredParams = const {}, this.allParams = const {}});
  final Map<String, String?> requiredParams;
  final Map<String, dynamic> allParams;

  Map<String, String> get pathParameters => Map.fromEntries(
        requiredParams.entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
  Map<String, dynamic> get extra => Map.fromEntries(
        allParams.entries.where((e) => e.value != null),
      );

  static Future<ParameterData> Function(Map<String, dynamic>) none() =>
      (data) async => ParameterData();
}

final parametersBuilderMap =
    <String, Future<ParameterData> Function(Map<String, dynamic>)>{
  'Home': ParameterData.none(),
  'Activity': ParameterData.none(),
  'travelStart': (data) async => ParameterData(
        allParams: {
          'rideDoc': await getDocumentParameter<RidesRecord>(
              data, 'rideDoc', RidesRecord.fromSnapshot),
        },
      ),
  'CreateAccount': ParameterData.none(),
  'uploadFiles': ParameterData.none(),
  'ForgotPassword': ParameterData.none(),
  'pickPassenger': (data) async => ParameterData(
        allParams: {
          'rideDoc': await getDocumentParameter<RidesRecord>(
              data, 'rideDoc', RidesRecord.fromSnapshot),
        },
      ),
  'bill': (data) async => ParameterData(
        allParams: {
          'rideDoc': await getDocumentParameter<RidesRecord>(
              data, 'rideDoc', RidesRecord.fromSnapshot),
        },
      ),
  'Success': (data) async => ParameterData(
        allParams: {
          'rideDoc': await getDocumentParameter<RidesRecord>(
              data, 'rideDoc', RidesRecord.fromSnapshot),
        },
      ),
  'whereTo': (data) async => ParameterData(
        allParams: {
          'rideType': await getDocumentParameter<RideTypesRecord>(
              data, 'rideType', RideTypesRecord.fromSnapshot),
        },
      ),
  'searchingDriver': (data) async => ParameterData(
        allParams: {
          'rideDocument': await getDocumentParameter<RidesRecord>(
              data, 'rideDocument', RidesRecord.fromSnapshot),
        },
      ),
  'driverComing': (data) async => ParameterData(
        allParams: {
          'rideRef': getParameter<DocumentReference>(data, 'rideRef'),
        },
      ),
  'DocsUploadedSuccess': ParameterData.none(),
  'chat': (data) async => ParameterData(
        allParams: {
          'otherPersonDoc': await getDocumentParameter<UsersRecord>(
              data, 'otherPersonDoc', UsersRecord.fromSnapshot),
          'rideRef': getParameter<DocumentReference>(data, 'rideRef'),
        },
      ),
  'verifyPhoneNumberSignUp': (data) async => ParameterData(
        allParams: {
          'phnumber': getParameter<String>(data, 'phnumber'),
        },
      ),
  'AccountBanned': ParameterData.none(),
  'Profile': ParameterData.none(),
  'verifyEmail': ParameterData.none(),
  'takePhoneNumber': ParameterData.none(),
  'VerifyOTP': (data) async => ParameterData(
        allParams: {
          'phnumber': getParameter<String>(data, 'phnumber'),
        },
      ),
  'test': ParameterData.none(),
};

Map<String, dynamic> getInitialParameterData(Map<String, dynamic> data) {
  try {
    final parameterDataStr = data['parameterData'];
    if (parameterDataStr == null ||
        parameterDataStr is! String ||
        parameterDataStr.isEmpty) {
      return {};
    }
    return jsonDecode(parameterDataStr) as Map<String, dynamic>;
  } catch (e) {
    print('Error parsing parameter data: $e');
    return {};
  }
}

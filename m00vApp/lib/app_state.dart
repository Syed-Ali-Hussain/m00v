import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _rideRef = prefs.getString('ff_rideRef')?.ref ?? _rideRef;
    });
    _safeInit(() {
      _remainingDistance =
          prefs.getDouble('ff_remainingDistance') ?? _remainingDistance;
    });
    _safeInit(() {
      _destinationReached =
          prefs.getBool('ff_destinationReached') ?? _destinationReached;
    });
    _safeInit(() {
      _ridePlaced = prefs.getBool('ff_ridePlaced') ?? _ridePlaced;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  DocumentReference? _rideRef;
  DocumentReference? get rideRef => _rideRef;
  set rideRef(DocumentReference? value) {
    _rideRef = value;
    value != null
        ? prefs.setString('ff_rideRef', value.path)
        : prefs.remove('ff_rideRef');
  }

  double _remainingDistance = 0.0;
  double get remainingDistance => _remainingDistance;
  set remainingDistance(double value) {
    _remainingDistance = value;
    prefs.setDouble('ff_remainingDistance', value);
  }

  bool _destinationReached = false;
  bool get destinationReached => _destinationReached;
  set destinationReached(bool value) {
    _destinationReached = value;
    prefs.setBool('ff_destinationReached', value);
  }

  bool _ridePlaced = false;
  bool get ridePlaced => _ridePlaced;
  set ridePlaced(bool value) {
    _ridePlaced = value;
    prefs.setBool('ff_ridePlaced', value);
  }

  String _qrCode = '';
  String get qrCode => _qrCode;
  set qrCode(String value) {
    _qrCode = value;
  }

  DateTime? _timeStart = DateTime.fromMillisecondsSinceEpoch(1756941300000);
  DateTime? get timeStart => _timeStart;
  set timeStart(DateTime? value) {
    _timeStart = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

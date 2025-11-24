// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class FirebasePolylineMap extends StatefulWidget {
  const FirebasePolylineMap({
    super.key,
    this.width,
    this.height,
    required this.driverDocumentRef,
    required this.destination,
    required this.googleApiKey,
    required this.polylineColor,
    required this.polylineWidth,
    required this.deviationThreshold,
    required this.arrivalThreshold,
    required this.customMapStyle,
    required this.darkMode,
  });

  final double? width;
  final double? height;
  final DocumentReference driverDocumentRef;
  final LatLng destination;
  final String googleApiKey;
  final Color polylineColor;
  final int polylineWidth;
  final double deviationThreshold;
  final double arrivalThreshold;
  final String customMapStyle;
  final bool darkMode;

  @override
  State<FirebasePolylineMap> createState() => _FirebasePolylineMapState();
}

class _FirebasePolylineMapState extends State<FirebasePolylineMap> {
  final Completer<gmaps.GoogleMapController> _mapController = Completer();
  final Set<gmaps.Polyline> _polylines = {};
  final List<gmaps.LatLng> _fullRouteCoordinates = [];
  final List<gmaps.LatLng> _remainingRouteCoordinates = [];
  StreamSubscription<DocumentSnapshot>? _firebaseSubscription;
  gmaps.LatLng? _driverPosition;
  gmaps.BitmapDescriptor? _destinationIcon;
  gmaps.BitmapDescriptor? _driverIcon;
  DateTime _lastPolylineFetch = DateTime.now();
  int _lastClosestSegmentIndex = 0;
  bool _isFetchingPolyline = false;
  bool _firstLocationUpdate = true;
  bool _destinationReached = false;
  double _cameraZoom = 17.0;
  double _remainingDistance = 0;
  double _fullRouteDistance = 0;
  Timer? _cameraUpdateTimer;

  static const _minPolylineRefreshDuration = Duration(seconds: 15);
  static const _maxCameraZoom = 19.0;
  static const _minCameraZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _loadMarkerIcons();
    _startListeningToFirebase();
  }

  Future<void> _loadMarkerIcons() async {
    try {
      // Load destination icon
      final destColorPrefix = widget.darkMode ? 'dark' : 'light';
      final destAssetPath =
          'assets/images/${destColorPrefix}_passenger_icon.png';
      final destByteData = await rootBundle.load(destAssetPath);
      final destBytes = destByteData.buffer.asUint8List();
      final destIcon = gmaps.BitmapDescriptor.fromBytes(destBytes);

      // Load driver icon (assuming you have a driver icon)
      final driverColorPrefix = widget.darkMode ? 'dark' : 'light';
      final driverAssetPath =
          'assets/images/${driverColorPrefix}_bike_icon.png';
      final driverByteData = await rootBundle.load(driverAssetPath);
      final driverBytes = driverByteData.buffer.asUint8List();
      final driverIcon = gmaps.BitmapDescriptor.fromBytes(driverBytes);

      if (mounted) {
        setState(() {
          _destinationIcon = destIcon;
          _driverIcon = driverIcon;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _destinationIcon = gmaps.BitmapDescriptor.defaultMarker;
          _driverIcon = gmaps.BitmapDescriptor.defaultMarker;
        });
      }
    }
  }

  void _startListeningToFirebase() {
    _firebaseSubscription =
        widget.driverDocumentRef.snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('location')) {
          final geoPoint = data['location'] as GeoPoint;
          final newPosition =
              gmaps.LatLng(geoPoint.latitude, geoPoint.longitude);

          if (mounted) {
            setState(() {
              _driverPosition = newPosition;
            });
          }

          _checkArrival(newPosition);
          _handleInitialPosition(newPosition);
          _updatePolylineBasedOnPosition(newPosition);
          _updateCameraPosition(newPosition);
        }
      }
    }, onError: (error) {
      print("Firebase listen error: $error");
    });
  }

  void _checkArrival(gmaps.LatLng position) {
    final distanceToDestination = _haversineDistance(
      position.latitude,
      position.longitude,
      widget.destination.latitude,
      widget.destination.longitude,
    );

    if (distanceToDestination <= widget.arrivalThreshold) {
      _handleArrival();
    }
  }

  void _handleInitialPosition(gmaps.LatLng position) {
    if (_firstLocationUpdate) {
      _firstLocationUpdate = false;
      _setCameraToRouteBounds(position);
      _fetchPolyline(position.latitude, position.longitude);
    }
  }

  void _updatePolylineBasedOnPosition(gmaps.LatLng position) {
    if (_fullRouteCoordinates.isNotEmpty) {
      _trimPolylineToDriverLocation(position);

      if (_shouldRecalculatePolyline(position)) {
        _fetchPolyline(position.latitude, position.longitude);
      }
    }
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _fetchPolyline(double startLat, double startLng) async {
    if (!await _checkConnectivity()) {
      _showError("No internet connection");
      return;
    }

    if (_isFetchingPolyline) return;

    _isFetchingPolyline = true;
    _lastPolylineFetch = DateTime.now();

    try {
      final polylinePoints = PolylinePoints();
      final result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(startLat, startLng),
          destination: PointLatLng(
            widget.destination.latitude,
            widget.destination.longitude,
          ),
          mode: TravelMode.driving,
        ),
        googleApiKey: widget.googleApiKey,
      );

      if (result.points.isEmpty) {
        _showError("No route found. Retrying...");
        _isFetchingPolyline = false;
        return;
      }

      if (mounted) {
        setState(() {
          _fullRouteCoordinates
            ..clear()
            ..addAll(
              result.points
                  .map((point) => gmaps.LatLng(point.latitude, point.longitude))
                  .toList(),
            );

          _remainingRouteCoordinates
            ..clear()
            ..addAll(_fullRouteCoordinates);

          _fullRouteDistance = 0;
          _updatePolyline();
          _calculateRouteDistance();
          _lastClosestSegmentIndex = 0;
        });
      }
    } catch (e) {
      _showError('Route update failed: ${e.toString()}');
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted && !_destinationReached && _driverPosition != null) {
          _fetchPolyline(_driverPosition!.latitude, _driverPosition!.longitude);
        }
      });
    } finally {
      _isFetchingPolyline = false;
    }
  }

  void _handleArrival() {
    if (mounted) {
      setState(() {
        _destinationReached = true;
        _polylines.clear();
      });
    }

    _firebaseSubscription?.cancel();

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Destination Reached"),
          content: const Text("The driver has arrived at the destination."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _setCameraToRouteBounds(gmaps.LatLng driverLocation) async {
    try {
      final controller = await _mapController.future;
      final bounds = gmaps.LatLngBounds(
        southwest: gmaps.LatLng(
          min(driverLocation.latitude, widget.destination.latitude),
          min(driverLocation.longitude, widget.destination.longitude),
        ),
        northeast: gmaps.LatLng(
          max(driverLocation.latitude, widget.destination.latitude),
          max(driverLocation.longitude, widget.destination.longitude),
        ),
      );

      controller.animateCamera(
        gmaps.CameraUpdate.newLatLngBounds(bounds, 100),
      );
    } catch (e) {
      _showError('Camera update failed: ${e.toString()}');
    }
  }

  void _trimPolylineToDriverLocation(gmaps.LatLng position) {
    if (_fullRouteCoordinates.isEmpty) return;

    final closestIndex = _findClosestSegmentIndex(position);
    if (closestIndex == -1) return;

    _lastClosestSegmentIndex = closestIndex;

    final newRoute = [position]
      ..addAll(_fullRouteCoordinates.sublist(closestIndex + 1));

    if (!_listEquals(_remainingRouteCoordinates, newRoute)) {
      if (mounted) {
        setState(() {
          _remainingRouteCoordinates
            ..clear()
            ..addAll(newRoute);
          _updatePolyline();
          _calculateRouteDistance();
        });
      }
    }
  }

  bool _listEquals(List<gmaps.LatLng> a, List<gmaps.LatLng> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].latitude != b[i].latitude || a[i].longitude != b[i].longitude) {
        return false;
      }
    }
    return true;
  }

  int _findClosestSegmentIndex(gmaps.LatLng position) {
    double minDistance = double.infinity;
    int closestIndex = -1;
    const int searchWindow = 20;

    int startIndex = max(0, _lastClosestSegmentIndex - searchWindow ~/ 2);
    int endIndex = min(_fullRouteCoordinates.length - 1,
        _lastClosestSegmentIndex + searchWindow ~/ 2);

    for (int i = startIndex; i < endIndex; i++) {
      final distance = _distanceToSegment(
        position.latitude,
        position.longitude,
        _fullRouteCoordinates[i],
        _fullRouteCoordinates[i + 1],
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    return closestIndex;
  }

  void _calculateRouteDistance() {
    if (_remainingRouteCoordinates.length < 2) {
      _remainingDistance = 0;
      return;
    }

    if (_fullRouteDistance == 0) {
      _fullRouteDistance = _computePathDistance(_fullRouteCoordinates);
    }

    final traveledDistance = _computePathDistance(
        _fullRouteCoordinates.sublist(0, _lastClosestSegmentIndex + 1));

    _remainingDistance = max(0, _fullRouteDistance - traveledDistance);
  }

  double _computePathDistance(List<gmaps.LatLng> path) {
    double total = 0;
    for (int i = 0; i < path.length - 1; i++) {
      total += _haversineDistance(
        path[i].latitude,
        path[i].longitude,
        path[i + 1].latitude,
        path[i + 1].longitude,
      );
    }
    return total;
  }

  void _updatePolyline() {
    _polylines.clear();
    if (_remainingRouteCoordinates.length > 1) {
      try {
        final cleanRoute = _removeDuplicatePoints(_remainingRouteCoordinates);
        _polylines.add(
          gmaps.Polyline(
            polylineId: const gmaps.PolylineId('route'),
            points: cleanRoute,
            color: widget.polylineColor,
            width: widget.polylineWidth,
            geodesic: true,
            startCap: gmaps.Cap.roundCap,
            endCap: gmaps.Cap.buttCap,
            jointType: gmaps.JointType.round,
          ),
        );
      } catch (e) {
        _showError("Route rendering error");
      }
    }
  }

  List<gmaps.LatLng> _removeDuplicatePoints(List<gmaps.LatLng> points) {
    return points.fold([], (List<gmaps.LatLng> accumulator, point) {
      if (accumulator.isEmpty || point != accumulator.last) {
        accumulator.add(point);
      }
      return accumulator;
    });
  }

  bool _shouldRecalculatePolyline(gmaps.LatLng position) {
    if (_fullRouteCoordinates.isEmpty) return true;

    final timeDiff = DateTime.now().difference(_lastPolylineFetch);
    if (timeDiff < _minPolylineRefreshDuration) return false;

    return _distanceToPolyline(position) > widget.deviationThreshold;
  }

  double _haversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // Earth's radius in meters
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * pi / 180;

  double _distanceToSegment(
    double lat,
    double lng,
    gmaps.LatLng start,
    gmaps.LatLng end,
  ) {
    final toRad = (double deg) => deg * pi / 180.0;

    final latRad = toRad(lat);
    final lngRad = toRad(lng);
    final startLatRad = toRad(start.latitude);
    final startLngRad = toRad(start.longitude);
    final endLatRad = toRad(end.latitude);
    final endLngRad = toRad(end.longitude);

    final dx = (lngRad - startLngRad) * cos((latRad + startLatRad) / 2);
    final dy = latRad - startLatRad;
    final segDx =
        (endLngRad - startLngRad) * cos((startLatRad + endLatRad) / 2);
    final segDy = endLatRad - startLatRad;
    final segLengthSquared = segDx * segDx + segDy * segDy;

    if (segLengthSquared == 0) {
      return _haversineDistance(lat, lng, start.latitude, start.longitude);
    }

    final t = max(0, min(1, (dx * segDx + dy * segDy) / segLengthSquared));
    final closestLat = startLatRad + t * segDy;
    final closestLng = startLngRad + t * segDx;

    return _haversineDistance(
      lat,
      lng,
      closestLat * 180 / pi,
      closestLng * 180 / pi,
    );
  }

  double _distanceToPolyline(gmaps.LatLng pos) {
    double minDistance = double.infinity;
    final checkWindow = min(20, _fullRouteCoordinates.length - 1);

    int startIndex = max(0, _lastClosestSegmentIndex - checkWindow ~/ 2);
    int endIndex = min(_fullRouteCoordinates.length - 1,
        _lastClosestSegmentIndex + checkWindow ~/ 2);

    for (int i = startIndex; i < endIndex; i++) {
      final distance = _distanceToSegment(
        pos.latitude,
        pos.longitude,
        _fullRouteCoordinates[i],
        _fullRouteCoordinates[i + 1],
      );

      if (distance < minDistance) {
        minDistance = distance;
        _lastClosestSegmentIndex = i;
      }
    }

    return minDistance;
  }

  void _updateCameraPosition(gmaps.LatLng newPosition) {
    _cameraUpdateTimer?.cancel();
    _cameraUpdateTimer = Timer(const Duration(milliseconds: 500), () async {
      final controller = await _mapController.future;
      controller.animateCamera(
        gmaps.CameraUpdate.newLatLng(newPosition),
      );
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  gmaps.LatLng _convertToGmapsLatLng(LatLng latLng) {
    return gmaps.LatLng(latLng.latitude, latLng.longitude);
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    _cameraUpdateTimer?.cancel();
    _fullRouteCoordinates.clear();
    _remainingRouteCoordinates.clear();
    _polylines.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: gmaps.GoogleMap(
        onMapCreated: (controller) async {
          if (!_mapController.isCompleted) {
            _mapController.complete(controller);
          }
          controller.setMapStyle(widget.customMapStyle);
        },
        initialCameraPosition: gmaps.CameraPosition(
          target: _convertToGmapsLatLng(widget.destination),
          zoom: _minCameraZoom,
        ),
        polylines: _polylines,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        markers: {
          if (_driverIcon != null &&
              _driverPosition != null &&
              !_destinationReached)
            gmaps.Marker(
              markerId: const gmaps.MarkerId('driver'),
              position: _driverPosition!,
              icon: _driverIcon!,
              zIndex: 2,
            ),
          if (_destinationIcon != null && !_destinationReached)
            gmaps.Marker(
              markerId: const gmaps.MarkerId('destination'),
              position: _convertToGmapsLatLng(widget.destination),
              icon: _destinationIcon!,
              zIndex: 1,
            ),
        },
        minMaxZoomPreference: const gmaps.MinMaxZoomPreference(
          _minCameraZoom,
          _maxCameraZoom,
        ),
        onCameraMove: (position) {
          _cameraZoom = position.zoom;
        },
      ),
    );
  }
}

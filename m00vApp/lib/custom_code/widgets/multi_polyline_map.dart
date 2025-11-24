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
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class MultiPolylineMap extends StatefulWidget {
  const MultiPolylineMap({
    super.key,
    this.width,
    this.height,
    required this.waypoints,
    required this.googleApiKey,
    required this.polylineColor,
    required this.polylineWidth,
    required this.deviationThreshold,
    required this.arrivalThreshold,
    required this.customMapStyle,
    required this.darkMode,
    required this.markerType,
  });

  final double? width;
  final double? height;
  final List<LatLng> waypoints;
  final String googleApiKey;
  final Color polylineColor;
  final int polylineWidth;
  final double deviationThreshold;
  final double arrivalThreshold;
  final String customMapStyle;
  final bool darkMode;
  final String markerType;

  @override
  State<MultiPolylineMap> createState() => _MultiPolylineMapState();
}

class _MultiPolylineMapState extends State<MultiPolylineMap> {
  final Completer<gmaps.GoogleMapController> _mapController = Completer();
  final Set<gmaps.Polyline> _polylines = {};
  final List<gmaps.LatLng> _fullRouteCoordinates = [];
  final List<gmaps.LatLng> _remainingRouteCoordinates = [];
  gmaps.BitmapDescriptor? _destinationIcon;
  StreamSubscription<Position>? _positionStream;
  DateTime _lastPolylineFetch = DateTime.now();
  gmaps.LatLng? _currentPosition;
  Position? _lastPosition;
  int _lastClosestSegmentIndex = 0;
  bool _isFetchingPolyline = false;
  bool _firstLocationUpdate = true;
  bool _isLocationServiceEnabled = false;
  double _cameraZoom = 17.0;
  double _remainingDistance = 0;
  double _fullRouteDistance = 0;
  double? _lastBearing;
  DateTime? _lastStationaryRefresh;
  Timer? _cameraUpdateTimer;

  // Multi-waypoint handling
  int _currentWaypointIndex = 0;
  bool _allWaypointsCompleted = false;

  LatLng get _currentDestination => widget.waypoints[_currentWaypointIndex];

  static const _minPolylineRefreshDuration = Duration(seconds: 15);
  static const _maxCameraZoom = 50.0;
  static const _minCameraZoom = 12.0;
  static const int _locationDistanceFilter = 5;

  // Helper methods
  double _deg2rad(double deg) => deg * pi / 180;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _cameraUpdateTimer?.cancel();
    _fullRouteCoordinates.clear();
    _remainingRouteCoordinates.clear();
    _polylines.clear();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await _loadDestinationMarkerIcon();
    await _ensureLocationStream();
  }

  Future<void> _loadDestinationMarkerIcon() async {
    try {
      final colorPrefix = widget.darkMode ? 'dark' : 'light';
      final assetPath =
          'assets/images/${colorPrefix}_${widget.markerType}_icon.png';

      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();
      final icon = gmaps.BitmapDescriptor.fromBytes(bytes);

      if (mounted) setState(() => _destinationIcon = icon);
    } catch (e) {
      if (mounted) {
        setState(() => _destinationIcon = gmaps.BitmapDescriptor.defaultMarker);
      }
    }
  }

  Future<void> _checkLocationServices() async {
    try {
      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_isLocationServiceEnabled) {
        _showLocationServiceError();
        return;
      }

      await _checkLocationPermissions();
    } catch (e) {
      _showError('Location service check failed: ${e.toString()}');
    }
  }

  Future<void> _checkLocationPermissions() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionError();
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _startLocationStream();
    }
  }

  void _startLocationStream() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: _locationDistanceFilter,
      ),
    ).listen(
      _handleNewPosition,
      onError: (e) => _showError('Location stream error: ${e.toString()}'),
      cancelOnError: false,
    );
  }

  void _handleNewPosition(Position position) {
    if (_allWaypointsCompleted) return;
    _lastPosition = position;

    final currentLatLng = gmaps.LatLng(position.latitude, position.longitude);
    if (mounted) setState(() => _currentPosition = currentLatLng);

    _checkArrival(position);
    _handleInitialPosition(position, currentLatLng);
    _updatePolylineBasedOnPosition(position);
    _updateCameraPosition(currentLatLng, position.heading);

    // Refresh polyline if user is stationary and route is outdated
    if (position.speed < 1 &&
        (_lastStationaryRefresh == null ||
            DateTime.now().difference(_lastStationaryRefresh!) >
                const Duration(minutes: 1))) {
      _lastStationaryRefresh = DateTime.now();
      _fetchPolyline(position.latitude, position.longitude);
    }
  }

  void _checkArrival(Position position) {
    final isStopped = position.speed < 1;

    final distanceToDestination = _haversineDistance(
      position.latitude,
      position.longitude,
      _currentDestination.latitude,
      _currentDestination.longitude,
    );

    if (distanceToDestination <= widget.arrivalThreshold && isStopped) {
      _handleWaypointArrival();
    }
  }

  void _handleWaypointArrival() {
    if (_currentWaypointIndex < widget.waypoints.length - 1) {
      // Move to next waypoint
      setState(() {
        _currentWaypointIndex++;
        _fullRouteCoordinates.clear();
        _remainingRouteCoordinates.clear();
        _polylines.clear();
        _firstLocationUpdate = true;
      });

      // Fetch route to next waypoint
      if (_lastPosition != null) {
        _fetchPolyline(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
        );
      }
    } else {
      // All waypoints completed
      _handleFinalArrival();
    }
  }

  void _handleFinalArrival() {
    if (mounted) {
      setState(() {
        _allWaypointsCompleted = true;
        _polylines.clear();
      });
    }

    _positionStream?.cancel();
    FFAppState().destinationReached = true;

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Journey Completed"),
          content: const Text("You have reached all your destinations."),
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

  void _handleInitialPosition(Position position, gmaps.LatLng currentLatLng) {
    if (_firstLocationUpdate) {
      _firstLocationUpdate = false;
      _setCameraToRouteBounds(currentLatLng);
      _fetchPolyline(position.latitude, position.longitude);
    }
  }

  void _updatePolylineBasedOnPosition(Position position) {
    if (_fullRouteCoordinates.isNotEmpty) {
      _trimPolylineToCurrentLocation(position);

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
    if (!await _checkConnectivity() || _allWaypointsCompleted) return;
    if (_isFetchingPolyline) return;

    _isFetchingPolyline = true;
    _lastPolylineFetch = DateTime.now();

    try {
      final polylinePoints = PolylinePoints();
      final result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(startLat, startLng),
          destination: PointLatLng(
            _currentDestination.latitude,
            _currentDestination.longitude,
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
      if (mounted) {
        _showError('Route update failed: ${e.toString()}');
      }
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted && !_allWaypointsCompleted && _lastPosition != null) {
          _fetchPolyline(_lastPosition!.latitude, _lastPosition!.longitude);
        }
      });
    } finally {
      _isFetchingPolyline = false;
    }
  }

  void _setCameraToRouteBounds(gmaps.LatLng currentLocation) async {
    try {
      final controller = await _mapController.future;
      final bounds = gmaps.LatLngBounds(
        southwest: gmaps.LatLng(
          min(currentLocation.latitude, _currentDestination.latitude),
          min(currentLocation.longitude, _currentDestination.longitude),
        ),
        northeast: gmaps.LatLng(
          max(currentLocation.latitude, _currentDestination.latitude),
          max(currentLocation.longitude, _currentDestination.longitude),
        ),
      );

      controller.animateCamera(
        gmaps.CameraUpdate.newLatLngBounds(bounds, 100),
      );
    } catch (e) {
      _showError('Camera update failed: ${e.toString()}');
    }
  }

  void _trimPolylineToCurrentLocation(Position position) {
    if (_fullRouteCoordinates.isEmpty) return;

    final closestIndex = _findClosestSegmentIndex(position);
    if (closestIndex == -1) return;

    _lastClosestSegmentIndex = closestIndex;

    // Create current position point
    final currentPoint = gmaps.LatLng(position.latitude, position.longitude);

    // Create remaining route
    final remainingRoute = _fullRouteCoordinates.sublist(closestIndex + 1);
    final newRoute = [currentPoint]..addAll(remainingRoute);

    // Only update if route actually changed
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

  int _findClosestSegmentIndex(Position position) {
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
      FFAppState().remainingDistance = 0;
      return;
    }

    if (_fullRouteDistance == 0) {
      _fullRouteDistance = _computePathDistance(_fullRouteCoordinates);
    }

    final traveledDistance = _computePathDistance(
        _fullRouteCoordinates.sublist(0, _lastClosestSegmentIndex + 1));

    _remainingDistance = max(0, _fullRouteDistance - traveledDistance);
    FFAppState().remainingDistance = _remainingDistance;
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
        if (mounted) _showError("Route rendering error");
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

  bool _shouldRecalculatePolyline(Position position) {
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

  double _distanceToPolyline(Position pos) {
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

  double _smoothBearing(double newBearing) {
    const smoothingFactor = 0.2;
    _lastBearing ??= newBearing;
    final smoothed =
        _lastBearing! * (1 - smoothingFactor) + newBearing * smoothingFactor;
    _lastBearing = smoothed;
    return smoothed;
  }

  void _updateCameraPosition(gmaps.LatLng newPosition, [double? heading]) {
    _cameraUpdateTimer?.cancel();
    _cameraUpdateTimer = Timer(const Duration(milliseconds: 500), () async {
      final controller = await _mapController.future;

      double? smoothedBearing =
          heading != null ? _smoothBearing(heading) : null;

      controller.animateCamera(
        smoothedBearing != null
            ? gmaps.CameraUpdate.newCameraPosition(
                gmaps.CameraPosition(
                  target: newPosition,
                  zoom: _cameraZoom,
                  bearing: smoothedBearing,
                ),
              )
            : gmaps.CameraUpdate.newLatLng(newPosition),
      );
    });
  }

  Future<void> _ensureLocationStream() async {
    if (_lastPosition != null) return;

    // Try to get the last known position immediately
    var lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      _handleNewPosition(lastPosition);
    } else {
      // If no last known position, start the stream
      await _checkLocationServices();
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => _checkLocationServices(),
        ),
      ),
    );
  }

  gmaps.LatLng _convertToGmapsLatLng(LatLng latLng) {
    return gmaps.LatLng(latLng.latitude, latLng.longitude);
  }

  void _showPermissionError() =>
      _showError('Location permissions are required for navigation');

  void _showLocationServiceError() =>
      _showError('Please enable location services for navigation');

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
          await _ensureLocationStream();
        },
        initialCameraPosition: gmaps.CameraPosition(
          target: _convertToGmapsLatLng(_currentDestination),
          zoom: _minCameraZoom,
        ),
        polylines: _polylines,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        markers: {
          if (_destinationIcon != null && !_allWaypointsCompleted)
            gmaps.Marker(
              markerId: const gmaps.MarkerId('destination'),
              position: _convertToGmapsLatLng(_currentDestination),
              icon: _destinationIcon!,
              zIndex: 2,
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

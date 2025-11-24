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

import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:geolocator/geolocator.dart';

class AllDriversMap extends StatefulWidget {
  const AllDriversMap({
    super.key,
    this.width,
    this.height,
    this.customMapStyle,
    this.darkMode = false, // let’s support light/dark marker
  });

  final double? width;
  final double? height;
  final String? customMapStyle;
  final bool darkMode;

  @override
  State<AllDriversMap> createState() => _AllDriversMapState();
}

class _AllDriversMapState extends State<AllDriversMap> {
  final Completer<gmaps.GoogleMapController> _mapController = Completer();
  final Set<gmaps.Marker> _markers = {};
  StreamSubscription<QuerySnapshot>? _driversSub;

  gmaps.LatLng? _initialPosition;

  gmaps.BitmapDescriptor? _carIcon; // custom marker icon

  // Manhattan fallback
  static const gmaps.LatLng _fallbackPosition = gmaps.LatLng(40.7831, -73.9712);

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    await _loadCarMarkerIcon(); // 🔑 ensure icon is loaded first
    await _getUserLocation();
    _subscribeToDrivers(); // 🔑 now start listening for drivers
  }

  @override
  void dispose() {
    _driversSub?.cancel();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      setState(() {
        _initialPosition = gmaps.LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint("Error getting location, using fallback: $e");
      setState(() {
        _initialPosition = _fallbackPosition;
      });
    }
  }

  Future<void> _loadCarMarkerIcon() async {
    try {
      final colorPrefix = widget.darkMode ? 'dark' : 'light';
      final assetPath = 'assets/images/${colorPrefix}_bike_icon.png';

      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();
      final icon = gmaps.BitmapDescriptor.fromBytes(bytes);

      if (mounted) setState(() => _carIcon = icon);
    } catch (e) {
      if (mounted) {
        setState(() => _carIcon = gmaps.BitmapDescriptor.defaultMarker);
      }
    }
  }

  void _subscribeToDrivers() {
    _driversSub = FirebaseFirestore.instance
        .collection("users")
        .where("driver", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      final newMarkers = <gmaps.Marker>{};

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) continue;

        final location = data["location"];

        double? lat;
        double? lng;

        if (location is GeoPoint) {
          lat = location.latitude;
          lng = location.longitude;
        } else if (location is Map) {
          final latValue = location["latitude"];
          final lngValue = location["longitude"];
          if (latValue is num && lngValue is num) {
            lat = latValue.toDouble();
            lng = lngValue.toDouble();
          }
        }

        if (lat == null || lng == null) continue;

        final marker = gmaps.Marker(
          markerId: gmaps.MarkerId(doc.id),
          position: gmaps.LatLng(lat, lng),
          icon: _carIcon ??
              gmaps.BitmapDescriptor.defaultMarker, // use custom icon
          infoWindow: gmaps.InfoWindow(
            title: data["name"] ?? "Driver",
          ),
        );
        newMarkers.add(marker);
      }

      if (mounted) {
        setState(() {
          _markers
            ..clear()
            ..addAll(newMarkers);
        });
      }
    }, onError: (e) {
      debugPrint("Error listening to drivers: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: _initialPosition == null
          ? const Center(child: CircularProgressIndicator())
          : gmaps.GoogleMap(
              initialCameraPosition: gmaps.CameraPosition(
                target: _initialPosition!,
                zoom: 14,
              ),
              onMapCreated: (controller) async {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
                if (widget.customMapStyle != null) {
                  controller.setMapStyle(widget.customMapStyle);
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              compassEnabled: true,
              zoomControlsEnabled: false,
            ),
    );
  }
}

//

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
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '/flutter_flow/lat_lng.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Alimap extends StatefulWidget {
  const Alimap({
    super.key,
    this.width,
    this.height,
    this.latlongs,
    required this.polylineWidth,
    required this.apiKey,
    this.polylineColor,
  });

  final double? width;
  final double? height;
  final List<LatLng>? latlongs;
  final double polylineWidth;
  final String apiKey;
  final Color? polylineColor;

  @override
  State<Alimap> createState() => _AlimapState();
}

class _AlimapState extends State<Alimap> {
  final Completer<gmaps.GoogleMapController> _controller = Completer();
  final Set<gmaps.Polyline> _polylines = {};
  final Set<gmaps.Marker> _markers = {};

  gmaps.LatLng _toGmapsLatLng(LatLng p) =>
      gmaps.LatLng(p.latitude, p.longitude);

  @override
  void initState() {
    super.initState();
    _createRoute();
  }

  Future<void> _createRoute() async {
    if (widget.latlongs == null || widget.latlongs!.isEmpty) return;

    final points = widget.latlongs!.map(_toGmapsLatLng).toList();

    for (int i = 0; i < points.length; i++) {
      _markers.add(gmaps.Marker(
        markerId: gmaps.MarkerId('marker_$i'),
        position: points[i],
        infoWindow: gmaps.InfoWindow(title: 'Point ${i + 1}'),
        icon: gmaps.BitmapDescriptor.defaultMarker,
      ));
    }

    if (points.length < 2) {
      setState(() {});
      return;
    }

    final origin = "${points.first.latitude},${points.first.longitude}";
    final destination = "${points.last.latitude},${points.last.longitude}";
    final waypoints = points.length > 2
        ? "&waypoints=" +
            points
                .sublist(1, points.length - 1)
                .map((p) => "${p.latitude},${p.longitude}")
                .join('|')
        : "";

    final url =
        "https://secure-ridge-22999-537c838d4a8a.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination$waypoints&key=$widget.apiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final polyline = data['routes'][0]['overview_polyline']['points'];
      List<PointLatLng> decoded = PolylinePoints().decodePolyline(polyline);

      final roadPoints =
          decoded.map((e) => gmaps.LatLng(e.latitude, e.longitude)).toList();

      setState(() {
        _polylines.add(gmaps.Polyline(
          polylineId: const gmaps.PolylineId('road_polyline'),
          points: roadPoints,
          color: widget.polylineColor ?? Colors.blue,
          width: widget.polylineWidth.toInt(),
        ));
      });
    } else {
      debugPrint("Directions API Error: ${data['status']}");
    }
  }

  void _onMapCreated(gmaps.GoogleMapController controller) {
    _controller.complete(controller);

    if (widget.latlongs != null && widget.latlongs!.isNotEmpty) {
      final bounds = _getLatLngBounds(widget.latlongs!);
      controller
          .animateCamera(gmaps.CameraUpdate.newLatLngBounds(bounds, 50.0));
    }
  }

  gmaps.LatLngBounds _getLatLngBounds(List<LatLng> points) {
    final sw = LatLng(
      points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
      points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
    );
    final ne = LatLng(
      points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
      points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
    );
    return gmaps.LatLngBounds(
      southwest: _toGmapsLatLng(sw),
      northeast: _toGmapsLatLng(ne),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.latlongs == null || widget.latlongs!.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[200],
        child: Center(
          child: Text(
            'No locations provided',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: gmaps.GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: gmaps.CameraPosition(
          target: _toGmapsLatLng(widget.latlongs!.first),
          zoom: 14.0,
        ),
        polylines: _polylines,
        markers: _markers,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}

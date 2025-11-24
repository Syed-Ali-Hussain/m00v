import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

String mapTheme(bool darkMode) {
  const darkMapTheme = '''[
    {
      "elementType": "geometry",
      "stylers": [{"color": "#0f161b"}]
    },
    {
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#aaaaaa"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#1d1d1d"}]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#666666"}]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [{"color": "#151A1D"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#888888"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [{"color": "#151F11"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#6b9a76"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [{"color": "#1d2428"}]
    },
    {
      "featureType": "road.arterial",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#cccccc"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#4d4d4d"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#eeeeee"}]
    },
    {
      "featureType": "road.local",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#999999"}]
    },
    {
      "featureType": "transit.line",
      "elementType": "geometry",
      "stylers": [{"color": "#444444"}]
    },
    {
      "featureType": "transit.station",
      "elementType": "geometry",
      "stylers": [{"color": "#3a3a3a"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#202d36"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#515c6d"}]
    }
  ]''';

  const lightMapTheme = '''[
    {
      "elementType": "geometry",
      "stylers": [{"color": "#f1f4f8"}]
    },
    {
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#f5f5f5"}]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#bdbdbd"}]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [{"color": "#d7dbe4"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [{"color": "#959b93"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#6b9a76"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [{"color": "#ffffff"}]
    },
    {
      "featureType": "road.arterial",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#dadada"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "featureType": "road.local",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#9e9e9e"}]
    },
    {
      "featureType": "transit.line",
      "elementType": "geometry",
      "stylers": [{"color": "#e5e5e5"}]
    },
    {
      "featureType": "transit.station",
      "elementType": "geometry",
      "stylers": [{"color": "#eeeeee"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#c9c9c9"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#9e9e9e"}]
    }
  ]''';

  return darkMode ? darkMapTheme : lightMapTheme;
}

LatLng latLongForUpload(dynamic position) {
  return LatLng(
    position['lat'] as double,
    position['lng'] as double,
  );
}

double averageRating(List<RatingStruct>? allRatings) {
  if (allRatings == null || allRatings.isEmpty) return 0.0;

  double total = 0.0;
  for (var rating in allRatings) {
    total += rating.ratingGiven;
  }

  return total / allRatings.length;
}

double druationPrice(
  DateTime startTime,
  DateTime endTime,
  double rate,
) {
  double minutes = endTime.difference(startTime).inMinutes.toDouble();
  return minutes * rate;
}

double applyPercentageDiscount(
  double percentageAmount,
  double basePrice,
) {
  double discount = (percentageAmount / 100) * basePrice;
  double finalPrice = basePrice - discount;
  return finalPrice;
}

double applyAbsoluteDiscount(
  double basePrice,
  double discount,
) {
  double finalPrice = basePrice - discount;
  if (finalPrice < 0) {
    finalPrice = 0;
  }
  return finalPrice;
}

double driverShareCalculator(
  double totalPrice,
  double sharePercentage,
) {
  if (totalPrice < 0 || sharePercentage < 0) {
    return 0;
  }
  return totalPrice * (sharePercentage / 100);
}

String currentLocationForDistanceMatrix(LatLng currentLoc) {
  return '${currentLoc.latitude},${currentLoc.longitude}';
}

String placeDetailToDistanceMatrix(
  double latitude,
  double longitude,
) {
  return '$latitude,$longitude';
}

double avgPrice(List<double>? prices) {
  if (prices == null || prices.isEmpty) {
    return 0.0; // Return 0 if no prices are provided
  }

  double sum = prices.reduce((a, b) => a + b); // Sum all prices
  return sum / prices.length;
}

double totalSum(List<double>? allPrices) {
  if (allPrices == null || allPrices.isEmpty) {
    return 0.0; // Return 0 if list is null or empty
  }

  return allPrices.reduce((a, b) => a + b);
}

int ridesToday(List<DateTime>? allDates) {
  if (allDates == null || allDates.isEmpty) {
    return 0; // Return 0 if list is null or empty
  }

  DateTime today = DateTime.now();
  return allDates
      .where((date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day)
      .length;
}

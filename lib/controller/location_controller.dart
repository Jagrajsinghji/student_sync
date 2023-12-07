import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_sync/features/profile/services/profile_service.dart';

class LocationController {
  final ProfileService _profileService;

  LatLng _currentLocation = const LatLng(0.0, 0.0);
  double _radiusInKiloMeters = 5;

  LocationController({required ProfileService profileService})
      : _profileService = profileService;

  Future<String> getLocationNameBasedOn(LatLng location) async {
    var placeMarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    return placeMarks.first.name ??
        placeMarks.first.subLocality ??
        placeMarks.first.locality ??
        placeMarks.first.subAdministrativeArea ??
        placeMarks.first.administrativeArea ??
        placeMarks.first.postalCode ??
        placeMarks.first.country ??
        "Somewhere in this beautiful world!";
  }

  Future<LatLng> getCurrentGPSLocation() async {
    try {
      var resp = await Geolocator.getLastKnownPosition();
      if (resp == null) {
        resp = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium);
        return _currentLocation = LatLng(resp.latitude, resp.longitude);
      }
      return _currentLocation = LatLng(resp.latitude, resp.longitude);
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return const LatLng(0, 0);
  }

  void setCurrentLocationFromMap(LatLng location, double radiusInKiloMeters) {
    _currentLocation = location;
    _radiusInKiloMeters = radiusInKiloMeters;
  }

  Future updateUserLocation(String userId) async => _profileService.updateUser(
      userId: userId, position: await getCurrentGPSLocation());

  LatLng getCurrentLocation() => _currentLocation;

  double getRadiusInMeters() => _radiusInKiloMeters * 1000;
}

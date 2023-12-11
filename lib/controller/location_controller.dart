import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_sync/features/profile/services/profile_service.dart';

class LocationController {
  final ProfileService _profileService;

  LatLng? _currentLocation;
  double _radiusInKiloMeters = 50;
  ValueNotifier<String> _currentLocationName = ValueNotifier("...");

  LocationController({required ProfileService profileService})
      : _profileService = profileService;

  Future<String> getLocationNameBasedOn(LatLng location) async {
    var placeMarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    return placeMarks.first.subLocality ??
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
      resp ??= await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      _currentLocation = LatLng(resp.latitude, resp.longitude);
      _currentLocationName.value =
          await getLocationNameBasedOn(_currentLocation!);
      return _currentLocation!;
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return const LatLng(0, 0);
  }

  Future<void> setCurrentLocationFromMap(
      LatLng location, double radiusInKiloMeters) async {
    _currentLocation = location;
    _radiusInKiloMeters = radiusInKiloMeters;
    _currentLocationName.value = await getLocationNameBasedOn(location);
  }

  Future updateUserLocation(String userId) async => _profileService.updateUser(
      userId: userId, position: await getCurrentGPSLocation());

  LatLng getCurrentLocation() => _currentLocation!;

  ValueNotifier<String> getCurrentLocationName() => _currentLocationName;

  double getRadiusInMeters() => _radiusInKiloMeters * 1000;
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_sync/controller/location_controller.dart';
import 'package:student_sync/utils/theme/colors.dart';

class PickLocationFromMap extends StatefulWidget {
  const PickLocationFromMap({super.key});

  @override
  State<PickLocationFromMap> createState() => _PickLocationFromMapState();
}

class _PickLocationFromMapState extends State<PickLocationFromMap> {
  final LocationController locationController = GetIt.I<LocationController>();
  late GoogleMapController mapController;

  late LatLng _center;
  final List<Circle> circles = [];
  final List<Marker> markers = [];
  double selectedRadiusInKiloMeters = 5;

  @override
  void initState() {
    _center = locationController.getCurrentLocation();
    circles.add(Circle(
        circleId: const CircleId("location"),
        center: _center,
        radius: 1000,
        fillColor: blueColor.withOpacity(.4),
        visible: true,
        consumeTapEvents: true,
        strokeWidth: 1));
    markers.add(const Marker(markerId: MarkerId("location")));
    selectedRadiusInKiloMeters = locationController.getRadiusInMeters() / 1000;
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pick Location"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
              onLongPress: (LatLng position) {
                _center = position;
                circles[0] = Circle(
                    circleId: const CircleId("location"),
                    center: _center,
                    radius: 1000,
                    fillColor: blueColor.withOpacity(.4),
                    visible: true,
                    consumeTapEvents: true,
                    strokeWidth: 1);
                markers[0] = Marker(
                  markerId: const MarkerId("location"),
                  position: _center,
                );
                setState(() {});
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              buildingsEnabled: true,
              fortyFiveDegreeImageryEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              mapToolbarEnabled: false,
              compassEnabled: true,
              circles: circles.toSet(),
              markers: markers.toSet(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Show results within ",
                        style: TextStyle(fontSize: 16)),
                    Text("${selectedRadiusInKiloMeters.toInt()} km",
                        style: const TextStyle(fontSize: 16))
                  ],
                ),
                Slider(
                  value: selectedRadiusInKiloMeters,
                  onChanged: (value) {
                    selectedRadiusInKiloMeters = value;
                    circles[0] = Circle(
                        circleId: const CircleId("location"),
                        center: _center,
                        radius: value,
                        fillColor: blueColor.withOpacity(.4),
                        visible: true,
                        consumeTapEvents: true,
                        strokeWidth: 1);
                    mapController
                        .animateCamera(CameraUpdate.zoomTo(getZoom(value)));
                    setState(() {});
                  },
                  min: 5,
                  max: 500,
                  activeColor: theme.primaryColor,
                  allowedInteraction: SliderInteraction.tapAndSlide,
                  label: "Distance in km",
                  inactiveColor: theme.colorScheme.primary,
                ),
                ElevatedButton(
                    onPressed: () {
                      locationController.setCurrentLocationFromMap(
                          _center, selectedRadiusInKiloMeters);
                      context.pop(true);
                    },
                    child: const Text("Update")),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getZoom(double radius) {
    double zoomLevel = 12;
    if (radius <= 5 && radius < 10) {
      return 12;
    } else if (radius >= 10 && radius < 20) {
      return 11;
    }
    return zoomLevel;
  }
}

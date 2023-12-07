import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/controller/location_controller.dart';
import 'package:student_sync/features/profile/models/user_profile_details.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class PeopleNearMe extends StatefulWidget {
  const PeopleNearMe({super.key});

  @override
  State<PeopleNearMe> createState() => _PeopleNearMeState();
}

class _PeopleNearMeState extends State<PeopleNearMe> {
  final APIController apiController = GetIt.I<APIController>();
  final LocationController locationController = GetIt.I<LocationController>();
  bool noUsers = false;

  @override
  void initState() {
    getNearbyPeople();
    super.initState();
  }

  void getNearbyPeople({LatLng? location}) async {
    apiController
        .getNearbyPeople(
            location ?? await locationController.getCurrentGPSLocation(),
            locationController.getRadiusInMeters())
        .then((value) => setState(() {
              if (value.isEmpty) {
                noUsers = true;
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: noUsers
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "No Users, Try expanding your radius or change location"),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          var resp = await context.push(AppRouter.mapScreen);
                          if ((resp as bool?) ?? false) {
                            getNearbyPeople(
                                location:
                                    locationController.getCurrentLocation());
                          }
                        },
                        child: const Text("Expand Area")),
                  )
                ],
              ),
            )
          : ValueListenableBuilder<List<UserProfileDetails>>(
              valueListenable: apiController.profiles,
              builder: (context, profiles, _) {
                return profiles.isEmpty
                    ? Center(
                        child: LoadingAnimationWidget.flickr(
                            leftDotColor: theme.primaryColor,
                            rightDotColor: theme.colorScheme.secondary,
                            size: 30),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: profiles.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (c, index) {
                          UserProfileDetails user = profiles.elementAt(0);
                          int reviewAvg = user.reviews.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.rating);
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                context.push(AppRouter.profile,
                                    extra: user.details.id);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary,
                                    boxShadow: [
                                      BoxShadow(
                                          color: theme.primaryColor
                                              .withOpacity(.7),
                                          offset: const Offset(.5, .5),
                                          blurRadius: 2,
                                          spreadRadius: .5)
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          width: 120,
                                          height: 120,
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  user.details.profileImage ??
                                                      "",
                                              fit: BoxFit.cover,
                                              errorWidget: (_, s, o) {
                                                return Lottie.asset(
                                                    Assets.profileLottie);
                                              }),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user.details.name,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text(user.details.email),
                                        Text(user.ownSkills
                                            .map((e) => e.name)
                                            .join(", ")),
                                        reviewAvg == 0
                                            ? const Text("No reviews.")
                                            : SizedBox(
                                                width: 150,
                                                height: 30,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (c, index) {
                                                    return Icon(
                                                      Icons.star_rate_outlined,
                                                      color: theme.primaryColor,
                                                    );
                                                  },
                                                  itemCount: reviewAvg,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }),
    );
  }
}

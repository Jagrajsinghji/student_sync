import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/controller/location_controller.dart';
import 'package:student_sync/features/channel/models/post.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/routing/app_router.dart';

import 'post_column.dart';

class GeneralChannel extends StatefulWidget {
  const GeneralChannel({super.key});

  @override
  State<GeneralChannel> createState() => _GeneralChannelState();
}

class _GeneralChannelState extends State<GeneralChannel> {
  final APIController apiController = GetIt.I<APIController>();
  final LocationController locationController = GetIt.I<LocationController>();

  @override
  void initState() {
    super.initState();
    getNearbyPosts();
  }

  void getNearbyPosts() async {
    apiController.getNearByPosts(locationController.getCurrentLocation(),
        locationController.getRadiusInMeters());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: StreamBuilder<List<Post>?>(
          stream: apiController.postsStream,
          builder: (context, snapshot) {
            List<Post> allPosts = snapshot.data ?? [];
            return snapshot.data == null
                ? Center(
                    child: LoadingAnimationWidget.flickr(
                        leftDotColor: theme.primaryColor,
                        rightDotColor: theme.colorScheme.primary,
                        size: 50),
                  )
                : allPosts.isEmpty
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Lottie.asset(Assets.noDataLottie),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    var resp =
                                        await context.push(AppRouter.mapScreen);
                                    if ((resp as bool?) ?? false) {
                                      getNearbyPosts();
                                    }
                                  },
                                  child: const Text("Expand Search Area")),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (c, index) {
                          Post post = allPosts.elementAt(index);
                          return GeneralPost(post: post, key: UniqueKey());
                        },
                        itemCount: allPosts.length,
                      );
          }),
    );
  }
}

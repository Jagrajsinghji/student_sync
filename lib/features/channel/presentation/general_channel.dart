import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/controller/location_controller.dart';
import 'package:student_sync/features/channel/models/post.dart';

import 'post_column.dart';

class GeneralChannel extends StatefulWidget {
  const GeneralChannel({super.key});

  @override
  State<GeneralChannel> createState() => _GeneralChannelState();
}

class _GeneralChannelState extends State<GeneralChannel> {
  final APIController apiController = GetIt.I<APIController>();
  final LocationController locationController = GetIt.I<LocationController>();
  List<Post> allPosts = <Post>[];

  @override
  void initState() {
    super.initState();
    _getAllPosts();
  }

  void _getAllPosts() {
    allPosts.clear();
    apiController
        .getNearByPosts(locationController.getCurrentLocation(),
            locationController.getRadiusInMeters())
        .then((value) => setState(() => allPosts.addAll(value)));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: allPosts.isEmpty
          ? Center(
              child: LoadingAnimationWidget.flickr(
                  leftDotColor: theme.primaryColor,
                  rightDotColor: theme.colorScheme.primary,
                  size: 50),
            )
          : ListView.builder(
              itemBuilder: (c, index) {
                Post post = allPosts.elementAt(index);
                return GeneralPost(post: post, key: UniqueKey());
              },
              itemCount: allPosts.length,
            ),
    );
  }
}

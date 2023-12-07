import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/controller/location_controller.dart';
import 'package:student_sync/features/profile/models/user_info.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/constants/enums.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key, required this.image});

  final File image;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final APIController apiController = GetIt.I<APIController>();
  final LocationController locationController = GetIt.I<LocationController>();
  late final UserInfo userInfo;
  final TextEditingController _captionController = TextEditingController();
  bool isLoading = false;
  late LatLng postLocation;

  @override
  void initState() {
    userInfo = apiController.getUserInfoSync();
    postLocation = locationController.getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Add Post")),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: CachedNetworkImage(
                            imageUrl: userInfo.profileImage ?? "",
                            errorWidget: (_, s, o) {
                              return Lottie.asset(Assets.profileLottie);
                            },
                            fit: BoxFit.cover),
                      ),
                    ),
                    title: Text(userInfo.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal)),
                  ),
                  Image.file(widget.image, height: 500),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: TextFormField(
                      controller: _captionController,
                      maxLines: 2,
                      decoration:
                          const InputDecoration(hintText: "Write Something..."),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: isLoading ? null : uploadPost,
                child: isLoading
                    ? LoadingAnimationWidget.flickr(
                        leftDotColor: theme.primaryColor,
                        rightDotColor: theme.colorScheme.secondary,
                        size: 30)
                    : const Text("Post"))
          ],
        ),
      ),
    );
  }

  void uploadPost() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        isLoading = true;
      });
      String imgUrl = await apiController.uploadPhoto(
          file: widget.image, type: PhotoType.Post);
      var resp = await apiController.createPost(
          position: postLocation,
          locationName:
              await locationController.getLocationNameBasedOn(postLocation),
          caption: _captionController.text,
          imgUrl: imgUrl);
      if (resp.statusCode == 201) {
        if (mounted) context.pop();
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
      Fluttertoast.showToast(
          msg: "Error while posting! ${e.toString()}",
          toastLength: Toast.LENGTH_LONG);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

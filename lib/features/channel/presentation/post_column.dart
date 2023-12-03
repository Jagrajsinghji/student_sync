import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/controller/bottom_nav_controller.dart';
import 'package:student_sync/features/channel/models/post.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class GeneralPost extends StatefulWidget {
  const GeneralPost({super.key, required this.post});

  final Post post;

  @override
  State<GeneralPost> createState() => _GeneralPostState();
}

class _GeneralPostState extends State<GeneralPost> {
  final APIController apiController = GetIt.I<APIController>();
  bool showHeartAnimation = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var post = widget.post;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (post.userId == apiController.getUserInfoSync().id) {
              GetIt.I<BottomNavController>().setIndex(3);
            } else {
              context.push(AppRouter.profile, extra: post.userId);
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CachedNetworkImage(
                          imageUrl: post.profileImage ?? post.userId,
                          errorWidget: (_, s, o) {
                            return Lottie.asset(Assets.profileLottie);
                          },
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(post.name ?? post.userId,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal)),
                      Text(DateFormat("hh:mm a, dd MMM").format(post.createdAt),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            onDoubleTap: likePost,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                    imageUrl: post.postImg,
                    height: 500,
                    errorWidget: (_, s, o) {
                      return const SizedBox(
                          height: 300,
                          child: Center(child: Text("Error while loading!")));
                    },
                    fit: BoxFit.cover),
                if (showHeartAnimation)
                  Transform.scale(
                      scale: 5, child: Lottie.asset(Assets.likeLottie))
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
          child: ReadMoreText(
            post.caption,
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor),
            lessStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor),
            preDataText: post.name,
            preDataTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: likePost,
          icon: widget.post.isLiked
              ? Image.asset(Assets.likePNG, height: 30, width: 30)
              : Image.asset(
                  Assets.notLikePNG,
                  height: 30,
                  width: 30,
                  color: theme.colorScheme.primary,
                ),
        )
      ],
    );
  }

  void likePost() {
    if (!widget.post.isLiked) {
      setState(() {
        showHeartAnimation = true;
      });
    }
    apiController.likePost(postId: widget.post.id).then((value) => setState(() {
          widget.post.isLiked = value;
        }));
    Timer(const Duration(seconds: 2), () {
      setState(() {
        showHeartAnimation = false;
      });
    });
  }
}

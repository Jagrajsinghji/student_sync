import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/features/channel/models/post.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class PostContainer extends StatefulWidget {
  const PostContainer({super.key, required this.post});

  final Post post;

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  final APIController apiController = GetIt.I<APIController>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var post = widget.post;
    return Center(
      child: GestureDetector(
        onTap: () {
          context.push(AppRouter.showPost, extra: post);
        },
        child: CachedNetworkImage(
            imageUrl: post.postImg,
            height: 500,
            errorWidget: (_, s, o) {
              return const SizedBox(
                  height: 300,
                  child: Center(child: Text("Error while loading!")));
            },
            fit: BoxFit.cover),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:student_sync/features/channel/models/post.dart';

class ShowPostPhoto extends StatelessWidget {
  const ShowPostPhoto({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CachedNetworkImage(
            imageUrl: post.postImg,
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
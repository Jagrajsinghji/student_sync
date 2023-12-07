import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/features/channel/models/post.dart';
import 'package:student_sync/features/chats/models/chat_info.dart';
import 'package:student_sync/features/chats/models/chat_user_info.dart';
import 'package:student_sync/features/profile/models/user_info.dart';
import 'package:student_sync/features/profile/models/user_profile_details.dart';
import 'package:student_sync/features/profile/presentation/post_container.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, this.userId});

  final String? userId;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final APIController apiController = GetIt.I<APIController>();
  UserProfileDetails? userProfile;
  int reviewAvg = 5;
  final List<Post> posts = [];
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() {
    apiController
        .getUserInfo(userId: widget.userId)
        .then((value) => setState(() {
              userProfile = value;
              reviewAvg = userProfile!.reviews.fold(0,
                  (previousValue, element) => previousValue + element.rating);
            }));
    apiController
        .getAllPostByUserId(userId: widget.userId)
        .then((value) => setState(() => posts
          ..clear()
          ..addAll(value)));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: widget.userId != null
            ? AppBar(
                title: const Text("Profile"),
              )
            : null,
        body: userProfile != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomScrollView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverList.list(children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: CachedNetworkImage(
                                  imageUrl:
                                      userProfile!.details.profileImage ?? "",
                                  fit: BoxFit.cover,
                                  errorWidget: (_, s, o) {
                                    return Lottie.asset(Assets.profileLottie);
                                  }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userProfile!.details.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(userProfile!.details.email),
                                reviewAvg == 0
                                    ? const Text("No reviews.")
                                    : SizedBox(
                                        width: 150,
                                        height: 30,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
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
                                if (widget.userId != null)
                                  SizedBox(
                                    height: 30,
                                    child: TextButton(
                                        style: const ButtonStyle(
                                            padding: MaterialStatePropertyAll(
                                                EdgeInsets.zero)),
                                        onPressed: () {},
                                        child: const Text("Add Review")),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (widget.userId != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: StreamBuilder<bool>(
                                    stream: apiController.isFollowingStream(
                                        apiController.getUserInfoSync().id,
                                        userProfile!.details.id),
                                    builder: (context, snapshot) {
                                      bool isFollowing = snapshot.data ?? false;
                                      return ElevatedButton(
                                          onPressed: () {
                                            if (isFollowing) {
                                              apiController.unFollowUser(
                                                  userProfile!.details.id,
                                                  apiController
                                                      .getUserInfoSync()
                                                      .id);
                                            } else {
                                              apiController.followUser(
                                                  userProfile!.details,
                                                  apiController
                                                      .getUserInfoSync());
                                            }
                                          },
                                          child: isFollowing
                                              ? const Text("Unfollow")
                                              : const Text("Follow"));
                                    }),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      UserInfo myInfo =
                                          apiController.getUserInfoSync();
                                      ChatUserInfo sender = ChatUserInfo(
                                          userId: myInfo.id,
                                          username: myInfo.name,
                                          userImage: myInfo.profileImage ?? "");

                                      ChatUserInfo receiver = ChatUserInfo(
                                          userId: userProfile!.details.id,
                                          username: userProfile!.details.name,
                                          userImage: userProfile!
                                                  .details.profileImage ??
                                              "");

                                      ChatInfo info =
                                          await apiController.sendMessageToUser(
                                        sender,
                                        receiver,
                                        "Hi!",
                                      );
                                      if (mounted) {
                                        context.push(AppRouter.chatScreen,
                                            extra: info);
                                      }
                                    },
                                    child: const Text("Send Hi!")),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Top skills"),
                                if (widget.userId == null)
                                  TextButton(
                                      onPressed: () async {
                                        var resp = await context.push(
                                            AppRouter.addSkills,
                                            extra: true);
                                        if (resp == true) {
                                          apiController.getUserInfo();
                                        }
                                      },
                                      child: const Text("Edit"))
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                ...userProfile!.ownSkills.map((skill) {
                                  return Chip(
                                      label: Text(skill.name,
                                          style: TextStyle(
                                              color: theme.primaryColor)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: const BorderSide(width: 0)),
                                      backgroundColor: Colors.grey.shade300);
                                })
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Learn skills"),
                                if (widget.userId == null)
                                  TextButton(
                                      onPressed: () async {
                                        var resp = await context.push(
                                            AppRouter.learnSkills,
                                            extra: true);
                                        if (resp == true) {
                                          apiController.getUserInfo();
                                        }
                                      },
                                      child: const Text("Edit"))
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                ...userProfile!.wantSkills.map((skill) {
                                  return Chip(
                                      label: Text(skill.name,
                                          style: TextStyle(
                                              color: theme.primaryColor)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: const BorderSide(width: 0)),
                                      backgroundColor: Colors.grey.shade300);
                                })
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: Text("Posts"),
                      ),
                      if (posts.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 40.0),
                          child: Center(
                            child: Text("No Posts"),
                          ),
                        ),
                    ]),
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                            childCount: posts.length, (context, index) {
                          var post = posts.elementAt(index);
                          return PostContainer(key: UniqueKey(), post: post);
                        }),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10))
                  ],
                ),
              )
            : Center(
                child: LoadingAnimationWidget.flickr(
                    leftDotColor: theme.primaryColor,
                    rightDotColor: theme.colorScheme.secondary,
                    size: 30),
              ));
  }
}

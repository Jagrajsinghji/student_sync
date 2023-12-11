import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/features/reviews/models/review.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key, required this.userId});

  final String userId;

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final APIController apiController = GetIt.I<APIController>();
  final TextEditingController _editingController = TextEditingController();
  List<Review> allReviews = [];
  bool isLoading = true;
  bool isAddingReview = false;
  int selectedStars = 0;

  void getAllReviews() {
    apiController
        .getAllReviews(userId: widget.userId)
        .then((value) => setState(() {
              allReviews
                ..clear()
                ..addAll(value)
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
              isLoading = false;
            }));
  }

  @override
  void initState() {
    getAllReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Reviews"),
      ),
      body: Column(
        children: [
          Expanded(
              child: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.flickr(
                          leftDotColor: theme.primaryColor,
                          rightDotColor: theme.colorScheme.primary,
                          size: 50),
                    )
                  : ListView.builder(
                      itemCount: allReviews.length,
                      itemBuilder: (_, index) {
                        Review review = allReviews[index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: CachedNetworkImage(
                                      imageUrl: review.revieweProfileImg,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.revieweName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        DateFormat("dd MMM yy")
                                            .format(review.createdAt),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        height: 30,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (c, index) {
                                            return Icon(
                                                Icons.star_rate_outlined,
                                                color: theme.primaryColor);
                                          },
                                          itemCount: review.rating,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                        ),
                                      ),
                                      Text(
                                        review.reviewComment,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      reverse: true,
                    )),
          if (widget.userId != apiController.getUserInfoSync().id)
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, bottom: 25, top: 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (c, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedStars = index + 1;
                                });
                              },
                              child: Icon(
                                Icons.star_rate_outlined,
                                color: selectedStars >= (index + 1)
                                    ? theme.primaryColor
                                    : Colors.grey,
                              ),
                            );
                          },
                          itemCount: 5,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                        ),
                      ),
                      TextField(
                          controller: _editingController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: "Write review...",
                              suffixIcon: isAddingReview
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        String review =
                                            _editingController.text.trim();
                                        if (review.isNotEmpty) {
                                          if (mounted) {
                                            setState(() {
                                              isAddingReview = true;
                                            });
                                          }
                                          Review? newReview =
                                              await apiController.createReview(
                                                  userId: widget.userId,
                                                  rating: selectedStars,
                                                  comment: review);
                                          if (newReview != null) {
                                            _editingController.clear();
                                            selectedStars = 0;
                                            allReviews
                                              ..add(newReview)
                                              ..sort((a, b) => b.createdAt
                                                  .compareTo(a.createdAt));
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Something went wrong!");
                                          }
                                          if (mounted) {
                                            setState(() {
                                              isAddingReview = false;
                                            });
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.send),
                                      iconSize: 25,
                                      color: theme.primaryColor),
                              border: InputBorder.none)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

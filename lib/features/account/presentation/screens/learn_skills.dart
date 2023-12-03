import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/features/account/models/skill.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/routing/app_router.dart';
import 'package:student_sync/utils/theme/colors.dart';

class LearnSkills extends StatefulWidget {
  const LearnSkills({super.key, required this.editSkills});

  final bool editSkills;

  @override
  State<LearnSkills> createState() => _LearnSkillsState();
}

class _LearnSkillsState extends State<LearnSkills> {
  final APIController apiController = GetIt.I<APIController>();
  var allSkills = <Skill>[];
  bool isLoading = false;
  ValueNotifier<String> errorString = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    GetIt.I<APIController>().getAllSkills().then((value) {
      if (mounted) {
        setState(() {
          allSkills.clear();
          allSkills.addAll(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: widget.editSkills ? AppBar() : null,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  if (!widget.editSkills)
                    const SizedBox(
                      height: 80,
                    ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Learn Some Skills ",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                          ))),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                      "Choose your interests and connect with people who are good at what you wanna learn. ",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(
                    height: 5,
                  ),
                  ValueListenableBuilder<String>(
                      valueListenable: errorString,
                      builder: (_, value, __) {
                        return Text(value,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.red));
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  if (allSkills.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 150.0),
                      child: LoadingAnimationWidget.flickr(
                          leftDotColor: theme.primaryColor,
                          rightDotColor: theme.colorScheme.primary,
                          size: 50),
                    )
                  else
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        ...allSkills.map((skill) {
                          return ValueListenableBuilder(
                              valueListenable: skill.isSelected,
                              builder: (c, selected, _) {
                                return GestureDetector(
                                    onTap: () {
                                      skill.isSelected.value = !selected;
                                      errorString.value = "";
                                      isValidSkillConditions();
                                    },
                                    child: Chip(
                                      label: Text(skill.name,
                                          style: TextStyle(
                                              color: selected
                                                  ? Colors.white
                                                  : Colors.blue)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: const BorderSide(width: 0)),
                                      backgroundColor: !selected
                                          ? Colors.grey.shade300
                                          : blueColor,
                                    ));
                              });
                        })
                      ],
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Center(
              child: ValueListenableBuilder<String>(
                  valueListenable: errorString,
                  builder: (_, value, __) {
                    return ElevatedButton(
                      onPressed:
                          isLoading || value.isNotEmpty ? null : _addSkills,
                      child: isLoading
                          ? LoadingAnimationWidget.flickr(
                              leftDotColor: theme.primaryColor,
                              rightDotColor: theme.colorScheme.secondary,
                              size: 30)
                          : const Text(
                              'Continue',
                            ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  bool isValidSkillConditions() {
    var selectedSkills = allSkills.where((element) => element.isSelected.value);
    if (selectedSkills.isEmpty) {
      errorString.value = "Select at least 1 skill";
      return false;
    }
    if (selectedSkills.length > 5) {
      errorString.value = "Cannot select more than 5 skills";
      return false;
    }
    return true;
  }

  void _addSkills() async {
    try {
      if (!isValidSkillConditions()) return;
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      var response = await apiController.addUserWantSkills(
          allSkills.where((element) => element.isSelected.value).toList());
      if (response.statusCode == 200 && mounted) {
        if (widget.editSkills) {
          context.pop();
        } else {
          apiController
              .updateUserOnboardingState(UserOnboardingState.onboarded);
          await apiController.getUserInfo();
          if (mounted) {
            context.go(AppRouter.home);
          }
        }
      }
    } on DioException catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
      Fluttertoast.showToast(
          msg: "Error while registering the user. ${e.response?.data}",
          toastLength: Toast.LENGTH_LONG);
    } on Exception catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
      Fluttertoast.showToast(
          msg: "Error while registering the user. ${e.toString()}",
          toastLength: Toast.LENGTH_LONG);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

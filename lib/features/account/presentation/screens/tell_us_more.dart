import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/features/account/models/institution.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/constants/extensions.dart';
import 'package:student_sync/utils/routing/app_router.dart';
import 'package:student_sync/utils/theme/colors.dart';

class TellUsMore extends StatefulWidget {
  const TellUsMore({super.key});

  @override
  State<TellUsMore> createState() => _TellUsMoreState();
}

class _TellUsMoreState extends State<TellUsMore> {
  final APIController apiController = GetIt.I<APIController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  File? _pickedImage;
  String? selectedProvince;
  Institution? selectedInstitute;
  bool isNameValid = false;
  bool isPhoneValid = false;
  bool isCityValid = false;
  bool isPostalValid = false;
  bool isLoading = false;

  final List<String> provinceList = [
    "Alberta",
    "British Columbia",
    "Manitoba",
    "New Brunswick",
    "Newfoundland and Labrador",
    "Northwest Territories",
    "Nova Scotia",
    "Nunavut",
    "Ontario",
    "Prince Edward Island",
    "Quebec",
    "Saskatchewan",
    "Yukon",
  ];
  final listOfInstitutes = <Institution>[];

  void _pickImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          'Choose an image source',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                child: const Text('Camera'),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                child: const Text('Gallery'),
              ),
            ),
          ),
        ],
      ),
    ).then((ImageSource? source) async {
      if (source == null) return;

      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return;

      setState(() => _pickedImage = File(pickedFile.path));
    });
  }

  @override
  void initState() {
    selectedProvince = provinceList[0];
    _getAllInstitutes();
    super.initState();
  }

  void _getAllInstitutes() {
    apiController.getAllInstitutes().then((value) => mounted
        ? setState(() {
            listOfInstitutes.clear();
            listOfInstitutes.addAll(value);
          })
        : null);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tell us more",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w900,
                            ))),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        height: 160,
                        width: 160,
                        child: _pickedImage == null
                            ? Lottie.asset(Assets.profileLottie)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                clipBehavior: Clip.antiAlias,
                                child: Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    Center(
                        child: TextButton(
                      onPressed: _pickImage,
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text(
                        "${_pickedImage == null ? "Upload" : "Change"} Profile Picture",
                        style: const TextStyle(color: blueColor),
                      ),
                    )),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintText: "Name",
                            ),
                            validator: (String? name) {
                              isNameValid = name != null && name.isNotEmpty;
                              if (!isNameValid) {
                                return "Name must not be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: "Phone Number",
                            ),
                            validator: (String? number) {
                              isPhoneValid = number != null &&
                                  number.isCanadianPhoneNumber();
                              if (!isPhoneValid) {
                                return "Invalid Phone Number";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownMenu(
                              hintText: "Institute",
                              onSelected: (inst) {
                                setState(() {
                                  selectedInstitute = inst;
                                });
                              },
                              errorText: selectedInstitute == null
                                  ? "Please select your institute"
                                  : null,
                              trailingIcon: const Icon(Icons.arrow_drop_down),
                              menuHeight: 200,
                              inputDecorationTheme: const InputDecorationTheme(
                                  border: UnderlineInputBorder()),
                              width: MediaQuery.of(context).size.width - 40,
                              menuStyle: MenuStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  side: const MaterialStatePropertyAll(
                                      BorderSide(color: Colors.black))),
                              dropdownMenuEntries: [
                                ...listOfInstitutes.map((inst) {
                                  return DropdownMenuEntry(
                                      value: inst, label: inst.name);
                                })
                              ]),
                          const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _cityController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "City",
                            ),
                            validator: (String? city) {
                              isCityValid = city != null && city.isNotEmpty;
                              if (!isCityValid) {
                                return "City must not be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _postalController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "Postal Code",
                            ),
                            validator: (String? code) {
                              isPostalValid =
                                  code != null && code.isCanadianPostalCode();
                              if (!isPostalValid) {
                                return "Invalid Postal Code";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownMenu(
                              hintText: "Province",
                              onSelected: (province) {
                                setState(() {
                                  selectedProvince = province;
                                });
                              },
                              errorText: selectedProvince == null
                                  ? "Please select your province"
                                  : null,
                              trailingIcon: const Icon(Icons.arrow_drop_down),
                              inputDecorationTheme: const InputDecorationTheme(
                                  border: UnderlineInputBorder()),
                              width: MediaQuery.of(context).size.width - 40,
                              menuStyle: MenuStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  side: const MaterialStatePropertyAll(
                                      BorderSide(color: Colors.black))),
                              menuHeight: 300,
                              requestFocusOnTap: false,
                              dropdownMenuEntries: [
                                ...provinceList.map((pro) {
                                  return DropdownMenuEntry(
                                      value: pro, label: pro);
                                })
                              ]),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: valueListenableNestedBuilder<TextEditingValue>(
                    values: [
                      _nameController,
                      _phoneController,
                      _cityController,
                      _postalController,
                    ],
                    child: Builder(builder: (context) {
                      bool isEnabled = isNameValid &&
                          isPhoneValid &&
                          isCityValid &&
                          isPostalValid &&
                          selectedProvince != null &&
                          selectedInstitute != null &&
                          _pickedImage != null;
                      return ElevatedButton(
                        onPressed:
                            (isEnabled & !isLoading) ? _onClickContinue : null,
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
                )),
          ],
        ),
      ),
    );
  }

  Widget valueListenableNestedBuilder<T>(
      {required List<ValueListenable<T>> values, required Widget child}) {
    if (values.isEmpty) {
      return child;
    }
    return ValueListenableBuilder<T>(
        valueListenable: values.removeLast(),
        builder: (_, value, __) {
          return valueListenableNestedBuilder(values: values, child: child);
        });
  }

  void _onClickContinue() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }

        ///upload profile picture
        String profileUrl = await apiController.uploadPhoto(
            file: _pickedImage!, type: PhotoType.ProfilePicture);

        ///update data in db
        var response = await apiController.updateUser(
            name: _nameController.text,
            city: _cityController.text,
            country: "Canada",
            institutionId: selectedInstitute?.id,
            mobileNumber: _phoneController.text,
            province: selectedProvince,
            postalCode: _postalController.text,
            profileImage: profileUrl);
        if (response != null) {
          if (mounted) {
            apiController
                .updateUserOnboardingState(UserOnboardingState.registered);
            context.go(AppRouter.studentIdCapture);
            // apiController.updateUserOnboardingState(UserOnboardingState.idAdded);
            // context.go(AppRouter.addSkills);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Error while updating data $response",
              toastLength: Toast.LENGTH_LONG);
        }
      } on DioException catch (e, s) {
        debugPrintStack(stackTrace: s, label: e.toString());
        Fluttertoast.showToast(
            msg: "Error while updating the user info. ${e.response?.data}",
            toastLength: Toast.LENGTH_LONG);
      } on Exception catch (e, s) {
        debugPrintStack(stackTrace: s, label: e.toString());
        Fluttertoast.showToast(
            msg: "Error while updating the user info. ${e.toString()}",
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
}

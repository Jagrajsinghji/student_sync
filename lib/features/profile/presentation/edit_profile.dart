import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:student_sync/features/profile/models/user_info.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/constants/extensions.dart';
import 'package:student_sync/utils/theme/colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.userInfo});

  final UserInfo userInfo;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final APIController apiController = GetIt.I<APIController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _instituteController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  File? _pickedImage;
  String? selectedProvince;
  Institution? selectedInstitute;
  bool isNameValid = true;
  bool isPhoneValid = true;
  bool isCityValid = true;
  bool isPostalValid = true;
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
    getUserInfo();
    _getAllInstitutes();
    super.initState();
  }

  void _getAllInstitutes() {
    apiController.getAllInstitutes().then((value) => mounted
        ? setState(() {
            listOfInstitutes.clear();
            listOfInstitutes.addAll(value);
            selectedInstitute = listOfInstitutes.firstWhere(
                (element) => element.id == widget.userInfo.institutionId,
                orElse: () => listOfInstitutes.first);
            _instituteController.text = selectedInstitute!.name;
          })
        : null);
  }

  void getUserInfo() async {
    var userInfo = widget.userInfo;
    _nameController.text = userInfo.name;
    _phoneController.text = userInfo.mobileNumber;
    _cityController.text = userInfo.city;
    _postalController.text = userInfo.postalCode;
    selectedProvince = provinceList.firstWhere(
        (element) => element.toLowerCase() == userInfo.province.toLowerCase(),
        orElse: () => provinceList.first);
    _provinceController.text = selectedProvince!;
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
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Edit Profile"),
        ),
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
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        height: 160,
                        width: 160,
                        child: _pickedImage == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(120),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: CachedNetworkImage(
                                      imageUrl:
                                          widget.userInfo.profileImage ?? "",
                                      fit: BoxFit.cover,
                                      errorWidget: (_, s, o) {
                                        return Lottie.asset(
                                            Assets.profileLottie);
                                      }),
                                ),
                              )
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
                      child: const Text(
                        "Change Profile Picture",
                        style: TextStyle(color: blueColor),
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
                              controller: _instituteController,
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
                              controller: _provinceController,
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
                          selectedInstitute != null;
                      return ElevatedButton(
                        onPressed:
                            (isEnabled & !isLoading) ? _onClickContinue : null,
                        child: isLoading
                            ? LoadingAnimationWidget.flickr(
                                leftDotColor: theme.primaryColor,
                                rightDotColor: theme.colorScheme.secondary,
                                size: 30)
                            : const Text(
                                'Update',
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
        String? profileUrl;
        if (_pickedImage != null) {
          ///upload profile picture
          profileUrl = await apiController.uploadPhoto(
              file: _pickedImage!, type: PhotoType.ProfilePicture);
        }

        ///update data in db
        var response = await apiController.updateUser(
            name: _nameController.text,
            city: _cityController.text,
            country: "Canada",
            institutionId: selectedInstitute?.id,
            mobileNumber: _phoneController.text,
            province: selectedProvince,
            profileImage: profileUrl);
        if (response != null) {
          if (mounted) {
            context.pop();
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

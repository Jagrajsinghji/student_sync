import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/utils/constants/extensions.dart';
import 'package:student_sync/utils/routing/app_router.dart';
import 'package:student_sync/utils/theme/colors.dart';

class TellUsMore extends StatefulWidget {
  const TellUsMore({super.key});

  @override
  State<TellUsMore> createState() => _TellUsMoreState();
}

class _TellUsMoreState extends State<TellUsMore> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _studentController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  File? _pickedImage;
  String? selectedProvince;
  bool isNameValid = false;
  bool isPhoneValid = false;
  bool isStudentIdValid = false;
  bool isCityValid = false;
  bool isPostalValid = false;

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

  void _pickImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          'Choose image source',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                backgroundColor: const MaterialStatePropertyAll(Colors.black)),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text(
              'Camera',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                backgroundColor: const MaterialStatePropertyAll(Colors.black)),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text(
              'Gallery',
              style: TextStyle(color: Colors.white),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            ? Lottie.asset("assets/profileLottie.json")
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
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _studentController,
                            decoration: const InputDecoration(
                              hintText: "Student ID",
                            ),
                            validator: (String? id) {
                              isStudentIdValid = id != null && id.length >= 5;
                              if (!isStudentIdValid) {
                                return "Invalid Student ID";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _cityController,
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
                              dropdownMenuEntries: [
                                ...provinceList.map((pro) {
                                  return DropdownMenuEntry(
                                      value: pro, label: pro);
                                }).toList()
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
                      _studentController,
                      _cityController,
                      _postalController,
                    ],
                    child: Builder(builder: (context) {
                      bool isEnabled = isNameValid &&
                          isPhoneValid &&
                          isStudentIdValid &&
                          isCityValid &&
                          isPostalValid &&
                          selectedProvince != null &&
                          _pickedImage != null;
                      return ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          minimumSize:
                              MaterialStateProperty.all(const Size(200, 45)),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey;
                              }
                              return Colors.black;
                            },
                          ),
                        ),
                        onPressed: isEnabled
                            ? () {
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRouter.addSkills);
                              }
                            : null,
                        child: const Text(
                          'Continue',
                          style: TextStyle(color: Colors.white),
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
}

import 'package:flutter/material.dart';
import 'package:student_sync/features/account/models/skill.dart';
import 'package:student_sync/utils/constants/colors.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class AddSkills extends StatefulWidget {
  const AddSkills({super.key});

  @override
  State<AddSkills> createState() => _AddSkillsState();
}

class _AddSkillsState extends State<AddSkills> {
  var skills = <Skill>[
    Skill(id: "1", name: "🖌️Painting"),
    Skill(id: "2", name: "Cooking"),
    Skill(id: "3", name: "Guitar"),
    Skill(id: "4", name: "Gardening"),
    Skill(id: "5", name: "Driving"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    height: 80,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Add Your Skills",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                          ))),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                      "Show people what skills you got and help them in learning what you are good at.",
                      style: TextStyle(fontSize: 14)),
                  const SizedBox(
                    height: 25,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      ...skills.map((skill) {
                        return ValueListenableBuilder(
                            valueListenable: skill.isSelected,
                            builder: (c, selected, _) {
                              return GestureDetector(
                                  onTap: () {
                                    skill.isSelected.value = !selected;
                                  },
                                  child: Chip(
                                    label: Text(skill.name,style:  TextStyle(color:
                                    selected?
                                        Colors.white
                                        :
                                    Colors.blue)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
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
            padding: const EdgeInsets.only(bottom:20.0),
            child: Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.black;
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.learnSkills);
                },
                child: const Text('Continue',style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

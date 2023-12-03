import 'package:student_sync/features/account/models/skill.dart';
import 'package:student_sync/features/profile/models/user_info.dart';
import 'package:student_sync/features/reviews/models/review.dart';

class UserProfileDetails {
  UserInfo details;
  final List<Skill> ownSkills;
  final List<Skill> wantSkills;
  final List<Review> reviews;

  UserProfileDetails(
      {required this.details,
      required this.ownSkills,
      required this.wantSkills,
      required this.reviews});

  factory UserProfileDetails.fromMap(Map data) {
    return UserProfileDetails(
        details: UserInfo.fromMap(data['details']),
        ownSkills:
            (data['ownSkills'] as List).map((e) => Skill.fromMap(e)).toList(),
        wantSkills:
            (data['wantSkills'] as List).map((e) => Skill.fromMap(e)).toList(),
        reviews:
            (data['reviews'] as List).map((e) => Review.fromMap(e)).toList());
  }

  void updateInfo(UserInfo userInfo) => details = userInfo;
}

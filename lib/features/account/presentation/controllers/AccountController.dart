import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_sync/features/account/models/institution.dart';
import 'package:student_sync/features/account/models/skill.dart';
import 'package:student_sync/features/account/services/account_service.dart';
import 'package:student_sync/features/account/services/skill_service.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/constants/shared_pref_keys.dart';

class AccountController {
  final AccountService _accountService;
  final SkillService _skillService;
  final SharedPreferences _preferences;

  AccountController(this._preferences,
      {required SkillService skillService,
      required AccountService accountService})
      : _skillService = skillService,
        _accountService = accountService;

  final _listOfInstitutes = <Institution>[];
  final _listOfSkills = <Skill>[];

  Future<List<Institution>> getAllInstitutes() async {
    if (_listOfInstitutes.isNotEmpty) return _listOfInstitutes;
    var value = await _accountService.getAllInstitutions();
    _listOfInstitutes.clear();
    _listOfInstitutes.addAll(value);
    return _listOfInstitutes;
  }

  Future<List<Skill>> getAllSkills() async {
    if (_listOfSkills.isNotEmpty) {
      for (var element in _listOfSkills) {
        element.isSelected.value = false;
      }
      return _listOfSkills;
    }
    var value = await _skillService.getAllSkills();
    _listOfSkills.clear();
    _listOfSkills.addAll(value);
    return _listOfSkills;
  }

  void updateUserOnboardingState(UserOnboardingState state) {
    _preferences.setString(SharedPrefKeys.userOnboardingStatus, state.name);
  }

  UserOnboardingState getUserOnboardingState() {
    var state = _preferences.getString(SharedPrefKeys.userOnboardingStatus);
    if (state == null) {
      return UserOnboardingState.none;
    }
    return UserOnboardingState.values
        .firstWhere((element) => element.name == state);
  }

  void saveUserData(String email, String userId) {
    _preferences.setString(SharedPrefKeys.userOnboardingEmail, email);
    _preferences.setString(SharedPrefKeys.userOnboardingId, userId);
  }

  String? getSavedUserEmail() {
    return _preferences.getString(SharedPrefKeys.userOnboardingEmail);
  }

  String? getSavedUserId() {
    return _preferences.getString(SharedPrefKeys.userOnboardingId);
  }

  void logout() {
    _preferences.clear();
  }
}

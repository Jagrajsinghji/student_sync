import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_sync/features/account/models/institution.dart';
import 'package:student_sync/features/account/models/skill.dart';
import 'package:student_sync/features/account/services/account_service.dart';
import 'package:student_sync/features/account/services/skill_service.dart';
import 'package:student_sync/features/channel/models/post.dart';
import 'package:student_sync/features/channel/services/post_service.dart';
import 'package:student_sync/features/chats/models/chat_info.dart';
import 'package:student_sync/features/chats/models/chat_message.dart';
import 'package:student_sync/features/chats/models/chat_user_info.dart';
import 'package:student_sync/features/chats/services/chat_service.dart';
import 'package:student_sync/features/people/services/people_service.dart';
import 'package:student_sync/features/profile/models/user_info.dart';
import 'package:student_sync/features/profile/models/user_profile_details.dart';
import 'package:student_sync/features/profile/services/profile_service.dart';
import 'package:student_sync/features/reviews/models/review.dart';
import 'package:student_sync/features/reviews/services/review_service.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/constants/shared_pref_keys.dart';

class APIController {
  final AccountService _accountService;
  final SkillService _skillService;
  final SharedPreferences _preferences;
  final ProfileService _profileService;
  final ChatService _chatService;
  final PeopleService _peopleService;
  final PostService _postService;
  final ReviewService _reviewService;

  APIController(this._preferences,
      {required SkillService skillService,
      required AccountService accountService,
      required ProfileService profileService,
      required ChatService chatService,
      required PeopleService peopleService,
      required PostService postService,
      required ReviewService reviewService})
      : _skillService = skillService,
        _accountService = accountService,
        _profileService = profileService,
        _chatService = chatService,
        _peopleService = peopleService,
        _postService = postService,
        _reviewService = reviewService;

  final _listOfInstitutes = <Institution>[];
  final _listOfSkills = <Skill>[];
  String? _userId;
  UserProfileDetails? _userInfo;
  final StreamController<List<UserProfileDetails>?> _profilesController =
      StreamController<List<UserProfileDetails>?>.broadcast();
  final StreamController<List<Post>?> _postsController =
      StreamController<List<Post>?>.broadcast();

  Stream<List<UserProfileDetails>?> get profilesStream =>
      _profilesController.stream;

  Stream<List<Post>?> get postsStream => _postsController.stream;

  ///---------- Skill Service APIs -----------------///

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

  Future<Response> addUserOwnSkills(List<Skill> skills) =>
      _skillService.addUserOwnSkills(_userId!, skills);

  Future<Response> addUserWantSkills(List<Skill> skills) =>
      _skillService.addUserWantSkills(_userId!, skills);

  Future<List<String>> getUserOwnSkills(String? userId) =>
      _skillService.getUserOwnSkills(userId ?? _userId!);

  Future<List<String>> getUserWantSkills(String? userId) =>
      _skillService.getUserWantSkills(userId ?? _userId!);

  ///---------- Account Service APIs -----------------///

  Future<Response> registerUser(
          {required String email,
          required String password,
          required LatLng position}) =>
      _accountService.registerUser(
          email: email, password: password, position: position);

  Future<List<Institution>> getAllInstitutes() async {
    if (_listOfInstitutes.isNotEmpty) return _listOfInstitutes;
    var value = await _accountService.getAllInstitutions();
    _listOfInstitutes.clear();
    _listOfInstitutes.addAll(value);
    return _listOfInstitutes;
  }

  Future<Response> sendVerificationEmail(String email) =>
      _accountService.sendVerificationEmail(email);

  Future<Response> login({required String email, required String password}) =>
      _accountService.login(email: email, password: password);

  ///---------- SharedPreferences APIs -----------------///
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
    _userId = userId;
    _preferences.setString(SharedPrefKeys.userOnboardingEmail, email);
    _preferences.setString(SharedPrefKeys.userOnboardingId, userId);
  }

  String? getSavedUserEmail() {
    return _preferences.getString(SharedPrefKeys.userOnboardingEmail);
  }

  String? getSavedUserId() {
    return _userId = _preferences.getString(SharedPrefKeys.userOnboardingId);
  }

  void logout() {
    _preferences.clear();
  }

  ///---------- Profile Service APIs -----------------///
  Future<UserProfileDetails?> getUserInfo({String? userId}) async {
    if (userId != null && userId != _userId) {
      return _profileService.getProfileInfo(userId);
    }
    if (_userId != null) {
      return _userInfo = await _profileService.getProfileInfo(_userId!);
    }
    return null;
  }

  UserInfo getUserInfoSync() => _userInfo!.details;

  Future<UserInfo?> updateUser(
      {String? name,
      String? institutionId,
      String? city,
      String? province,
      String? country,
      String? mobileNumber,
      String? studentIdImage,
      String? profileImage,
      String? postalCode,
      String? notificationToken,
      LatLng? position}) async {
    var data = await _profileService.updateUser(
        userId: _userId!,
        name: name,
        institutionId: institutionId,
        city: city,
        province: province,
        country: country,
        mobileNumber: mobileNumber,
        studentIdImage: studentIdImage,
        profileImage: profileImage,
        postalCode: postalCode,
        position: position);
    if (data != null) {
      _userInfo?.updateInfo(data);
    }
    return data;
  }

  Future uploadPhoto({required File file, required PhotoType type}) =>
      _profileService.uploadPhoto(userId: _userId!, file: file, type: type);

  void followUser(UserInfo otherUser, UserInfo myInfo) =>
      _profileService.followUser(otherUser, myInfo);

  void unFollowUser(String otherUserId, String myUserId) =>
      _profileService.unFollowUser(otherUserId, myUserId);

  Stream<bool> isFollowingStream(String myUserId, String otherUserId) =>
      _profileService.isFollowingStream(myUserId, otherUserId);

  ///---------- Chat Service APIs -----------------///

  Stream<List<ChatInfo>> getAllChatsStream() =>
      _chatService.getAllChatsStream(_userId!);

  Stream<List<ChatMessage>> getChatHistoryStream(String chatId) =>
      _chatService.getChatHistoryStream(chatId);

  Future<ChatInfo> sendMessageToUser(
          ChatUserInfo sender, ChatUserInfo receiver, String message,
          {String? chatId}) =>
      _chatService.sendMessageToUser(sender, receiver, message);

  Future seenLastMessage(String chatId, String userId) =>
      _chatService.seenLastMessage(chatId, userId);

  Future<void> deleteChat(String chatId) => _chatService.deleteChat(chatId);

  ///---------- Post Service APIs -----------------///

  Future<Response> createPost(
          {required String caption,
          required String imgUrl,
          required LatLng position,
          required String locationName}) =>
      _postService.createPost(
          position: position,
          locationName: locationName,
          userId: _userId!,
          caption: caption,
          imgUrl: imgUrl);

  Future<List<Post>> getAllPosts() => _postService.getAllPosts();

  Future<List<Post>> getAllPostByUserId({String? userId}) =>
      _postService.getAllPostsByUserId(userId ?? _userId!);

  Future<List<Post>> getNearByPosts(
      LatLng position, double radiusInMeters) async {
    _postsController.sink.add(null);
    var value = await _postService.getNearByPosts(position, radiusInMeters);
    value.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _postsController.sink.add(value);
    return value;
  }

  Future<bool> likePost({required String postId}) =>
      _postService.likePost(userId: _userId!, postId: postId);

  ///---------- Review Service APIs -----------------///

  Future<List<Review>> getAllReviews({String? userId}) =>
      _reviewService.getAllReviews(userId ?? _userId!);

  Future<Review?> createReview(
      {required String userId,
      required int rating,
      required String comment}) async {
    var resp = await _reviewService.createReview(
        userId: userId,
        reviewerUserId: _userId!,
        rating: rating,
        comment: comment);
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      Map data = {
        ...resp.data,
        "reviewe_name": _userInfo!.details.name,
        "reviewe_profile_img_name": _userInfo!.details.profileImage,
        "userId": userId
      };
      return Review.fromMap(data);
    }
    return null;
  }

  ///---------- People Service APIs ---------------///
  Future<List<UserProfileDetails>> getNearbyPeople(
      LatLng position, double radiusInMeters) async {
    _profilesController.sink.add(null);
    var resp = await _peopleService.getNearbyPeople(
        _userId!, position, radiusInMeters);
    _profilesController.sink.add(resp);
    return resp;
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
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
        _reviewService = reviewService {
    _userId = getSavedUserId();
    getUserInfo();
  }

  final _listOfInstitutes = <Institution>[];
  final _listOfSkills = <Skill>[];
  final _listOfAllPosts = <Post>[];
  String? _userId;
  UserProfileDetails? _userInfo;

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
          {required String email, required String password}) =>
      _accountService.registerUser(email: email, password: password);

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
    if (_userInfo != null && userId == null) return _userInfo;
    if (userId != null) {
      return _profileService.getProfileInfo(userId);
    } else if (_userId != null) {
      return _userInfo = (await _profileService.getProfileInfo(_userId!));
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
          String? notificationToken}) async{
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
      );
    if(data!=null) {
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
      {required String caption, required String imgUrl}) async {
    var response = await _postService.createPost(
        userId: _userId!, caption: caption, imgUrl: imgUrl);
    if (response.statusCode == 201) {
      var data = {
        "profile_img_name": response.data['profile_img_name'],
        "name": response.data['name'],
      }..addAll(response.data['newpost']);
      Post post = Post.fromMap(data);
      _listOfAllPosts.insert(0, post);
    }
    return response;
  }

  Future<List<Post>> getAllPosts() async {
    if (_listOfAllPosts.isNotEmpty) return _listOfAllPosts;
    var value = await _postService.getAllPosts();
    _listOfAllPosts.clear();
    _listOfAllPosts.addAll(value);
    _listOfAllPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _listOfAllPosts;
  }

  Future<List<Post>> getAllPostByUserId({String? userId}) =>
      _postService.getAllPostsByUserId(userId ?? _userId!);

  Future<List<Post>> getNearByPosts(int radiusInMeters) =>
      _postService.getNearByPosts(radiusInMeters);

  Future<bool> likePost({required String postId}) =>
      _postService.likePost(userId: _userId!, postId: postId);

  ///---------- Review Service APIs -----------------///

  Future<List<Review>> getAllReviews({String? userId}) =>
      _reviewService.getAllReviews(userId ?? _userId!);

  Future<Response> createReview(
          {required String userId,
          required String reviewerUserId,
          required int rating,
          required String comment}) =>
      _reviewService.createReview(
          userId: userId,
          reviewerUserId: reviewerUserId,
          rating: rating,
          comment: comment);

  ///---------- People Service APIs ---------------///
  Future<List<UserProfileDetails>> getNearbyPeople(
          String userId, int radiusInMeters) =>
      _peopleService.getNearbyPeople(userId, radiusInMeters);
}

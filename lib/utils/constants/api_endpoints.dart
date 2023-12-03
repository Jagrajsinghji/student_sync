class APIEndpoints {
  static const String baseUrl = "https://successful-helmet-calf.cyclic.app";

  ///POST
  ///body: {
  ///   "email": "yin@email.com",
  ///   "password": "password123"
  ///   "location":{"type":"Point", "coordinates":[20,30]}
  /// }
  ///
  static const String registerUser = "/users/pre";

  static const String getAllInstitutions = "/institutions";

  ///
  ///POST
  ///body:{
  ///   "email": "yinthuaye.ca@gmail.com"
  /// }
  ///
  static const String sendVerificationEmail = "/email/send/grid";

  ///
  ///PATCH
  ///Path param: userId
  ///body:{
  ///   "name": "Eve Adams",
  ///   "email": "eve.a@example.com",
  ///   "password": "password123",
  ///   "user_status": "false",
  ///   "institutionId": "653035d8479e5254a00c5307",
  ///   "city": "Toronto",
  ///   "province": "Ontario",
  ///   "country": "Canada",
  ///   "mobile_number": "999-888-7777",
  ///   "student_id_img_name": "student_id_img_5.jpg",
  ///   "profile_img_name": "profile_img_5.jpg",
  ///   "postal_code": "M1S2S3",
  ///   "notificationToken":"token!fjdlkfj",
  ///   "location":{"type":"Point", "coordinates":[20,30]}
  /// }
  ///
  static const String updateUser = "/users/";

  static const String getAllSkills = "/skills";

  ///
  /// POST
  ///Path param: userId
  /// body:{
  ///     "ownSkills": ["653e8b3a9c9708c4ecd7bd84"]
  /// }
  ///
  static const String addOwnSkillByUserId = "/userownskills/add/";

  ///
  ///POST
  ///Path param: userId
  ///body:{
  ///     "wantSkills": ["65428e2779f201bbc3bb2df4", "65428e2779f201bbc3bb2df3"]
  /// }
  static const String addWantSkillByUserId = "/userwantskills/add/";

  ///
  ///POST
  ///body {
  ///     "email": "yin@email.com",
  ///     "password": "P@ssword"
  /// }
  static const String login = "/users/login";

  ///
  ///GET
  ///path parameter id
  static const String userInfoById = "/users/";

  ///
  ///POST
  ///body {
  /// "userId": "655ea0900eeb394fdcfbcc3b",
  /// "caption": "Beautiful sunrise!",
  /// "coordinate": [43.450053, 80.4935],
  /// "postImg": "https://firebasestorage.googleapis.com/v0/b/studentsync624.appspot.com/o/ProfilePictures%2F65629d4189388b03dbc4ef5c?alt=media&token=ef5270a1-f041-4b82-96b7-31ea588e573f",
  /// "numOfLike": 0
  /// }
  static const String createPost = "/posts/create";

  ///
  ///GET
  ///
  static const String getAllPosts = "/posts";

  ///
  ///GET
  ///params
  ///     "userId":"655ea0900eeb394fdcfbcc3b"
  ///
  static const String getAllPostsByUserId = "/postsById";

  ///
  ///POST
  ///body{
  ///     "userId": "65455a467f0b90e91cc18b0b",
  ///     "postId": "6556cd3a1b5ae5dc61ad6497"
  ///   }
  static const String likePost = "/posts/like";

  ///
  ///POST
  ///body{
  ///     "user_id": "655ea0900eeb394fdcfbcc3b",
  ///     "rating": 3,
  ///     "review_comment": "This person has the skill but could improve their teaching approach. Overall, it was a decent experience.",
  ///     "reviewer_user_id": "65629d4189388b03dbc4ef5c"
  /// }
  static const String createReview = "/review";

  ///
  ///POST
  ///body{
  ///     "user_id": "655ea0900eeb394fdcfbcc3b",
  /// }
  static const String getAllReviewsByUserId = "/reviews";

  ///
  ///GET
  ///
  static const String getUserWantSkills = "/userwantskills/";

  ///
  ///GET
  ///
  static const String getUserOwnSkills = "/userownskills/";

  ///POST
  ///body{
  ///     "lat": "43.450053",
  ///     "long": "80.495",
  ///     "radiusInMeters": "1000"
  /// }
  static const String getNearbyPosts = "/nearbyPosts";

  ///POST
  ///body{
  ///     "userId": "656bd8db290d3d5f9597a57b",
  ///     "lat": "43",
  ///     "long": "-78",
  ///     "radiusInMeters": "50000"
  /// }
  static const String getPeopleNearby = "/users/nearbyBasedOnUserSkills";


}

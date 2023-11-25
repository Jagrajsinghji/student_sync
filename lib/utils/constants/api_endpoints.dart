class APIEndpoints {
  static const String baseUrl = "https://successful-helmet-calf.cyclic.app";

  ///POST
  ///body: {
  ///   "email": "yin@email.com",
  ///   "password": "password123"
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
  ///   "profile_img_name": "profile_img_5.jpg"
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
}

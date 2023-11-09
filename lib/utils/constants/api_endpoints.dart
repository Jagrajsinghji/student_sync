class APIEndpoints {
  static const String baseUrl = "https://successful-helmet-calf.cyclic.app/";

  ///POST
  ///body: {
  ///   "email": "yin@email.com",
  ///   "password": "password123"
  /// }
  ///
  static const String registerUser = "/users/pre";

  static const String institutions = "/institutions";

  ///
  ///POST
  ///body:{
  ///   "email": "yinthuaye.ca@gmail.com"
  /// }
  ///
  static const String sendVerificationEmail = "/email/send/grid";
}

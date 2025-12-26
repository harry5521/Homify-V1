class SessionManager {
  static String? loggedInUserEmail;
  static String? userRole;

  static void logout() {
    loggedInUserEmail = null;
    userRole = null;
  }
}

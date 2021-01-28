import 'dart:io';

class AppConstant {
  static final int USER_ID = 0;
  static final String EMP_ID = "0";

  static final String LoginGmailID = "loginGmailId";
  static final String PASSWORD = "password";

  static final String USERNAME = "username";
  static final String ACCESS_TOKEN = "access_token";
  static final String FIRST_NAME = "firstName";

  static final String LAO_NAME = "laoName";
  static final String LAST_NAME = "lastName";
  static final String ROLE = "role";
  static final String IMAGE = "image";
  static final String PHONENO = "empPhone1";
  static final String EMAIL = "userEmail";
  static final String DEPARTMENT = "departname";
  static final String COMPANY = "company";

  static final String REFRESHTOKEN = "refreshToken";

  static final String NO_DATA_MSG = "No Enquiry Found !";
  static final String PERMISSIONS = "permissions";

  static const double LOGIN_BUTTON_SIZE = 14.0;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

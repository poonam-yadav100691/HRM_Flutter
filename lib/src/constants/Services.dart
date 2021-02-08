class Services {
//  static final String BASE_URL = "http://52.172.206.238/LMSIO/api/"; //old UAT
  static final String BASE_URL = "http://103.151.76.35:44375/api/"; //new UAT

  static final String LOGIN = BASE_URL + 'User/Login';
  static final String GetLeaveType = BASE_URL + 'User/LeaveType';
  static final String GetResponsiblePer = BASE_URL + 'User/ResponsiblePerson';
  static final String GetUserProfiles = BASE_URL + 'profile';
  static final String LeaveBalance = BASE_URL + 'User/LeaveBalance';
  static final String GetPermissions = BASE_URL + 'User/permission';

  static final String GetNewsList = BASE_URL + 'News/list';
  static final String AddNews = BASE_URL + 'News/add';
  static final String NewsDetail = BASE_URL + 'NewsItem';
  static final String MyRequest = BASE_URL + 'User/MyRequest';
  static final String MyLevReqDetails = BASE_URL + 'User/MyRequestDetail';
}

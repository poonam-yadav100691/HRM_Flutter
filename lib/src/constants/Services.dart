class Services {
//  static final String BASE_URL = "http://52.172.206.238/LMSIO/api/"; //old UAT
  static final String BASE_URL = "http://103.151.76.35:44375/api/"; //new UAT

  static final String LOGIN = BASE_URL + 'User/Login';
  static final String GetLeaveType = BASE_URL + 'User/LeaveType';
  static final String GetResponsiblePer = BASE_URL + 'User/ResponsiblePerson';
  static final String GetUserProfiles = BASE_URL + 'profile';
  static final String LeaveBalance = BASE_URL + 'User/LeaveBalance';
  static final String GetPermissions = BASE_URL + 'User/permission';

  static final String GetNewsList = BASE_URL + 'New/Newlist';
  static final String AddNews = BASE_URL + 'New/AddNews';
  static final String NewsDetail = BASE_URL + 'NewsItem';
  static final String MyRequest = BASE_URL + 'User/MyRequest';
  static final String EmpRequest = BASE_URL + 'User/EmployeeRequest';
  static final String EmpRequestDetails =
      BASE_URL + 'User/EmployeeRequestDetail';
  static final String DelegateList = BASE_URL + 'User/DelegatesList';

  static final String DelegatePerson = BASE_URL + 'User/DelegatePerson';
  static final String MyLevReqDetails = BASE_URL + 'User/MyRequestDetail';
  static final String CancelMyrequest = BASE_URL + 'User/cancelMyrequest';

  static final String TaskList = BASE_URL + 'Task/Tasklist';
  static final String AddTaskList = BASE_URL + 'Task/AddTask';
  static final String DeleteTask = BASE_URL + 'Task/DeleteTask';

  static final String MarkCompTaskList = BASE_URL + 'Task/UpdateTaskStatus';
  static final String MyAttendance = BASE_URL + 'MyAttendance/CheckIn-Out';
  static final String InsuranceHeader = BASE_URL + 'User/InsuranceHeader';
  static final String InsuranceDetail = BASE_URL + 'User/InsuranceDetail';
  static final String LoanHeader = BASE_URL + 'User/LoanHeader';

  static final String LoanDetail = BASE_URL + 'User/LoanDetail';

  //InsuranceHeader
}

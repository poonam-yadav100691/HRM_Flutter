class loginResponse {
  String token;
  int empId;
  String roleName;
  String englishname;
  String username;
  String access_token;
  String firstName;
  String laoName;
  String lastName;
  String role;
  String empPhoto;
  String empPhone1;
  String userEmail;
  String departname;

  loginResponse({
    this.token,
    this.empId,
    this.roleName,
    this.englishname,
    this.username,
    this.access_token,
    this.firstName,
    this.laoName,
    this.lastName,
    this.role,
    this.empPhoto,
    this.empPhone1,
    this.userEmail,
    this.departname,
  });

  loginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    empId = json['empId'];
    roleName = json['roleName'];
    englishname = json['englishname'];
    username = json['username'];
    access_token = json['access_token'];
    firstName = json['firstName'];
    laoName = json['laoName'];
    lastName = json['lastName'];
    empPhoto = json['empPhoto'];
    empPhone1 = json['empPhone1'];
    userEmail = json['userEmail'];
    departname = json['departname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['empId'] = this.empId;
    data['roleName'] = this.roleName;
    data['userName'] = this.englishname;
    data['username'] = this.username;
    data['access_token'] = this.access_token;
    data['firstName'] = this.firstName;
    data['laoName'] = this.laoName;
    data['lastName'] = this.lastName;
    data['empPhoto'] = this.empPhoto;
    data['empPhone1'] = this.empPhone1;
    data['userEmail'] = this.userEmail;
    data['departname'] = this.departname;
    return data;
  }
}

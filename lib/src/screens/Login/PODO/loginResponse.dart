class loginResponse {
  String tokenKey;
  int userId;
  String emp_no;
  String roleName;
  String eng_fullname;
  String lao_fullname;
  String emp_photo;
  String emp_mobile;
  String userEmail;
  String emp_dep;
  String emp_company;

  loginResponse(
      {this.tokenKey,
      this.userId,
      this.emp_no,
      this.roleName,
      this.eng_fullname,
      this.lao_fullname,
      this.emp_photo,
      this.emp_mobile,
      this.userEmail,
      this.emp_dep,
      this.emp_company});

  loginResponse.fromJson(Map<String, dynamic> json) {
    tokenKey = json['TokenKey'];
    userId = json['UserId'];
    emp_no = json['emp_no'];
    roleName = json['roleName'];
    eng_fullname = json['eng_fullname'];
    lao_fullname = json['lao_fullname'];
    emp_photo = json['emp_photo'];
    emp_mobile = json['emp_mobile'];
    userEmail = json['userEmail'];
    emp_dep = json['emp_dep'];
    emp_company = json['emp_company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TokenKey'] = this.tokenKey;
    data['UserId'] = this.userId;
    data['emp_no'] = this.emp_no;
    data['roleName'] = this.roleName;
    data['eng_fullname'] = this.emp_mobile;
    data['lao_fullname'] = this.lao_fullname;
    data['emp_photo'] = this.emp_photo;
    data['emp_mobile'] = this.emp_mobile;
    data['userEmail'] = this.userEmail;
    data['emp_dep'] = this.emp_dep;
    data['emp_company'] = this.emp_company;
    return data;
  }
}

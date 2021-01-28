class GetResponsiblePerson {
  Null modelErrors;
  List<ResResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  Null commonErrors;

  GetResponsiblePerson(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  GetResponsiblePerson.fromJson(Map<String, dynamic> json) {
    modelErrors = json['ModelErrors'];
    if (json['ResultObject'] != null) {
      resultObject = new List<ResResultObject>();
      json['ResultObject'].forEach((v) {
        resultObject.add(new ResResultObject.fromJson(v));
      });
    }
    statusCode = json['StatusCode'];
    isSuccess = json['IsSuccess'];
    commonErrors = json['CommonErrors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ModelErrors'] = this.modelErrors;
    if (this.resultObject != null) {
      data['ResultObject'] = this.resultObject.map((v) => v.toJson()).toList();
    }
    data['StatusCode'] = this.statusCode;
    data['IsSuccess'] = this.isSuccess;
    data['CommonErrors'] = this.commonErrors;
    return data;
  }
}

class ResResultObject {
  String empid;
  String firstname;
  String lastname;

  ResResultObject({this.empid, this.firstname, this.lastname});

  ResResultObject.fromJson(Map<String, dynamic> json) {
    empid = json['empid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empid'] = this.empid;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    return data;
  }
}

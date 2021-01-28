class GetLeaveType {
  Null modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  Null commonErrors;

  GetLeaveType(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  GetLeaveType.fromJson(Map<String, dynamic> json) {
    modelErrors = json['ModelErrors'];
    if (json['ResultObject'] != null) {
      resultObject = new List<ResultObject>();
      json['ResultObject'].forEach((v) {
        resultObject.add(new ResultObject.fromJson(v));
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

class ResultObject {
  String typeID;
  String typeName;
  String typeShotname;

  ResultObject({this.typeID, this.typeName, this.typeShotname});

  ResultObject.fromJson(Map<String, dynamic> json) {
    typeID = json['TypeID'];
    typeName = json['TypeName'];
    typeShotname = json['TypeShotname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TypeID'] = this.typeID;
    data['TypeName'] = this.typeName;
    data['TypeShotname'] = this.typeShotname;
    return data;
  }
}

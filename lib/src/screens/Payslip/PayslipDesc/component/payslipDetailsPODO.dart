class PayslipDetails {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  PayslipDetails(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  PayslipDetails.fromJson(Map<String, dynamic> json) {
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
  List<EarningObject> earningObject;
  double totalEarning;
  List<DeductionObject> deductionObject;
  double totalDeduction;
  double netSalary;

  ResultObject(
      {this.earningObject,
      this.totalEarning,
      this.deductionObject,
      this.totalDeduction,
      this.netSalary});

  ResultObject.fromJson(Map<String, dynamic> json) {
    if (json['earningObject'] != null) {
      earningObject = new List<EarningObject>();
      json['earningObject'].forEach((v) {
        earningObject.add(new EarningObject.fromJson(v));
      });
    }
    totalEarning = json['totalEarning'];
    if (json['deductionObject'] != null) {
      deductionObject = new List<DeductionObject>();
      json['deductionObject'].forEach((v) {
        deductionObject.add(new DeductionObject.fromJson(v));
      });
    }
    totalDeduction = json['totalDeduction'];
    netSalary = json['netSalary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.earningObject != null) {
      data['earningObject'] =
          this.earningObject.map((v) => v.toJson()).toList();
    }
    data['totalEarning'] = this.totalEarning;
    if (this.deductionObject != null) {
      data['deductionObject'] =
          this.deductionObject.map((v) => v.toJson()).toList();
    }
    data['totalDeduction'] = this.totalDeduction;
    data['netSalary'] = this.netSalary;
    return data;
  }
}

class EarningObject {
  String earningDescrip;
  double earningValues;

  EarningObject({this.earningDescrip, this.earningValues});

  EarningObject.fromJson(Map<String, dynamic> json) {
    earningDescrip = json['earningDescrip'];
    earningValues = json['earningValues'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['earningDescrip'] = this.earningDescrip;
    data['earningValues'] = this.earningValues;
    return data;
  }
}

class DeductionObject {
  String deductionDescrip;
  double deductionValues;

  DeductionObject({this.deductionDescrip, this.deductionValues});

  DeductionObject.fromJson(Map<String, dynamic> json) {
    deductionDescrip = json['deductionDescrip'];
    deductionValues = json['deductionValues'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deductionDescrip'] = this.deductionDescrip;
    data['deductionValues'] = this.deductionValues;
    return data;
  }
}

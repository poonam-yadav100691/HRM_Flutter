class LoanDetails {
  String modelErrors;
  List<ResultDetailsObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  LoanDetails(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  LoanDetails.fromJson(Map<String, dynamic> json) {
    modelErrors = json['ModelErrors'];
    if (json['ResultObject'] != null) {
      resultObject = new List<ResultDetailsObject>();
      json['ResultObject'].forEach((v) {
        resultObject.add(new ResultDetailsObject.fromJson(v));
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

class ResultDetailsObject {
  String paymentDate;
  double loanInterest;
  double loanTotalPay;
  double loanBalance;

  ResultDetailsObject(
      {this.paymentDate,
      this.loanInterest,
      this.loanTotalPay,
      this.loanBalance});

  ResultDetailsObject.fromJson(Map<String, dynamic> json) {
    paymentDate = json['paymentDate'];
    loanInterest = json['loanInterest'];
    loanTotalPay = json['loanTotalPay'];
    loanBalance = json['loanBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentDate'] = this.paymentDate;
    data['loanInterest'] = this.loanInterest;
    data['loanTotalPay'] = this.loanTotalPay;
    data['loanBalance'] = this.loanBalance;
    return data;
  }
}

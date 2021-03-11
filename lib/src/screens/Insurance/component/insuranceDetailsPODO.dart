class InsuranceDetails {
  String modelErrors;
  List<ResultDetailsObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  InsuranceDetails(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  InsuranceDetails.fromJson(Map<String, dynamic> json) {
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
  String dateUsing;
  String hotspital;
  String contact;
  double amountPay;
  String sentDate;
  String receivedDate;
  String descript;

  ResultDetailsObject(
      {this.dateUsing,
      this.hotspital,
      this.contact,
      this.amountPay,
      this.sentDate,
      this.receivedDate,
      this.descript});

  ResultDetailsObject.fromJson(Map<String, dynamic> json) {
    dateUsing = json['dateUsing'];
    hotspital = json['hotspital'];
    contact = json['contact'];
    amountPay = json['amountPay'];
    sentDate = json['sentDate'];
    receivedDate = json['receivedDate'];
    descript = json['descript'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateUsing'] = this.dateUsing;
    data['hotspital'] = this.hotspital;
    data['contact'] = this.contact;
    data['amountPay'] = this.amountPay;
    data['sentDate'] = this.sentDate;
    data['receivedDate'] = this.receivedDate;
    data['descript'] = this.descript;
    return data;
  }
}

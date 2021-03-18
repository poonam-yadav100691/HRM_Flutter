class News {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  News(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  News.fromJson(Map<String, dynamic> json) {
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
  String newsID;
  String newsTitle;
  String newContent;
  String filePath;
  String newAttachedfile;
  String expDate;
  int createBy;

  ResultObject(
      {this.newsID,
      this.newsTitle,
      this.newContent,
      this.filePath,
      this.newAttachedfile,
      this.expDate,
      this.createBy});

  ResultObject.fromJson(Map<String, dynamic> json) {
    newsID = json['newsID'];
    newsTitle = json['newsTitle'];
    newContent = json['newContent'];
    filePath = json['file_path'];
    newAttachedfile = json['newAttachedfile'];
    expDate = json['expDate'];
    createBy = json['createBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsID'] = this.newsID;
    data['newsTitle'] = this.newsTitle;
    data['newContent'] = this.newContent;
    data['file_path'] = this.filePath;
    data['newAttachedfile'] = this.newAttachedfile;
    data['expDate'] = this.expDate;
    data['createBy'] = this.createBy;
    return data;
  }
}

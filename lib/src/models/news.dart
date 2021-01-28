class NewsList {
  final int newsId;
  final String newsTitle;
  final String newsContrent;
  final String publishDate;

  const NewsList(
      {this.newsId, this.newsTitle, this.newsContrent, this.publishDate});

  NewsList.fromJson(Map<String, dynamic> json)
      : newsId = json['newsId'],
        newsTitle = json['newsTitle'],
        newsContrent = json['newsContrent'],
        publishDate = json['publishDate'];

  Map<String, dynamic> toJson() => {
        'newsId': newsId,
        'newsTitle': newsTitle,
        'newsContrent': newsContrent,
        'publishDate': publishDate,
      };
}

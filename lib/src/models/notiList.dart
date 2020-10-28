class NotiList {
  final String title;
  final String profileImg;
  final String desc;
  final String date;

  const NotiList({this.title, this.profileImg, this.desc, this.date});

  NotiList.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        profileImg = json['profileImg'],
        desc = json['desc'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'profileImg': profileImg,
        'desc': desc,
        'date': date,
      };
}

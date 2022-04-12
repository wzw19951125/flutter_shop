class SwiperModel {
  late List<SwiperItemModel> result;

  SwiperModel(this.result);

  SwiperModel.fromJson(Map<String, dynamic> json) {
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((e) {
        result.add(SwiperItemModel.fromJson(e));
      });
    }
  }
}

class SwiperItemModel {
  late String sid;
  late String title;
  late String pic;
  late String status;

  SwiperItemModel(this.pic, this.title, this.status, this.sid);

  SwiperItemModel.fromJson(Map<String, dynamic> json) {
    sid = json["_id"];
    title = json["title"];
    pic = json["pic"];
    status = json["status"];
  }
}

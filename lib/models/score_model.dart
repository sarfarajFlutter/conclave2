// ignore_for_file: public_member_api_docs, sort_constructors_first
class ScoreModel {
  String? empid;
  String? score;
  String? name;
  // DateTime? time;

  ScoreModel({
    this.empid,
    this.score,
    this.name,
    // this.time,
  });

  ScoreModel.fromJson(Map<String, dynamic> json) {
    empid = json['empid'] ?? "";
    score = json['score'] ?? "0";
    name = json['name'] ?? "";
    // time = json['time'] ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empid'] = this.empid;
    data['score'] = this.score;
    data['name'] = this.score;
    // data['time'] = this.time;
    return data;
  }
}

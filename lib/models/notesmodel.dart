class Data {
  int id;
  int userId;
  String date;
  String note;
  String periodStartedDate;
  String periodEndedDate;
  int flow;
  String tookMedicine;
  String intercourse;
  String masturbated;
  List<Mood> mood;
  String weight;
  String height;
  String createdAt;
  int filed_count;
  String updatedAt;

  Data(
      {this.id,
      this.userId,
      this.date,
      this.note,
      this.periodStartedDate,
      this.periodEndedDate,
      this.flow,
      this.tookMedicine,
      this.intercourse,
      this.masturbated,
      this.mood,
      this.weight,
      this.filed_count,
      this.height,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    userId = map['user_id'];
    date = map['date'];
    note = map['note'];
    periodStartedDate = map['period_started_date'];
    periodEndedDate = map['period_ended_date'];
    flow = map['flow'];
    filed_count = map['filed_count'];
    tookMedicine = map['took_medicine'];
    intercourse = map['intercourse'];
    masturbated = map['masturbated'];
    if (map['mood'] != null) {
      mood = new List<Mood>();
      map['mood'].forEach((v) {
        mood.add(new Mood.fromJson(v));
      });
    }
    weight = map['weight'];
    height = map['height'];
    createdAt = map['created_at'];
    updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map;
    map['id'] = this.id;
    map['user_id'] = this.userId;
    map['date'] = this.date;
    map['note'] = this.note;
    map['period_started_date'] = this.periodStartedDate;
    map['period_ended_date'] = this.periodEndedDate;
    map['flow'] = this.flow;
    map['filed_count'] = this.filed_count;
    map['took_medicine'] = this.tookMedicine;
    map['intercourse'] = this.intercourse;
    map['masturbated'] = this.masturbated;
    if (this.mood != null) {
      map['mood'] = this.mood.map((v) => v.toJson()).toList();
    }
    map['weight'] = this.weight;
    map['height'] = this.height;
    map['created_at'] = this.createdAt;
    map['updated_at'] = this.updatedAt;
    return map;
  }
}

class Mood {
  String id;

  Mood({this.id});

  Mood.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

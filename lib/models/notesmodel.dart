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
  String mood;
  String weight;
  String height;
  String createdAt;
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
    tookMedicine = map['took_medicine'];
    intercourse = map['intercourse'];
    masturbated = map['masturbated'];
    mood = map['mood'];
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
    map['took_medicine'] = this.tookMedicine;
    map['intercourse'] = this.intercourse;
    map['masturbated'] = this.masturbated;
    map['mood'] = this.mood;
    map['weight'] = this.weight;
    map['height'] = this.height;
    map['created_at'] = this.createdAt;
    map['updated_at'] = this.updatedAt;
    return map;
  }
}

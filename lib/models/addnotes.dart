import 'dart:convert';

List<AddUserNotes> addUserNotesFromJson(String str) => List<AddUserNotes>.from(
    json.decode(str).map((x) => AddUserNotes.fromJson(x)));

String addUserNotesToJson(List<AddUserNotes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddUserNotes {
  AddUserNotes({
    this.date,
    this.note,
    this.periodStartedDate,
    this.periodEndedDate,
    this.flow,
    this.tookMedicine,
    this.intercourse,
    this.masturbated,
    this.weight,
    this.height,
    this.mood,
  });

  DateTime date;
  String note;
  DateTime periodStartedDate;
  DateTime periodEndedDate;
  String flow;
  String tookMedicine;
  String intercourse;
  String masturbated;
  String weight;
  String height;
  List<Mood> mood;

  factory AddUserNotes.fromJson(Map<String, dynamic> json) => AddUserNotes(
        date: DateTime.parse(json["date"]),
        note: json["note"],
        periodStartedDate: DateTime.parse(json["period_started_date"]),
        periodEndedDate: DateTime.parse(json["period_ended_date"]),
        flow: json["flow"],
        tookMedicine: json["took_medicine"],
        intercourse: json["intercourse"],
        masturbated: json["masturbated"],
        weight: json["weight"],
        height: json["height"],
        mood: List<Mood>.from(json["mood"].map((x) => Mood.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "note": note,
        "period_started_date": periodStartedDate.toString(),
        "period_ended_date": periodEndedDate.toString(),
        "flow": flow,
        "took_medicine": tookMedicine,
        "intercourse": intercourse,
        "masturbated": masturbated,
        "weight": weight,
        "height": height,
        "mood": List<dynamic>.from(mood.map((x) => x.toJson())),
      };
}

class Mood {
  Mood({
    this.id,
  });

  String id;

  factory Mood.fromJson(Map<String, dynamic> json) => Mood(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

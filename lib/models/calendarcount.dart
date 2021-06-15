import 'dart:convert';

Notescount notescountFromJson(String str) => Notescount.fromJson(json.decode(str));

String notescountToJson(Notescount data) => json.encode(data.toJson());

class Notescount {
    Notescount({
        this.data,
    });

    Map<String, int> data;

    factory Notescount.fromJson(Map<String, dynamic> json) => Notescount(
        data: json["data"] == null ? null : Map.from(json["data"]).map((k, v) => MapEntry<String, int>(k, v)),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)),
    };
}

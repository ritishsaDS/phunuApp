import 'dart:convert';
import 'package:http/http.dart';
import 'Api.dart';
import 'package:vietnamese/models/addnotes.dart';

class AddNotesRepo {
  Future<bool> addusernotes(
      String token, List<AddUserNotes>addNotes ) async {
    print("sdakcdml"+addUserNotesToJson(addNotes));
    try {
      final Response response = await post(addnotes,
          headers: {
            'content-type': 'application/json',
            "Authorization": "Bearer ${token}"
          },
          body: addUserNotesToJson(addNotes));
      print(response.statusCode);
      print('${addNotes[0].height}');
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Error member is not added");
      }
    } catch (e) {
      print(e);
    }
  }
}

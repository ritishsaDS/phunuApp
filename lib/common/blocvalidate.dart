import 'dart:async';

import 'package:rxdart/rxdart.dart';

class ValidationBloc {
  final _weight = BehaviorSubject<String>.seeded('@');
  final _password = BehaviorSubject<String>.seeded('');

  Stream<String> get weight => _weight.stream.transform(validateweight);

  Sink<String> get sinkEmail => _weight.sink;

  Stream<String> get password => _password.stream.transform(validatePassword);

  Sink<String> get sinkPassword => _password.sink;

  Stream<bool> get submitValid =>
      Rx.combineLatest2(weight, password, (e, p) => true);

  static bool isEmail(String email) {
    String value =
       '0-9';

    RegExp regExp = RegExp(value);

    return regExp.hasMatch(email);
  }

  final validateweight =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {

    if (value.length != 0) {
      int.parse(value)<=30
          ?sink.addError('Range 30-100')
          :sink.add(value);
    }else if(value.contains(new RegExp(r'[A-Z]'))){
      sink.addError('No llapha');
    }
    else if (int.parse(value)>=100) {
      sink.addError('Range 30-100');
    }else{
      sink.add(value);
    }

  });

  final validatePassword =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length != 0) {
      value.length >= 8
          ? sink.add(value)
          : sink.addError('Password should be 8 characters long');
    }
  });

  dispose() {
    _weight.close();
    _password.close();
  }
}

final validation = ValidationBloc();
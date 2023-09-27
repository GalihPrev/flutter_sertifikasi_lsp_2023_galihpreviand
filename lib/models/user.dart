import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  int? _id;
  String? _username;
  String? _password; 

  int? get id => _id; 
  String? get username => _username;
  set username(String? value) {
    _username = value;
    notifyListeners();
  }

  String? get password => _password;
  set password(String? value) {
    _password = value;
    notifyListeners();
  }

  User(this._username, this._password, {required String username}); 

  User.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _username = map['username'];
    _password = map['password'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }
}

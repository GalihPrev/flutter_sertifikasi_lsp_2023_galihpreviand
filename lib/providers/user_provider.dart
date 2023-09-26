import 'package:flutter/foundation.dart';
import '../DBHelper/DBHelper.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final DBHelper dbHelper = DBHelper();

  User? get user => _user;

  Future<void> fetchUserByUsername(String username) async {
    final user = await dbHelper.getUserByUsername(username);
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  // Metode untuk menyimpan data pengguna setelah berhasil login
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}

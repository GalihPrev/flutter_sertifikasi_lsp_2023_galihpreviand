import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../Auth/login.dart';
import '../DBHelper/DBHelper.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'home.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  String developerName = "Galih Previand Wicaksono";
  String developerNim = "2141764040";

  final DBHelper dbHelper = DBHelper();

  bool _isCurrentPasswordVisible = false; 
  bool _isNewPasswordVisible = false; 

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 5,
                  ),
                ),
                child: ClipOval(
                  child: Image(
                    image: AssetImage("assets/images/profile.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    developerName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    developerNim,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Ubah Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: currentPasswordController,
                obscureText:
                    !_isCurrentPasswordVisible, 
                decoration: InputDecoration(
                  labelText: "Password Saat Ini",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: !_isNewPasswordVisible, 
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _changePassword(user!);
                },
                child: Text("Simpan Password Baru"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessAlert(BuildContext context) {
    try {
      QuickAlert.show(
        context: context,
        title: "Ganti Password Berhasil",
        type: QuickAlertType.success,
      ).then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    } catch (e) {
      print("Error while showing success alert: $e");
      
    }
  }

  void _changePassword(User user) {
    String currentPasswordInput = currentPasswordController.text;
    String newPasswordInput = newPasswordController.text;

    if (currentPasswordInput == user.password) {
      if (currentPasswordInput != newPasswordInput) {
        dbHelper.changePassword(user.username!, newPasswordInput);
        _showSuccessAlert(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Password baru tidak boleh 4sama dengan password lama."),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password saat ini salah. Ubah password gagal."),
      ));
    }
  }
}

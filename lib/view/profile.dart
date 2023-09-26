import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DBHelper/DBHelper.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  String developerName = "Galih Previand Wicaksono";
  String developerNim = "NIM Anda";

  final DBHelper dbHelper = DBHelper();

  bool _isCurrentPasswordVisible = false; // Tambahkan variabel ini
  bool _isNewPasswordVisible = false; // Tambahkan variabel ini

  @override
  Widget build(BuildContext context) {
    // Access the UserProvider to get user data
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
                      fontSize: 16,
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
                    !_isCurrentPasswordVisible, // Toggle visibilitas teks
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
                obscureText: !_isNewPasswordVisible, // Toggle visibilitas teks
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

  void _changePassword(User user) {
    String currentPasswordInput = currentPasswordController.text;
    String newPasswordInput = newPasswordController.text;

    if (currentPasswordInput == user.password) {
      if (currentPasswordInput != newPasswordInput) {
        // Password saat ini benar, simpan password baru
        dbHelper.changePassword(user.username!, newPasswordInput);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password berhasil diubah."),
        ));
      } else {
        // Password baru sama dengan password lama
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Password baru tidak boleh 4sama dengan password lama."),
        ));
      }
    } else {
      // Password saat ini salah
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password saat ini salah. Ubah password gagal."),
      ));
    }
  }

  
}

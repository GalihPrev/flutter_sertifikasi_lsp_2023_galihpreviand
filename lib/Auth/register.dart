import 'package:flutter/material.dart';
import '../DBHelper/dbhelper.dart'; // Import your DBHelper class
import 'package:quickalert/quickalert.dart';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final DBHelper _dbHelper = DBHelper(); // Create an instance of DBHelper

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigasi ke halaman registrasi ketika tombol ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage()), // Gantilah RegisterPage dengan nama halaman registrasi Anda
                );
              },
              child: const Text(
                'Sudah punya akun? Login',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Ambil nilai dari controller
                final username = _usernameController.text;
                final password = _passwordController.text;

                // Periksa apakah username dan password tidak kosong
                if (username.isNotEmpty && password.isNotEmpty) {
                  try {
                    // Panggil metode register dari DBHelper
                    await _dbHelper.register(username, password);
                    // Registrasi berhasil, Anda dapat menampilkan pesan sukses
                    _showSuccessAlert(username);
                  } catch (e) {
                    _showErrorAlert(context);
                    _usernameController.clear();
                    _passwordController.clear();
                  }
                } else {
                  // Tangani kasus jika username atau password kosong
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Username and password cannot be empty.'),
                    ),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessAlert(String username) {
    QuickAlert.show(
      context: context,
      title: "Registration Successful",
      text: "Welcome, $username",
      type: QuickAlertType.success,
    ).then((_) {
      // You can navigate to the login page or any other page here
      // For example, you can use Navigator to go back to the login page:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  void _showErrorAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      title: "Registration Gagal",
      text: "Username already exists",
      type: QuickAlertType.error,
    );
  }
}

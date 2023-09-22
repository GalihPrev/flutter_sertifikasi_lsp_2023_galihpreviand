// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  bool _isPasswordMatch = true;
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
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
           const SizedBox(height: 20.0),
            TextField(
              controller: _repeatPasswordController,
              obscureText: !_isPasswordVisible2,
              decoration: InputDecoration(
                labelText: 'Repeat Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible2
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible2 = !_isPasswordVisible2;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            !_isPasswordMatch
                ? const Text(
                    'Password harus sama dengan Repeat Password',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
            ElevatedButton(
              onPressed: () {
                // Validasi apakah password sama dengan repeat password
                if (_passwordController.text !=
                    _repeatPasswordController.text) {
                  setState(() {
                    _isPasswordMatch = false;
                  });
                } else {
                  // Password sesuai, lanjutkan dengan proses registrasi
                  setState(() {
                    _isPasswordMatch = true;
                  });
                  // Implementasi logika registrasi Anda di sini
                }
              },
              child:const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

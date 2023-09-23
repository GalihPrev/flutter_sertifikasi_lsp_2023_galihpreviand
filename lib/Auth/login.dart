import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/view/home.dart';
import 'package:quickalert/quickalert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Create GlobalKey instances for resetting text fields
  final GlobalKey<FormFieldState<String>> _usernameKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> _passwordKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selamat Datang'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo.jpeg'),
              const SizedBox(height: 20.0),
              const Text(
                "asdasasd",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                key: _usernameKey, // Assign GlobalKey to the username field
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                key: _passwordKey, // Assign GlobalKey to the password field
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
              ElevatedButton(
                onPressed: () {
                  if (_usernameController.text == "user" &&
                      _passwordController.text == "user") {
                    // Show a success alert with the username
                    _showSuccessAlert(context, _usernameController.text);
                  } else {
                    _showErrorAlert(context);

                    // Reset text fields
                    _usernameKey.currentState?.reset();
                    _passwordKey.currentState?.reset();
                  }
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 40.0),
                  ),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessAlert(BuildContext context, String username) {
    QuickAlert.show(
      context: context,
      title: "Login berhasil",
      text: "Selamat datang, $username",
      type: QuickAlertType.success,
    ).then((_) {
      // Navigate to the home page when OK is pressed
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }
}

void _showErrorAlert(BuildContext context) {
  QuickAlert.show(
    context: context,
    title: "Login Gagal",
    text: "Username atau password salah.",
    type: QuickAlertType.error,
  );
}

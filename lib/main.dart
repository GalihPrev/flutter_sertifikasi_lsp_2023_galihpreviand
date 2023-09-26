import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/view/detailCashFlow.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/view/home.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/view/profile.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/view/tambahTransaksi.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'Auth/login.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(), // Replace with your actual provider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tambahkan Item',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: LoginPage(),
    );
  }
}

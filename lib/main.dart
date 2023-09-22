import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/view/home.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/view/tambahPemasukan.dart';

import 'Auth/login.dart';
import 'Auth/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tambahkan Item',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Pemasukan(),
    );
  }
}

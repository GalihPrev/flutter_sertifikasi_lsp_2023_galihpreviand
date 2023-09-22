// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Pemasukan extends StatefulWidget {
  const Pemasukan({Key? key}) : super(key: key);

  @override
  State<Pemasukan> createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pemasukan"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tambah Pemasukan",
                style: TextStyle(fontSize: 16, color: Colors.green[900]),
              ),
              SizedBox(height: 10),
              Text(
                "Tanggal",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

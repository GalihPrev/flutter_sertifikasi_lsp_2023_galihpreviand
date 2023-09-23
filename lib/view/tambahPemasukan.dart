import 'package:flutter/material.dart';

class Pemasukan extends StatefulWidget {
  const Pemasukan({Key? key}) : super(key: key);

  @override
  State<Pemasukan> createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tambah Pemasukan",
                style: TextStyle(fontSize: 16, color: Colors.green[900]),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tanggal",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0, // Lebar garis kotak untuk tanggal
                    ),
                    borderRadius: BorderRadius.circular(5.0), // Bentuk kotak
                  ),
                  width: double.infinity, // Lebar Container
                  height: 50.0, // Tinggi Container
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Icon(
                              Icons.calendar_month,
                              size: 30.0,
                              color: Colors.green[900],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: const [
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nominal',
                      prefixText: 'Rp :',
                      prefixStyle:
                          TextStyle(color: Colors.black), // Warna teks "Rp "
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Keterangan',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green[900]),
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 40.0)),
                    side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ))),
                child: const Text('Reset'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[900]),
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 40.0)),
                    side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ))),
                child: const Text('Simpan'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.yellow[900]),
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 40.0)),
                  side: MaterialStateProperty.all(const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  )),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    SizedBox(
                        width: 8), // Add some spacing between the icon and text
                    Text(
                      'Kembali',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

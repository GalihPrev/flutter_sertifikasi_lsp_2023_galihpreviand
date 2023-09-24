import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/view/home.dart';
import '../models/transaksi.dart';
import '../DBHelper/DBHelper.dart';
import 'detailCashFlow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/quickalert.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String jenis = "Pemasukan";

  List<Transaksi> transaksiList = [];

  Future<List<Transaksi>> fetchTransaksiList() async {
    return await dbHelper.getTransaksiList();
  }

  @override
  void initState() {
    super.initState();
    fetchTransaksiList().then((list) {
      setState(() {
        transaksiList = list;
      });
    });
  }

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

  Future<void> _saveTransaksi() async {
    final double nominal = double.tryParse(nominalController.text) ?? 0.0;
    final String keterangan = keteranganController.text;

    if (nominal <= 0) {
      _showErrorAlert(context);
      return;
    }

    final Transaksi transaksi = Transaksi(
      tanggal: selectedDate.toLocal().toString().split(' ')[0],
      keterangan: keterangan,
      jenis: jenis,
      jumlah: nominal,
    );

    final Map<String, dynamic> transaksiMap = transaksi.toMap();

    try {
      await dbHelper.addTransaksi(transaksiMap);

      setState(() {
        transaksiList.add(transaksi);
      });

      _showSuccessAlert(context, jenis);

      nominalController.clear();
      keteranganController.clear();
    } catch (error) {
      print("Gagal menyimpan transaksi: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan transaksi: $error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Transaksi"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const HomePage()), // Gantilah RegisterPage dengan nama halaman registrasi Anda
          ),
        ),
      ),
      body: Container(
        // Letakkan SingleChildScrollview di sini
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tambah Transaksi",
                  style: TextStyle(fontSize: 16, color: Colors.green[900]),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        height: 50.0,
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width:
                            10), // Spasi antara kotak tanggal dan ikon kalender
                    InkWell(
                      // Menggunakan InkWell untuk ikon kalender
                      onTap: () => _selectDate(context),
                      child: const Icon(
                        FontAwesomeIcons.calendarAlt,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: nominalController,
                      decoration: const InputDecoration(
                        labelText: 'Nominal',
                        prefixText: 'Rp ',
                        prefixStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: keteranganController,
                      decoration: const InputDecoration(
                        labelText: 'Keterangan',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DropdownButton<String>(
                    value: jenis,
                    items: <String>['Pemasukan', 'Pengeluaran']
                        .map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        jenis = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      height: 48.0, // Adjust the height for spacing
                      child: ElevatedButton(
                        onPressed: () async {
                          await _saveTransaksi();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green[700]),
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 40.0)),
                          side: MaterialStateProperty.all(const BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          )),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0), // Add spacing
                    SizedBox(
                      height: 48.0, // Adjust the height for spacing
                      child: ElevatedButton(
                        onPressed: () {
                          nominalController.clear();
                          keteranganController.clear();
                          setState(() {
                            selectedDate = DateTime.now();
                            jenis = "Pemasukan";
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red[700]),
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 40.0)),
                          side: MaterialStateProperty.all(const BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          )),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(height: 20.0), // Add spacing
                    SizedBox(
                      height: 48.0, // Adjust the height for spacing
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailCashFlow(
                                transaksiList: transaksiList,
                                transaksi: transaksiList.last,
                              ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green[900]),
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 40.0)),
                          side: MaterialStateProperty.all(const BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          )),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Lihat Detail Transaksi Terakhir',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessAlert(BuildContext context, String jenisTransaksi) {
    String transaksiText =
        jenisTransaksi == 'Pemasukan' ? 'Pemasukan' : 'Pengeluaran';
    QuickAlert.show(
      context: context,
      title: "Tambah Transaksi berhasil",
      text: "Anda telah menambahkan transaksi $transaksiText.",
      type: QuickAlertType.success,
    ).then((_) {
      // Navigate to the home page when OK is pressed
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailCashFlow(
            transaksiList: transaksiList,
            transaksi: transaksiList.last,
          ),
        ),
      );
    });
  }

  void _showErrorAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      title: "Gagal Tambah Transaksi",
      text: "Nominal Wajib diisikan!",
      type: QuickAlertType.error,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/DBHelper/DBHelper.dart';
import 'package:flutter_sertifikasi_lsp_2023_galihpreviand/models/transaksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'tambahTransaksi.dart';

class DetailCashFlow extends StatefulWidget {
  final DBHelper dbHelper = DBHelper();

  final Transaksi transaksi;
  final List<Transaksi> transaksiList;

  DetailCashFlow({
    Key? key,
    required this.transaksiList,
    required this.transaksi,
  }) : super(key: key) {
    // Inisialisasi allTransaksi dengan daftar transaksi yang ada atau daftar kosong
    allTransaksi = transaksiList != null && transaksiList.isNotEmpty
        ? [...transaksiList]
        : <Transaksi>[];

    // Cek apakah transaksi yang baru sudah ada dalam daftar
    final isDuplicate =
        transaksiList?.any((t) => t.id == transaksi.id) ?? false;

    // Jika tidak ada, tambahkan transaksi yang baru
    if (!isDuplicate) {
      allTransaksi.add(transaksi);
    }
  }

  // Tambahkan variabel allTransaksi
  late List<Transaksi> allTransaksi;

  @override
  _DetailCashFlowState createState() => _DetailCashFlowState();
}

class _DetailCashFlowState extends State<DetailCashFlow> {
  Future<void> _deleteTransaksi(Transaksi transaksi) async {
    if (widget.allTransaksi != null && widget.allTransaksi.isNotEmpty) {
      // Cek apakah transaksi yang akan dihapus ada dalam daftar
      final isTransactionFound =
          widget.allTransaksi.any((t) => t.id == transaksi.id);

      if (isTransactionFound) {
        // Hapus transaksi dari database
        await widget.dbHelper.deleteTransaksi(transaksi.id!);

        // Hapus transaksi dari daftar
        setState(() {
          widget.allTransaksi.remove(transaksi);
        });

        // Jika daftar transaksi menjadi kosong, tampilkan pesan "Tidak ada transaksi."
        if (widget.allTransaksi.isEmpty) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Cash Flow"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add your existing Card here for the overall layout

              // Add a title for the list of transactions
              const Text(
                'Daftar Transaksi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Create a ListView.builder to display allTransaksi
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.allTransaksi.length + 1,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return widget.allTransaksi.isEmpty
                        ? const Center(
                            child: Text("Tidak ada transaksi."),
                          )
                        : const SizedBox.shrink();
                  }

                  final transaksi =
                      widget.allTransaksi[widget.allTransaksi.length - index];

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Untuk menyusun ikon dan menu pop-up di kanan atas
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    transaksi.jenis == "Pemasukan"
                                        ? FontAwesomeIcons.plusCircle
                                        : FontAwesomeIcons.minusCircle,
                                    size: 24.0,
                                    color: transaksi.jenis == "Pemasukan"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    transaksi.jenis == "Pemasukan"
                                        ? "Pemasukan"
                                        : "Pengeluaran",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _deleteTransaksi(transaksi);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete'),
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            transaksi.keterangan ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            transaksi.tanggal ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Jumlah: Rp ${transaksi.jumlah.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TransaksiPage(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[900]),
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 40.0)),
                  side: MaterialStateProperty.all(const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  )),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  'Tambah Data',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

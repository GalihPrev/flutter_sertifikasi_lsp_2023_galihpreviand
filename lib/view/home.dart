import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../DBHelper/DBHelper.dart';
import '../models/transaksi.dart';
import '../providers/user_provider.dart';
import 'profile.dart'; // Import halaman profil
import 'tambahTransaksi.dart';

class HomePage extends StatefulWidget {
  final List<Transaksi> transaksiList;

  HomePage({Key? key, required this.transaksiList}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double iconSize = 64.0;
  double totalPengeluaran = 0.0;
  double totalPemasukkan = 0.0;

  @override
  void initState() {
    super.initState();
    // Hitung total pengeluaran dan pemasukkan saat halaman diinisialisasi
    totalPengeluaran = calculateTotalPengeluaran();
    totalPemasukkan = calculateTotalPemasukkan();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transaksiList != oldWidget.transaksiList) {
      // Total pengeluaran dan pemasukkan diperbarui jika transaksiList berubah
      totalPengeluaran = calculateTotalPengeluaran();
      totalPemasukkan = calculateTotalPemasukkan();
    }
  }

  double calculateTotalPengeluaran() {
    double total = 0.0;
    for (var transaksi in widget.transaksiList) {
      if (transaksi.jenis == "Pengeluaran") {
        total += transaksi.jumlah;
      }
    }
    return total;
  }

  double calculateTotalPemasukkan() {
    double total = 0.0;
    for (var transaksi in widget.transaksiList) {
      if (transaksi.jenis == "Pemasukan") {
        total += transaksi.jumlah;
      }
    }
    return total;
  }

  String formatCurrency(double amount) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 2);
    return currencyFormat.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Home'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Ringkasan Bulan Ini',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // cek user yang login by username
              
             Text(userProvider.user!.username!),
              const SizedBox(height: 8.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.angleDoubleDown,
                                  size: 24.0,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Pengeluaran',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Total : ${formatCurrency(totalPengeluaran)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.angleDoubleUp,
                                  size: 24.0,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Pemasukkan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Total : ${formatCurrency(totalPemasukkan)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 30,
                  right: 30,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 200.0,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: const Color(0xff37434d),
                          width: 1,
                        ),
                      ),
                      minX: 0,
                      maxX: 7,
                      minY: 0,
                      maxY: 6,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 3),
                            const FlSpot(1, 1),
                            const FlSpot(2, 4),
                            const FlSpot(3, 2),
                            const FlSpot(4, 5),
                            const FlSpot(5, 1),
                            const FlSpot(6, 4),
                          ],
                          isCurved: true,
                          colors: [Colors.blue],
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            child: SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TransaksiPage(),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      size: iconSize,
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                      'Tambah Transaksi',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Card(
                            child: SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: InkWell(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: iconSize,
                                      height: iconSize,
                                      child: Icon(
                                        Icons.search,
                                        size: iconSize,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                      'Search',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              child: SizedBox(
                                width: 150.0,
                                height: 150.0,
                                child: InkWell(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,
                                        child: Icon(
                                          Icons.favorite,
                                          size: iconSize,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      const Text(
                                        'Favorite',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              child: SizedBox(
                                width: 150.0,
                                height: 150.0,
                                child: InkWell(
                                  onTap: () {
                                    // Ganti halaman ke halaman profil (ProfilePage)
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,
                                        child: Icon(
                                          Icons.settings,
                                          size: iconSize,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      const Text(
                                        'Settings',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

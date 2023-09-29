import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../DBHelper/DBHelper.dart';
import '../models/transaksi.dart';
import '../providers/user_provider.dart';
import 'detailCashFlow.dart';
import 'profile.dart'; 
import 'tambahTransaksi.dart';

class HomePage extends StatefulWidget {
  final List<Transaksi> transaksiList;

  HomePage({Key? key, required this.transaksiList}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  double iconSize = 64.0;
  double totalPengeluaran = 0.0;
  double totalPemasukkan = 0.0;
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
        totalPengeluaran = calculateTotalPengeluaran();
        totalPemasukkan = calculateTotalPemasukkan();
      });
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transaksiList != oldWidget.transaksiList) {
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

  Future<void> _navigateToDetailCashFlow() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailCashFlow(
          transaksiList: transaksiList,
          transaksi: transaksiList.last,
        ),
      ),
    );

    if (result != null) {
      if (result == "update") {
        setState(() {
          transaksiList = fetchTransaksiList() as List<Transaksi>;
          totalPengeluaran = calculateTotalPengeluaran();
          totalPemasukkan = calculateTotalPemasukkan();
        });
      } else if (result is Transaksi) {
        setState(() {
          transaksiList.add(result);
          totalPengeluaran = calculateTotalPengeluaran();
          totalPemasukkan = calculateTotalPemasukkan();
        });
      }
    }
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

              // Text(userProvider.user!.username!),
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
                        gridData: FlGridData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          show: false,
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color(0xff37434d),
                            width: 1,
                          ),
                        ),
                        minX: 0,
                        maxX: 6, 
                        minY: 0,
                        maxY: 6,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 3),
                              FlSpot(1, 1),
                              FlSpot(2, 4),
                              FlSpot(3, 2),
                              FlSpot(4, 5),
                              FlSpot(5, 1),
                              FlSpot(6, 4),
                            ],
                            isCurved: true,
                            colors: [
                              Color.fromARGB(255, 14, 118, 238), 
                            ],
                            belowBarData: BarAreaData(
                              show: false,
                            ),
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                Color color;
                                double radius;

                                if (spot.x == 4) {
                                  color = Color.fromARGB(255, 0, 243, 113);
                                  radius = 6;
                                } else {
                                  color = const Color(0xff4af699);
                                  radius = 4;
                                }

                                return FlDotCirclePainter(
                                  radius: radius,
                                  color: color,
                                  strokeWidth: 2,
                                  strokeColor: const Color(0xff37434d),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
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
                                    SizedBox(
                                      width: iconSize,
                                      height: iconSize,
                                      child: Image.asset(
                                        'assets/images/transaksi.png',
                                        width: iconSize,
                                        height: iconSize,
                                      ),
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
                              child: TextButton(
                                onPressed: () {
                                  if (transaksiList.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailCashFlow(
                                          transaksiList: transaksiList,
                                          transaksi: transaksiList.last,
                                        ),
                                      ),
                                    );
                                  } else {
                                    _showEmptyTransaksiAlert(context);
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: iconSize,
                                      height: iconSize,
                                      child: Image.asset(
                                        'assets/images/audit.png',
                                        width: iconSize,
                                        height: iconSize,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                      'Detail Cash Flow',
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
                                      SizedBox(
                                        width: iconSize,
                                        height: iconSize,
                                        child: Image.asset(
                                          'assets/images/management.png',
                                          width: iconSize,
                                          height: iconSize,
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

  void _showEmptyTransaksiAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      title: "Tidak Ada Transaksi",
      text: "Daftar transaksi masih kosong.",
      type: QuickAlertType.info,
    );
  }
}

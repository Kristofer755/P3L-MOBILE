import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/komisi.dart';

class HistoryKomisiPage extends StatefulWidget {
  final String idPegawai;

  const HistoryKomisiPage({Key? key, required this.idPegawai})
      : super(key: key);

  @override
  State<HistoryKomisiPage> createState() => _HistoryKomisiPageState();
}

class _HistoryKomisiPageState extends State<HistoryKomisiPage> {
  List<Komisi> komisiList = [];
  List<Komisi> filteredKomisi = [];
  String? selectedMonth;
  String? selectedYear;

  final List<String> months = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];

  final List<String> years = ['2023', '2024', '2025'];

  @override
  void initState() {
    super.initState();
    fetchKomisiList();
  }

  Future<void> fetchKomisiList() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.100.10:8000/api/komisi/list/${widget.idPegawai}'),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final List data = result['data'];
        setState(() {
          komisiList = data.map((item) => Komisi.fromJson(item)).toList();
          filteredKomisi = komisiList;
        });
      }
    } catch (e) {
      print("Error fetching komisi list: $e");
    }
  }

  void applyFilter() {
    setState(() {
      filteredKomisi = komisiList.where((komisi) {
        final tanggal = komisi.tanggalKomisi;
        final month = tanggal.substring(5, 7); // '2025-03-20' → '03'
        final year = tanggal.substring(0, 4); // '2025-03-20' → '2025'

        final matchMonth = selectedMonth == null || selectedMonth == month;
        final matchYear = selectedYear == null || selectedYear == year;
        return matchMonth && matchYear;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History Komisi")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedMonth,
                    hint: const Text("Pilih Bulan"),
                    isExpanded: true,
                    items: months.map((m) {
                      return DropdownMenuItem(
                        value: m,
                        child: Text("Bulan $m"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedMonth = value);
                      applyFilter();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedYear,
                    hint: const Text("Pilih Tahun"),
                    isExpanded: true,
                    items: years.map((y) {
                      return DropdownMenuItem(
                        value: y,
                        child: Text("Tahun $y"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedYear = value);
                      applyFilter();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredKomisi.length,
              itemBuilder: (context, index) {
                final komisi = filteredKomisi[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("ID Transaksi: ${komisi.idTransaksiPembelian}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Komisi Hunter: Rp ${komisi.komisiHunter}"),
                        Text("Komisi ReuseMart: Rp ${komisi.komisiReuseMart}"),
                        Text("Bonus Penitip: Rp ${komisi.bonusPenitip}"),
                        Text("Status: ${komisi.statusKomisi}"),
                        Text("Tanggal: ${komisi.tanggalKomisi}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

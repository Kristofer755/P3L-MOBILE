import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reuse_mart/model/Pegawai.dart';
import 'package:reuse_mart/model/Pengiriman.dart';

class KurirDashboard extends StatefulWidget {
  final Pegawai pegawai;

  const KurirDashboard({Key? key, required this.pegawai}) : super(key: key);

  @override
  _KurirDashboardState createState() => _KurirDashboardState();
}

class _KurirDashboardState extends State<KurirDashboard> {
  late Future<List<Pengiriman>> futurePengiriman;
  String _filterStatus = 'diproses'; // default filter

  @override
  void initState() {
    super.initState();
    futurePengiriman = fetchPengiriman();
  }

  Future<List<Pengiriman>> fetchPengiriman() async {
    final uri = Uri.parse(
      'http://192.168.100.10:8000/api/pengiriman'
      '?tipe_pengiriman=kurir'
      '&id_pegawai=${widget.pegawai.idPegawai}',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => Pengiriman.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load data pengiriman');
    }
  }

  Future<void> _markAsDone(String idPengiriman) async {
    final uri =
        Uri.parse('http://192.168.100.10:8000/api/pengiriman/$idPengiriman');

    try {
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'status_pengiriman': 'selesai'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          futurePengiriman = fetchPengiriman();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas ditandai selesai')),
        );
      } else {
        throw Exception('Gagal update: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Kurir")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Kurir
            Text("Nama: ${widget.pegawai.nama}",
                style: const TextStyle(fontSize: 18)),
            Text("Email: ${widget.pegawai.email}"),
            Text("Telepon: ${widget.pegawai.noTelp}"),
            Text("Jabatan: ${widget.pegawai.jabatan}"),
            Text("Status: ${widget.pegawai.statusPegawai}"),
            Text("Tanggal Lahir: ${widget.pegawai.tglLahir}"),

            const SizedBox(height: 24),
            Row(
              children: [
                const Text("Filter Status:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _filterStatus,
                  items: const [
                    DropdownMenuItem(
                        value: 'diproses', child: Text('Diproses')),
                    DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _filterStatus = value;
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text(
              "History Pengiriman",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: FutureBuilder<List<Pengiriman>>(
                future: futurePengiriman,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final allList = snapshot.data ?? [];
                  // filter berdasarkan status yang dipilih
                  final list = allList
                      .where((p) => p.statusPengiriman == _filterStatus)
                      .toList();

                  if (list.isEmpty) {
                    return Text(
                      'Tidak ada riwayat pengiriman dengan status "${_filterStatus}".',
                    );
                  }

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final p = list[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text('Pengiriman #${p.idPengiriman}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tanggal: ${p.tglPengiriman}'),
                              Text('Status: ${p.statusPengiriman}'),
                            ],
                          ),
                          trailing: p.statusPengiriman != 'selesai'
                              ? ElevatedButton(
                                  child: const Text('Selesai'),
                                  onPressed: () => _markAsDone(p.idPengiriman),
                                )
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

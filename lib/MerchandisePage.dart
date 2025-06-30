import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/merchandise.dart';

class MerchandisePage extends StatefulWidget {
  final String idPembeli;
  final int poin;

  const MerchandisePage({Key? key, required this.idPembeli, required this.poin})
      : super(key: key);

  @override
  State<MerchandisePage> createState() => _MerchandisePageState();
}

class _MerchandisePageState extends State<MerchandisePage> {
  List<Merchandise> daftarMerch = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMerchandise();
  }

  Future<void> fetchMerchandise() async {
    final response =
        await http.get(Uri.parse('http://192.168.100.10:8000/api/merchandise'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        daftarMerch = data.map((item) => Merchandise.fromJson(item)).toList();
        isLoading = false;
      });
    } else {
      print("Gagal mengambil data merchandise");
    }
  }

  Future<void> klaimMerchandise(String idMerch) async {
    final response = await http.post(
      Uri.parse('http://192.168.100.10:8000/api/klaim-merchandise'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_pembeli': widget.idPembeli,
        'id_merch': idMerch,
      }),
    );

    final result = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );

    if (response.statusCode == 200) {
      fetchMerchandise();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Katalog Merchandise")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: daftarMerch.length,
              itemBuilder: (context, index) {
                final merch = daftarMerch[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      merch.foto.isNotEmpty
                          ? Image.network(
                              'http://192.168.100.10:8000/images/${merch.foto}',
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(
                              height: 180,
                              child: Center(child: Text("Tanpa Gambar"))),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(merch.nama,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("Harga Poin: ${merch.hargaPoin}"),
                            Text("Stok: ${merch.stok}"),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: (widget.poin >= merch.hargaPoin &&
                                      merch.stok > 0)
                                  ? () => klaimMerchandise(merch.id)
                                  : null,
                              child: const Text("Klaim"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/barang.dart'; // Import Model
import '../login.dart'; // Import halaman login
import 'detail_barang_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Barang> barangList = [];
  bool isLoading = true;

  Future<void> fetchBarangs() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.100.10:8000/api/home"),
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final List barangs = result['data'];

        setState(() {
          barangList = barangs.map((b) => Barang.fromJson(b)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load barangs');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBarangs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ReuseMart - Home"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : barangList.isEmpty
              ? const Center(child: Text("Tidak ada barang."))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: barangList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final barang = barangList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailBarangPage(barang: barang),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child: Image.network(
                                  "http://192.168.100.10:8000/images/${barang.gambar}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    barang.nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    barang.deskripsi,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rp ${barang.harga}",
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

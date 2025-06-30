import 'package:flutter/material.dart';
import '../model/barang.dart';

class DetailBarangPage extends StatefulWidget {
  final Barang barang;

  const DetailBarangPage({super.key, required this.barang});

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Gabungkan gambar utama + gambar tambahan
    final List<String> allImages = [
      "http://192.168.100.10:8000/images/${widget.barang.gambar}",
      if (widget.barang.gambar2 != null)
        "http://192.168.100.10:8000/images/${widget.barang.gambar2!}",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.barang.nama),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: allImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          allImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Dot Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  allImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentIndex == index ? 12.0 : 8.0,
                    height: _currentIndex == index ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      color:
                          _currentIndex == index ? Colors.purple : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.barang.nama,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Rp ${widget.barang.harga}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Status Garansi: ${widget.barang.statusGaransi}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Deskripsi Produk:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.barang.deskripsi,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

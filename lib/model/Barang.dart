class Barang {
  final String id;
  final String nama;
  final String deskripsi;
  final int harga;
  final String statusGaransi;
  final String gambar; // gambar_barang
  final String? gambar2; // gambar_barang_2

  Barang({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.statusGaransi,
    required this.gambar,
    this.gambar2,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id_barang'],
      nama: json['nama_barang'],
      deskripsi: json['deskripsi_barang'],
      harga: int.parse(json['harga_barang']),
      statusGaransi: json['status_garansi'],
      gambar: json['gambar_barang'],
      gambar2: json['gambar_barang_2'], // kolom baru
    );
  }
}

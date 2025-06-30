class Merchandise {
  final String id;
  final String nama;
  final int hargaPoin;
  final int stok;
  final String status;
  final String foto;

  Merchandise({
    required this.id,
    required this.nama,
    required this.hargaPoin,
    required this.stok,
    required this.status,
    required this.foto,
  });

  factory Merchandise.fromJson(Map<String, dynamic> json) {
    return Merchandise(
      id: json['id_merch'],
      nama: json['nama_merch'],
      hargaPoin: json['harga_poin'],
      stok: json['stok_merch'],
      status: json['status_merch'],
      foto: json['foto_merch'] ?? '',
    );
  }
}

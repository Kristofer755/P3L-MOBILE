class Komisi {
  final int idKomisi;
  final String idTransaksiPembelian;
  final int komisiHunter;
  final int komisiReuseMart;
  final int bonusPenitip;
  final String statusKomisi;
  final String tanggalKomisi; // ← tambahkan ini

  Komisi({
    required this.idKomisi,
    required this.idTransaksiPembelian,
    required this.komisiHunter,
    required this.komisiReuseMart,
    required this.bonusPenitip,
    required this.statusKomisi,
    required this.tanggalKomisi, // ← tambahkan ini ke constructor
  });

  factory Komisi.fromJson(Map<String, dynamic> json) {
    return Komisi(
      idKomisi: json['id_komisi'],
      idTransaksiPembelian: json['id_transaksi_pembelian'],
      komisiHunter: int.tryParse(json['komisi_hunter'].toString()) ?? 0,
      komisiReuseMart: int.tryParse(json['komisi_ReuseMart'].toString()) ?? 0,
      bonusPenitip: int.tryParse(json['bonus_penitip'].toString()) ?? 0,
      statusKomisi: json['status_komisi'],
      tanggalKomisi: json['tgl_komisi'], // ← tambahkan ini
    );
  }
}

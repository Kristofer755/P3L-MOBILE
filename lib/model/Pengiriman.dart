class Pengiriman {
  final String idPengiriman;
  final String tglPengiriman;
  final String statusPengiriman;
  final String tipePengiriman;

  Pengiriman({
    required this.idPengiriman,
    required this.tglPengiriman,
    required this.statusPengiriman,
    required this.tipePengiriman,
  });

  factory Pengiriman.fromJson(Map<String, dynamic> json) {
    return Pengiriman(
      idPengiriman: json['id_pengiriman'],
      tglPengiriman: json['tgl_pengiriman'],
      statusPengiriman: json['status_pengiriman'],
      tipePengiriman: json['tipe_pengiriman'],
    );
  }
}

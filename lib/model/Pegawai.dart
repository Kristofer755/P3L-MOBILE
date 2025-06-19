class Pegawai {
  final String idPegawai;
  final String nama;
  final String email;
  final String noTelp;
  final String jabatan;
  final String statusPegawai;
  final String tglLahir;

  Pegawai({
    required this.idPegawai,
    required this.nama,
    required this.email,
    required this.noTelp,
    required this.jabatan,
    required this.statusPegawai,
    required this.tglLahir,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      idPegawai: json['id_pegawai'],
      nama: json['nama_pegawai'],
      email: json['email'],
      noTelp: json['no_telp'],
      jabatan: json['jabatan'],
      statusPegawai: json['status_pegawai'],
      tglLahir: json['tgl_lahir'],
    );
  }
}

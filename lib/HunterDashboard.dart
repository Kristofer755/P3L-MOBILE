import 'package:flutter/material.dart';
import 'package:reuse_mart/model/Pegawai.dart';

class HunterDashboard extends StatelessWidget {
  final Pegawai pegawai;

  const HunterDashboard({Key? key, required this.pegawai}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Hunter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: ${pegawai.nama}", style: TextStyle(fontSize: 18)),
            Text("Email: ${pegawai.email}"),
            Text("Telepon: ${pegawai.noTelp}"),
            Text("Jabatan: ${pegawai.jabatan}"),
            Text("Status: ${pegawai.statusPegawai}"),
            Text("Tanggal Lahir: ${pegawai.tglLahir}"),
          ],
        ),
      ),
    );
  }
}

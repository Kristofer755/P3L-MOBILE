import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reuse_mart/model/Pegawai.dart';

class PegawaiService {
  final String apiUrl = 'http://192.168.100.10:8000/api/pegawai/kurir-hunter';

  Future<List<Pegawai>> fetchPegawai() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Pegawai.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pegawai');
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'PembeliDashboard.dart';
import 'HunterDashboard.dart';
import 'KurirDashboard.dart';
import 'PenitipDashboard.dart';
import 'model/Pegawai.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);

    final response = await http.post(
      Uri.parse("http://192.168.245.164:8000/api/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": emailController.text,
        "password": passwordController.text,
      }),
    );

    setState(() => loading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Login successful. Raw API Response: ${response.body}");
      final role = data['role']?.toString();
      final jabatan = data['jabatan']?.toString();

      print("Extracted Role: $role, Extracted Jabatan: $jabatan");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Login berhasil sebagai ${role ?? 'tidak diketahui'}. Jabatan: ${jabatan ?? 'tidak diketahui'}')),
      );

      if (role == 'pembeli') {
        final pembeliData = data['user'];
        final idPembeli = pembeliData['id_pembeli'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PembeliDashboard(idPembeli: idPembeli),
          ),
        );
      } else if (role == 'penitip') {
        final penitipData = data['user'];
        final idPenitip = penitipData['id_penitip'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PenitipDashboard(idPenitip: idPenitip),
          ),
        );
      } else if (role == 'pegawai') {
        print("Role is 'pegawai'. Checking jabatan: '$jabatan'");

        if (jabatan == 'kurir') {
          print(
              "Jabatan is 'kurir'. Attempting to parse Pegawai data and navigate.");
          try {
            final pegawaiData = data['user'];
            print("Decoded pegawai data: $pegawaiData");

            if (pegawaiData != null && pegawaiData is Map<String, dynamic>) {
              final pegawai = Pegawai.fromJson(pegawaiData);
              print("Pegawai object created successfully: ${pegawai.nama}");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => KurirDashboard(pegawai: pegawai),
                ),
              );
              print("Successfully navigated to KurirDashboard.");
            } else {
              print("Pegawai data is null or invalid: $pegawaiData");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Data Pegawai tidak ditemukan atau format tidak valid.')),
              );
            }
          } catch (e, stackTrace) {
            print("Error creating Pegawai object or navigating: $e");
            print("Stack trace: $stackTrace");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Error processing kurir data: $e. Check console for details.')),
            );
          }
        } else if (jabatan == 'hunter') {
          print(
              "Jabatan is 'hunter'. Attempting to parse Pegawai data and navigate.");
          try {
            final pegawaiData = data['user'];
            print("Decoded pegawai data: $pegawaiData");

            if (pegawaiData != null && pegawaiData is Map<String, dynamic>) {
              final pegawai = Pegawai.fromJson(pegawaiData);
              print("Pegawai object created successfully: ${pegawai.nama}");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HunterDashboard(pegawai: pegawai),
                ),
              );
              print("Successfully navigated to HunterDashboard.");
            } else {
              print("Pegawai data is null or invalid: $pegawaiData");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Data Pegawai tidak ditemukan atau format tidak valid.')),
              );
            }
          } catch (e, stackTrace) {
            print("Error creating Pegawai object or navigating: $e");
            print("Stack trace: $stackTrace");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Error processing hunter data: $e. Check console for details.')),
            );
          }
        } else {
          print("Role is 'pegawai', tapi jabatan '$jabatan' tidak dikenal.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Login sebagai pegawai, tapi jabatan "$jabatan" tidak dikenal untuk navigasi khusus.')),
          );
        }
      } else {
        print("Role '$role' is not recognized for navigation.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role "$role" tidak dikenali.')),
        );
      }
    } else {
      String errorMessage = 'Login gagal';
      try {
        final error = jsonDecode(response.body);
        errorMessage = error['message'] ??
            'Login gagal (status code: ${response.statusCode})';
        print(
            "Login failed. Status Code: ${response.statusCode}. Response: ${response.body}");
      } catch (e) {
        errorMessage =
            'Login gagal. Respons tidak valid (status code: ${response.statusCode})';
        print(
            "Login failed. Status Code: ${response.statusCode}. Could not parse error response: ${response.body}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: loading ? null : login,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

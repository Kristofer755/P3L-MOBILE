import 'package:flutter/material.dart';

class PenitipDashboard extends StatelessWidget {
  const PenitipDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Penitip")),
      body: const Center(child: Text("Ini halaman dashboard Penitip")),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PenitipDashboard extends StatefulWidget {
  final String idPenitip;
  const PenitipDashboard({Key? key, required this.idPenitip}) : super(key: key);

  @override
  State<PenitipDashboard> createState() => _PenitipDashboardState();
}

class _PenitipDashboardState extends State<PenitipDashboard> {
  late FlutterLocalNotificationsPlugin localNotif;
  List<Map<String, dynamic>> notifList = [];
  String? notifRawResponse;
  Timer? _pollingTimer;

  final _baseUrl = 'http://192.168.245.164:8000/api';

  @override
  void initState() {
    super.initState();
    setupNotif();
    fetchNotif(); // langsung cek sekali saat init
    // polling tiap 30 detik
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => fetchNotif(),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void setupNotif() {
    localNotif = FlutterLocalNotificationsPlugin();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    localNotif.initialize(initSettings);
  }

  Future<void> showNotification(String title, String message) async {
    const androidDetails = AndroidNotificationDetails(
      'notif_channel_id',
      'Notif Penitip',
      channelDescription: 'Notifikasi untuk penitip',
      importance: Importance.max,
      priority: Priority.high,
    );
    final notifDetails = NotificationDetails(android: androidDetails);
    await localNotif.show(0, title, message, notifDetails);
  }

  Future<void> fetchNotif() async {
    final url = '$_baseUrl/notif-penitip/${widget.idPenitip}';
    try {
      final response = await http.get(Uri.parse(url));

      // simpan raw
      if (mounted) {
        setState(() => notifRawResponse = response.body);
      }

      if (response.statusCode == 200 && response.body != 'null') {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // tampilkan notif
        await showNotification(data['judul'], data['pesan']);

        // update UI
        if (mounted) {
          setState(() {
            notifList = [data];
          });
        }

        // tandai sudah dibaca
        await http
            .post(Uri.parse('$_baseUrl/notif-penitip/read/${data['id']}'));
      } else {
        // tidak ada notifikasi baru
        if (mounted) {
          setState(() {
            notifList = [];
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          notifList = [
            {'judul': 'Error', 'pesan': e.toString()}
          ];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Penitip")),
      body: notifList.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifList.length,
              itemBuilder: (context, i) {
                final notif = notifList[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(Icons.notifications, color: Colors.purple),
                    title: Text(notif['judul'] ?? '-'),
                    subtitle: Text(notif['pesan'] ?? '-'),
                  ),
                );
              },
            )
          : Center(child: Text("Belum ada notifikasi.")),
      bottomNavigationBar: notifRawResponse != null
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Raw Response: $notifRawResponse",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            )
          : null,
    );
  }
}

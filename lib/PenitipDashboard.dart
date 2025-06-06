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

  @override
  void initState() {
    super.initState();
    setupNotif();
    fetchNotif();
  }

  void setupNotif() {
    localNotif = FlutterLocalNotificationsPlugin();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    localNotif.initialize(initSettings);
  }

  void showNotification(String title, String message) async {
    const androidDetails = AndroidNotificationDetails(
      'notif_channel_id',
      'Notif Penitip',
      channelDescription: 'Notifikasi untuk penitip',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notifDetails = NotificationDetails(android: androidDetails);

    await localNotif.show(
      0,
      title,
      message,
      notifDetails,
    );
  }

  Future<void> fetchNotif() async {
    final url =
        'http://192.168.60.164:8000/api/notif-penitip/${widget.idPenitip}';
    try {
      final response = await http.get(Uri.parse(url));
      setState(() {
        notifRawResponse = response.body;
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          // Tampilkan notifikasi lokal HANYA untuk notifikasi paling baru
          if (data.isNotEmpty) {
            showNotification(data[0]['judul'], data[0]['pesan']);
          }
          setState(() {
            notifList = List<Map<String, dynamic>>.from(data);
          });
        } else if (data is Map &&
            data['judul'] != null &&
            data['pesan'] != null) {
          // Jika response masih objek tunggal, fallback ke tampilan satu notif
          showNotification(data['judul'], data['pesan']);
          setState(() {
            notifList = [Map<String, dynamic>.from(data)];
          });
        } else {
          setState(() {
            notifList = [];
          });
        }
      }
    } catch (e) {
      setState(() {
        notifList = [
          {
            'judul': "Error",
            'pesan': e.toString(),
          }
        ];
      });
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

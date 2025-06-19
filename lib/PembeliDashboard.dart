import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PembeliDashboard extends StatefulWidget {
  final String idPembeli;
  const PembeliDashboard({Key? key, required this.idPembeli}) : super(key: key);

  @override
  State<PembeliDashboard> createState() => _PembeliDashboardState();
}

class _PembeliDashboardState extends State<PembeliDashboard> {
  late FlutterLocalNotificationsPlugin localNotif;
  String? notifTitle;
  String? notifMessage;
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
      'Notif Pembeli',
      channelDescription: 'Notifikasi untuk pembeli',
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
        'http://192.168.245.164:8000/api/notif-pembeli/${widget.idPembeli}';
    try {
      final response = await http.get(Uri.parse(url));
      setState(() {
        notifRawResponse = response.body;
      });

      // Cek kalau ada notifikasi baru (controller kembalikan null jika gak ada)
      if (response.statusCode == 200 && response.body != 'null') {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Hanya jika ada field 'id' artinya ada notifikasi
        if (data['id'] != null) {
          // Update UI
          setState(() {
            notifTitle = data['judul'];
            notifMessage = data['pesan'];
          });

          // Tampilkan local notification
          showNotification(data['judul'], data['pesan']);

          // Tandai sudah dibaca
          await http.post(Uri.parse(
            'http://192.168.252.164:8000/api/notif-pembeli/read/${data['id']}',
          ));
        }
      }
    } catch (e) {
      setState(() {
        notifTitle = "Error";
        notifMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Pembeli")),
      body: Center(
        child: notifTitle != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Judul Notif: $notifTitle"),
                  SizedBox(height: 8),
                  Text("Pesan: $notifMessage"),
                  SizedBox(height: 16),
                  Text("Raw Response: $notifRawResponse",
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              )
            : Text("Belum ada notifikasi."),
      ),
    );
  }
}

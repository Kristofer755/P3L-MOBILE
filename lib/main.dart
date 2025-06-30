import 'package:flutter/material.dart';
import 'login.dart';
import 'home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ReuseMart',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: const HomePage(), // HomePage sebagai halaman awal
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const BzReportApp());
}

class BzReportApp extends StatelessWidget {
  const BzReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BZ Report',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFF00386E),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DashboardScreen(),
    );
  }
}
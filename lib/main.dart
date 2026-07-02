import 'package:flutter/material.dart';
import 'screens/liste_rapports_screen.dart';

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
      // On passe sur un thème sombre global pour sublimer l'effet "Liquid Glass"
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00386E),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const ListeRapportsScreen(), 
    );
  }
}
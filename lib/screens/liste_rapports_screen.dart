import 'package:flutter/material.dart';
import 'dart:ui';
import '../mocks/mock_rapports.dart';
import '../widgets/glass_card.dart';

class ListeRapportsScreen extends StatelessWidget {
  const ListeRapportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: _buildGlassAppBar(),
      ),
      body: _buildMainContent(),
    );
  }

  // --- COMPOSANT 1 : La barre du haut ---
  Widget _buildGlassAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0.4),
          elevation: 0,
          title: Text(
            'INSPECTIONS BZ-BOTS',
            style: TextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
        ),
      ),
    );
  }

  // --- COMPOSANT 2 : Le fond et la liste ---
  Widget _buildMainContent() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                const Color(0xFFF5F5F5),
                const Color(0xFFEAEAEA),
                const Color(0xFFE0E0E0).withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 50, 16, 16),
          itemCount: fausseListeRapports.length,
          itemBuilder: (context, index) {
            final rapport = fausseListeRapports[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildInspectionCard(rapport.nomClient, rapport.date, rapport.statut),
            );
          },
        ),
      ],
    );
  }

  // --- COMPOSANT 3 : La carte individuelle ---
  Widget _buildInspectionCard(String clientName, String date, String status) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.precision_manufacturing_outlined,
              color: Colors.black87,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('CLIENT:', style: TextStyle(color: Colors.black54, fontSize: 12)),
                Text(
                  clientName.toUpperCase(),
                  style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('DATE: $date', style: const TextStyle(color: Colors.black54, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildStatusChip(status),
        ],
      ),
    );
  }

  // --- COMPOSANT 4 : Le badge de statut ---
  Widget _buildStatusChip(String status) {
    final bool isTermine = status == 'Terminé';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isTermine ? Colors.black87 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isTermine ? Colors.black87 : Colors.grey[400]!),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isTermine ? Colors.white : Colors.black87,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
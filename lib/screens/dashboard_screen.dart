import 'package:flutter/material.dart';
import 'dart:ui';
import '../mocks/mock_rapports.dart';
import '../widgets/glass_card.dart';
import 'liste_rapports_screen.dart';
import 'saisie_defaut_screen.dart';
import 'creation_rapport_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = fausseListeRapports.length;
    final termines = fausseListeRapports.where((r) => r.statut == 'Terminé').length;
    final enAttente = total - termines;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: _buildGlassAppBar(),
      ),
      body: _buildMainContent(context, total, termines, enAttente),
    );
  }

  // --- APP BAR ---
  Widget _buildGlassAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0.4),
          elevation: 0,
          title: Text(
            'BZ-REPORT',
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

  // --- FOND + CONTENU ---
  Widget _buildMainContent(BuildContext context, int total, int termines, int enAttente) {
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
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 50, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vue d\'ensemble',
                style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatsRow(total, termines, enAttente),
              const SizedBox(height: 24),
              _buildQuickAction(context),
              const SizedBox(height: 24),
              _buildRecentHeader(context),
              const SizedBox(height: 12),
              ..._buildRecentReports(context),
            ],
          ),
        ),
      ],
    );
  }

  // --- LIGNE DE STATS ---
  Widget _buildStatsRow(int total, int termines, int enAttente) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('TOTAL', total.toString(), Icons.folder_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('TERMINÉS', termines.toString(), Icons.check_circle_outline)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('EN ATTENTE', enAttente.toString(), Icons.hourglass_empty)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black54, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11, letterSpacing: 1.0),
          ),
        ],
      ),
    );
  }

     // --- ACCÈS RAPIDE ---
  Widget _buildQuickAction(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreationRapportScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'NOUVEAU RAPPORT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  // --- HEADER "RAPPORTS RÉCENTS" ---
  Widget _buildRecentHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Rapports récents',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ListeRapportsScreen()),
            );
          },
          child: const Text('Voir tout', style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }

  // --- APERÇU DES 2 DERNIERS RAPPORTS ---
  List<Widget> _buildRecentReports(BuildContext context) {
    final recents = fausseListeRapports.take(2).toList();
    return recents.map((rapport) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SaisieDefautScreen(rapport: rapport)),
            );
          },
          child: GlassCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.description_outlined, color: Colors.black87, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rapport.nomClient,
                        style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rapport.date,
                        style: const TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
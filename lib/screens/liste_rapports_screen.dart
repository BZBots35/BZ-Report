import 'package:flutter/material.dart';
import 'dart:ui'; // Indispensable pour l'effet de flou (blur)
import '../mocks/mock_rapports.dart'; // Notre fausse base de données 

class ListeRapportsScreen extends StatelessWidget {
  const ListeRapportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Le dégradé passe sous la barre
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
          backgroundColor: Colors.white.withOpacity(0.05),
          elevation: 0,
          title: Text(
            'INSPECTIONS BZ-BOTS',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 2.0, // On garde le côté espacé et pro
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
        // Le fond dégradé liquide 100% Noir & Blanc
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF121212).withOpacity(0.95), // Noir très profond
                const Color(0xFF2C2C2C).withOpacity(0.8),  // Gris anthracite
                const Color(0xFF424242).withOpacity(0.6),  // Gris métallisé
                Colors.white.withOpacity(0.02),            // Reflet subtil
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        ),
        // La liste générée à partir des fausses données
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
          // L'icône du robot en blanc pur (Fini le bleu fluo)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.precision_manufacturing_outlined,
              color: Colors.white, 
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          // Les textes d'information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('CLIENT:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text(
                  clientName.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('DATE: $date', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Le badge de statut
          _buildStatusChip(status),
        ],
      ),
    );
  }

  // --- COMPOSANT 4 : Le badge de statut (Noir et Blanc) ---
  Widget _buildStatusChip(String status) {
    final bool isTermine = status == 'Terminé';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isTermine ? Colors.white : Colors.black, // Blanc si terminé, Noir sinon
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isTermine ? Colors.white : Colors.grey[700]!), // Bordure assortie
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isTermine ? Colors.black : Colors.white, // Texte inversé par rapport au fond
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================================================
// WIDGET RÉUTILISABLE : L'effet de verre (Glassmorphisme)
// ============================================================================
class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Ombre légère pour donner de la profondeur
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
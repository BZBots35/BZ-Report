import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/rapport.dart';
import '../models/defaut.dart';
import '../widgets/glass_card.dart';
import 'dashboard_screen.dart';

class GenerationRapportScreen extends StatefulWidget {
  final Rapport rapport;
  final List<Defaut> defauts;

  const GenerationRapportScreen({
    super.key,
    required this.rapport,
    required this.defauts,
  });

  @override
  State<GenerationRapportScreen> createState() => _GenerationRapportScreenState();
}

class _GenerationRapportScreenState extends State<GenerationRapportScreen> {
  bool _enCours = true;

  @override
  void initState() {
    super.initState();
    // Simule le temps de génération du PDF
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _enCours = false);
    });
  }

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

  Widget _buildGlassAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0.4),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'GÉNÉRATION DU RAPPORT',
            style: TextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
        ),
      ),
    );
  }

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
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
            child: _enCours ? _buildLoading() : _buildResultat(),
          ),
        ),
      ],
    );
  }

  // --- ÉTAT : GÉNÉRATION EN COURS ---
  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.black87, strokeWidth: 2.5),
          const SizedBox(height: 24),
          const Text(
            'Génération du rapport en cours...',
            style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Mise en forme des ${widget.defauts.length} défaut(s) relevé(s)',
            style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),
          ),
        ],
      ),
    );
  }

  // --- ÉTAT : RAPPORT GÉNÉRÉ ---
  Widget _buildResultat() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Rapport généré avec succès',
                  style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPdfPreview(),
          const SizedBox(height: 24),
          _buildActions(),
        ],
      ),
    );
  }

  // --- APERÇU DU PDF (mock) ---
  Widget _buildPdfPreview() {
    final bool complet = widget.rapport.type == TypeRapport.complet;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête façon rapport officiel
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'BZ-REPORT',
                style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  complet ? 'RAPPORT COMPLET' : 'RAPPORT SIMPLIFIÉ',
                  style: const TextStyle(color: Colors.black54, fontSize: 9, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Conforme NF EN 13508-2',
            style: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 8),
          ),
          const Divider(height: 28),

          _buildPreviewRow('CLIENT', widget.rapport.nomClient),
          const SizedBox(height: 10),
          _buildPreviewRow('DATE D\'INSPECTION', widget.rapport.date),

          if (complet) ...[
            const SizedBox(height: 10),
            _buildPreviewRow('RÉFÉRENCE DOSSIER', '#${widget.rapport.id}'),
          ],

          const SizedBox(height: 20),
          Text(
            'DÉFAUTS RELEVÉS (${widget.defauts.length})',
            style: const TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.0),
          ),
          const SizedBox(height: 10),

          if (widget.defauts.isEmpty)
            Text(
              'Aucun défaut relevé lors de cette inspection.',
              style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 12, fontStyle: FontStyle.italic),
            )
          else
            ...widget.defauts.map((d) => _buildDefautPreviewRow(d)),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf_outlined, color: Colors.black.withOpacity(0.4), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'rapport_${widget.rapport.id}.pdf',
                    style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String valeur) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            valeur,
            style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildDefautPreviewRow(Defaut d) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 12),
                children: [
                  TextSpan(text: d.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (d.regard != null) TextSpan(text: '  •  ${d.regard}'),
                  if (d.distance > 0) TextSpan(text: '  •  ${d.distance.toStringAsFixed(2)} m'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ACTIONS ---
  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Partage du PDF — à connecter (Appwrite Storage / share_plus)')),
              );
            },
            icon: const Icon(Icons.ios_share, color: Colors.white, size: 18),
            label: const Text(
              'PARTAGER LE RAPPORT',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black.withOpacity(0.2)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'RETOUR À L\'ACCUEIL',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/rapport.dart';
import '../mocks/mock_rapports.dart';
import '../widgets/glass_card.dart';
import 'saisie_defaut_screen.dart';

class CreationRapportScreen extends StatefulWidget {
  const CreationRapportScreen({super.key});

  @override
  State<CreationRapportScreen> createState() => _CreationRapportScreenState();
}

class _CreationRapportScreenState extends State<CreationRapportScreen> {
  final TextEditingController _nomClientController = TextEditingController();
  TypeRapport _typeSelectionne = TypeRapport.simplifie;
  String? _erreur;

  @override
  void dispose() {
    _nomClientController.dispose();
    super.dispose();
  }

  void _creerRapport() {
    final nom = _nomClientController.text.trim();

    if (nom.isEmpty) {
      setState(() => _erreur = 'Le nom du client est obligatoire.');
      return;
    }

    final maintenant = DateTime.now();
    final dateFormatee =
        '${maintenant.day.toString().padLeft(2, '0')}/${maintenant.month.toString().padLeft(2, '0')}/${maintenant.year}';

    final nouveauRapport = Rapport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nomClient: nom,
      date: dateFormatee,
      statut: 'En attente vidéo',
      type: _typeSelectionne,
    );

    // Ajout en tête de liste pour qu'il apparaisse en premier dans "récents"
    fausseListeRapports.insert(0, nouveauRapport);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SaisieDefautScreen(rapport: nouveauRapport),
      ),
    );
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
          leading: const BackButton(color: Colors.black87),
          title: Text(
            'NOUVEAU RAPPORT',
            style: TextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w600,
              fontSize: 18,
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
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 50, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informations du rapport',
                style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFormCard(),
              const SizedBox(height: 24),
              _buildCreerButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CLIENT',
            style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.0),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nomClientController,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Ex : Mairie de Rennes - Égouts',
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 13),
              filled: true,
              fillColor: Colors.white.withOpacity(0.6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
              ),
              contentPadding: const EdgeInsets.all(12),
              errorText: _erreur,
            ),
            onChanged: (_) {
              if (_erreur != null) setState(() => _erreur = null);
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'TYPE DE RAPPORT',
            style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.0),
          ),
          const SizedBox(height: 10),
          _buildTypeSelector(),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildTypeOption(
            label: 'Simplifié',
            sousTitre: 'Particuliers',
            type: TypeRapport.simplifie,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTypeOption(
            label: 'Complet',
            sousTitre: 'Collectivités, industriels...',
            type: TypeRapport.complet,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeOption({
    required String label,
    required String sousTitre,
    required TypeRapport type,
  }) {
    final bool selected = _typeSelectionne == type;
    return GestureDetector(
      onTap: () => setState(() => _typeSelectionne = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.black87 : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.black87 : Colors.black.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sousTitre,
              style: TextStyle(
                color: selected ? Colors.white70 : Colors.black45,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreerButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _creerRapport,
        icon: const Icon(Icons.check, color: Colors.white, size: 18),
        label: const Text(
          'CRÉER LE RAPPORT',
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
}
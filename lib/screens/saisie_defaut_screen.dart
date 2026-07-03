import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../models/rapport.dart';
import '../models/defaut.dart';
import '../services/defaut_parser.dart';
import '../widgets/glass_card.dart';

class SaisieDefautScreen extends StatefulWidget {
  final Rapport rapport;
  const SaisieDefautScreen({super.key, required this.rapport});

  @override
  State<SaisieDefautScreen> createState() => _SaisieDefautScreenState();
}

class _SaisieDefautScreenState extends State<SaisieDefautScreen> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;
  bool _stoppedManually = false;
  final TextEditingController _textController = TextEditingController();

  final List<Defaut> _defautsSaisis = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: (error) {
        debugPrint('❌ Erreur speech_to_text: ${error.errorMsg} (permanent: ${error.permanent})');
        setState(() => _isListening = false);
      },
      debugLogging: true, // Active les logs détaillés du plugin
    );
    debugPrint('✅ Speech disponible: $_speechAvailable');

    final locales = await _speech.locales();
    debugPrint('🌍 Locales disponibles: ${locales.map((l) => l.localeId).join(", ")}');

    setState(() {});
  }

  // Relance automatiquement l'écoute si elle s'arrête toute seule
  // (timeout interne, silence détecté) sans que l'utilisateur ait cliqué sur stop
  void _onSpeechStatus(String status) {
    debugPrint('ℹ️ Status speech: $status');
    if (status == 'done' || status == 'notListening') {
      if (_isListening && !_stoppedManually) {
        _startListening();
      } else {
        setState(() => _isListening = false);
      }
    }
  }

  void _startListening() {
    _stoppedManually = false;
    setState(() => _isListening = true);
    _speech.listen(
      onResult: _onResult,
      localeId: 'fr_FR', // Force le français
      listenFor: const Duration(minutes: 5), // Durée max de la session
      pauseFor: const Duration(seconds: 8), // Silence toléré avant coupure
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation, // Adapté aux phrases longues
        partialResults: true, // Affiche le texte au fur et à mesure
        cancelOnError: true, // Temporaire : pour voir les erreurs en debug
        autoPunctuation: true,
      ),
    );
  }

  void _onResult(SpeechRecognitionResult result) {
    debugPrint('📝 Résultat reçu: "${result.recognizedWords}" (final: ${result.finalResult})');
    setState(() {
      _textController.text = result.recognizedWords;
    });
  }

  void _toggleListening() {
    if (!_isListening) {
      if (_speechAvailable) {
        _startListening();
      } else {
        debugPrint('⚠️ Speech non disponible, impossible de démarrer l\'écoute');
      }
    } else {
      _stoppedManually = true;
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _enregistrerDefaut() {
    if (_textController.text.trim().isEmpty) return;

    final defaut = DefautParser.parse(
      _textController.text.trim(),
      DateTime.now().millisecondsSinceEpoch.toString(),
    );

    setState(() {
      _defautsSaisis.add(defaut);
      _textController.clear();
    });
  }

  void _supprimerDefaut(String id) {
    setState(() {
      _defautsSaisis.removeWhere((d) => d.id == id);
    });
  }

  @override
  void dispose() {
    _stoppedManually = true;
    _speech.stop();
    _textController.dispose();
    super.dispose();
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
            widget.rapport.nomClient.toUpperCase(),
            style: TextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 1.0,
            ),
            overflow: TextOverflow.ellipsis,
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
                'Saisie de défaut',
                style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildVoiceCard(),
              const SizedBox(height: 24),
              Text(
                'Défauts saisis (${_defautsSaisis.length})',
                style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (_defautsSaisis.isEmpty)
                Text(
                  'Aucun défaut saisi pour le moment.',
                  style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 13),
                ),
              ..._defautsSaisis.map(_buildDefautTile),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _speechAvailable ? _toggleListening : null,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.black87 : Colors.black.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.white : Colors.black87,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _isListening
                      ? 'Écoute en cours...'
                      : _speechAvailable
                          ? 'Appuyez sur le micro pour dicter'
                          : 'Reconnaissance vocale indisponible',
                  style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 3,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Ex : Regard R4, fissure longitudinale à 18,40 m.',
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 13),
              filled: true,
              fillColor: Colors.white.withOpacity(0.6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _enregistrerDefaut,
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: const Text(
                'AJOUTER LE DÉFAUT',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefautTile(Defaut defaut) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.black87, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        defaut.type,
                        style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      if (defaut.regard != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            defaut.regard!,
                            style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      if (defaut.distance > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${defaut.distance.toStringAsFixed(2)} m',
                          style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    defaut.description,
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 12),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _supprimerDefaut(defaut.id),
              child: Icon(Icons.close, color: Colors.black.withOpacity(0.3), size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
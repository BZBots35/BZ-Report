import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TestVoiceScreen extends StatefulWidget {
  const TestVoiceScreen({super.key});

  @override
  State<TestVoiceScreen> createState() => _TestVoiceScreenState();
}

class _TestVoiceScreenState extends State<TestVoiceScreen> {
  final SpeechToText _speech = SpeechToText();
  String _text = "Appuyez sur le micro pour parler";
  bool _isListening = false;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() => _text = result.recognizedWords);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Reconnaissance Vocale")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_text, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 50),
              onPressed: _listen,
            ),
          ],
        ),
      ),
    );
  }
}
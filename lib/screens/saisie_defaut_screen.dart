import 'package:speech_to_text/speech_to_text.dart';

// Dans ton widget d'écran :
SpeechToText _speech = SpeechToText();
bool _isListening = false;
String _text = "Appuyez sur le micro pour dicter...";

void _listen() async {
  if (!_isListening) {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) => setState(() => _text = val.recognizedWords));
    }
  } else {
    setState(() => _isListening = false);
    _speech.stop();
  }
}
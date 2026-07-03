/// Corrige les erreurs de reconnaissance vocale les plus fréquentes
/// sur le vocabulaire technique métier (inspection canalisations).
/// Complète le DefautParser en amont, ne remplace pas la relecture humaine.
class TextCorrectionService {
  // Corrections "mot mal reconnu" -> "mot correct"
  // À enrichir au fur et à mesure des tests terrain
  static const Map<String, String> _corrections = {
    'regarde': 'regard',
    "j'regarde": 'regard',
    'regard de': 'regard',
    'fissures': 'fissure',
    'fissuré': 'fissure',
    'longitudinal': 'longitudinale',
    'décollement': 'décalage',
    'racine': 'racines',
  };

  static String correct(String texte) {
    String result = texte;
    _corrections.forEach((mauvais, bon) {
      final regex = RegExp(RegExp.escape(mauvais), caseSensitive: false);
      result = result.replaceAll(regex, bon);
    });
    return result;
  }
}
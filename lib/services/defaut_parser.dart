import '../models/defaut.dart';

/// Extrait type de défaut, distance et regard à partir d'un texte dicté.
/// Exemple : "Regard R4, fissure longitudinale à 18,40 m"
class DefautParser {
  // Liste des types de défauts reconnus (à étoffer selon la codification NF EN 13508-2)
  static const Map<String, String> _typesConnus = {
    'fissure': 'Fissure',
    'racine': 'Racines',
    'racines': 'Racines',
    'décalage': 'Décalage',
    'decalage': 'Décalage',
    'infiltration': 'Infiltration',
    'obstacle': 'Obstacle',
    'casse': 'Casse',
    'effondrement': 'Effondrement',
    'dépôt': 'Dépôt',
    'depot': 'Dépôt',
  };

  static Defaut parse(String texte, String id) {
    final texteLower = texte.toLowerCase();

    // Extraction du regard (ex: "Regard R4" -> "R4")
    String? regard;
    final regardMatch = RegExp(r'regard\s+([a-zA-Z0-9]+)').firstMatch(texteLower);
    if (regardMatch != null) {
      regard = regardMatch.group(1)?.toUpperCase();
    }

    // Extraction de la distance (ex: "18,40 m" ou "18.40 m" ou "18 m")
    double distance = 0.0;
    final distanceMatch = RegExp(r'(\d+[,.]?\d*)\s*m(?:\s|$|\.)').firstMatch(texteLower);
    if (distanceMatch != null) {
      final raw = distanceMatch.group(1)?.replaceAll(',', '.') ?? '0';
      distance = double.tryParse(raw) ?? 0.0;
    }

    // Extraction du type de défaut (recherche du premier mot-clé connu)
    String type = 'Non classé';
    for (final entry in _typesConnus.entries) {
      if (texteLower.contains(entry.key)) {
        type = entry.value;
        break;
      }
    }

    return Defaut(
      id: id,
      type: type,
      distance: distance,
      regard: regard,
      description: texte.trim(),
    );
  }
}
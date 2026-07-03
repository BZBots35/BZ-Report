class Defaut {
  final String id;
  final String type; // ex: "Fissure", "Racines", "Décalage"
  final double distance; // ex: 18.40 m
  final String? regard; // ex: "R4"
  final String description; // Le texte brut transcrit (toujours conservé)

  Defaut({
    required this.id,
    required this.type,
    required this.distance,
    this.regard,
    required this.description,
  });
}
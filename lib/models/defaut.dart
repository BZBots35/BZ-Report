class Defaut {
  final String id;
  final String type; // ex: "Fissure", "Racines", "Décalage"
  final double distance; // ex: 18.40 m
  final String description; // Ce que la voix a transcrit

  Defaut({
    required this.id,
    required this.type,
    required this.distance,
    required this.description,
  });
}
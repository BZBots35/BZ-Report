enum TypeRapport { simplifie, complet }

class Rapport {
  final String id;
  final String nomClient;
  final String date;
  final String statut;
  final TypeRapport type;

  Rapport({
    required this.id,
    required this.nomClient,
    required this.date,
    required this.statut,
    this.type = TypeRapport.simplifie,
  });
}
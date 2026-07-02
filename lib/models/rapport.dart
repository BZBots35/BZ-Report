class Rapport {
  final String id;
  final String nomClient;
  final String date;
  final String statut;

  // Le constructeur : il oblige à fournir ces 4 informations pour créer un rapport
  Rapport({
    required this.id,
    required this.nomClient,
    required this.date,
    required this.statut,
  });
}
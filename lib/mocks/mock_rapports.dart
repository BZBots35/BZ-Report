import '../models/rapport.dart';

// Liste modifiable : les nouveaux rapports créés dans l'app s'y ajoutent
final List<Rapport> fausseListeRapports = [
  Rapport(
    id: '001',
    nomClient: 'Syndicat des Eaux - Secteur Nord',
    date: '02/07/2026',
    statut: 'Terminé',
    type: TypeRapport.complet,
  ),
  Rapport(
    id: '002',
    nomClient: 'Mairie de Rennes - Égouts',
    date: '01/07/2026',
    statut: 'En attente vidéo',
    type: TypeRapport.complet,
  ),
  Rapport(
    id: '003',
    nomClient: 'Particulier - M. Dupont',
    date: '28/06/2026',
    statut: 'Terminé',
    type: TypeRapport.simplifie,
  ),
];
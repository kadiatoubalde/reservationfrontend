enum StatutTrajet {
  DEMARRER,
  TERMINER,
  REPORTER
  
}

String getStatusLabel(StatutTrajet status) {
  switch (status) {
    case StatutTrajet.DEMARRER:
      return 'Démarré';
    case StatutTrajet.TERMINER:
      return 'Terminé';
    case StatutTrajet.REPORTER:
      return 'Reporté';
    default:
      return 'Non défini';
  }
} 
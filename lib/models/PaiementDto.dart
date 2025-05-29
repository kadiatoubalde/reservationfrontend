class PaiementDto {
  String? uuid;
  double? montant;
  DateTime? datePaiement;
  String? uuidModePaiement;
  String? uuidReservation;
  String? uuidUtilisateur;

  PaiementDto({
    this.uuid,
    this.montant,
    this.datePaiement,
    this.uuidModePaiement,
    this.uuidReservation,
    this.uuidUtilisateur,
  });

  factory PaiementDto.fromJson(Map<String, dynamic> json) {
    return PaiementDto(
      uuid: json['uuid'],
      montant: json['montant']?.toDouble(),
      datePaiement: json['datePaiement'] != null ? DateTime.parse(json['datePaiement']) : null,
      uuidModePaiement: json['uuidModePaiement'],
      uuidReservation: json['uuidReservation'],
      uuidUtilisateur: json['uuidUtilisateur'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'montant': montant,
      'datePaiement': datePaiement?.toIso8601String(),
      'uuidModePaiement': uuidModePaiement,
      'uuidReservation': uuidReservation,
      'uuidUtilisateur': uuidUtilisateur,
    };
  }
} 
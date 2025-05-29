class PlanificationVoyageDto {
  String? uuid;
  DateTime? heureDepart;
  DateTime? heureArrivee;
  int? nombrePlaces;
  int? nombrePlacesImage;
  double? montant;
  String? uuidTrajet;
  String? uuidVehicule;
  String? uuidUtilisateur;

  PlanificationVoyageDto({
    this.uuid,
    this.heureDepart,
    this.heureArrivee,
    this.nombrePlaces,
    this.nombrePlacesImage,
    this.montant,
    this.uuidTrajet,
    this.uuidVehicule,
    this.uuidUtilisateur,
  });

  factory PlanificationVoyageDto.fromJson(Map<String, dynamic> json) {
    return PlanificationVoyageDto(
      uuid: json['uuid'],
      heureDepart: json['heureDepart'] != null ? DateTime.parse(json['heureDepart']) : null,
      heureArrivee: json['heureArrivee'] != null ? DateTime.parse(json['heureArrivee']) : null,
      nombrePlaces: json['nombrePlaces'],
      nombrePlacesImage: json['nombrePlacesImage'],
      montant: json['montant']?.toDouble(),
      uuidTrajet: json['uuidTrajet'],
      uuidVehicule: json['uuidVehicule'],
      uuidUtilisateur: json['uuidUtilisateur'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'heureDepart': heureDepart?.toIso8601String(),
      'heureArrivee': heureArrivee?.toIso8601String(),
      'nombrePlaces': nombrePlaces,
      'nombrePlacesImage': nombrePlacesImage,
      'montant': montant,
      'uuidTrajet': uuidTrajet,
      'uuidVehicule': uuidVehicule,
      'uuidUtilisateur': uuidUtilisateur,
    };
  }
} 
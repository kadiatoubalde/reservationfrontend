class ModePaiementDto {
  String? uuid;
  String? libelle;
  String? description;

  ModePaiementDto({
    this.uuid,
    this.libelle,
    this.description,
  });

  factory ModePaiementDto.fromJson(Map<String, dynamic> json) {
    return ModePaiementDto(
      uuid: json['uuid'],
      libelle: json['libelle'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'libelle': libelle,
      'description': description,
    };
  }
} 
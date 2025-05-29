class VilleDto {
  String? uuid;
  String? libelle;

  VilleDto({
    this.uuid,
    this.libelle,
  });

  factory VilleDto.fromJson(Map<String, dynamic> json) {
    return VilleDto(
      uuid: json['uuid'],
      libelle: json['libelle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'libelle': libelle,
    };
  }
} 
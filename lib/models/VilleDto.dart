class VilleDto {
  String? uuid;
  String nom;

  VilleDto({
    this.uuid,
    this.nom = '',
  });

  factory VilleDto.fromJson(Map<String, dynamic> json) {
    return VilleDto(
      uuid: json['uuid'],
      nom: json['nom'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'nom': nom,
    };
  }
} 
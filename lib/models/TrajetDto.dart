class TrajetDto {
  String? uuid;
  String? pointDepart;
  String? pointArriver;
  String? uuidPointDepart;
  String? uuidPointArriver;
  double? montant;

  TrajetDto({
    this.uuid,
    this.pointDepart,
    this.pointArriver,
    this.uuidPointDepart,
    this.uuidPointArriver,
    this.montant,
  });

  factory TrajetDto.fromJson(Map<String, dynamic> json) {
    return TrajetDto(
      uuid: json['uuid'],
      pointDepart: json['pointDepart'],
      pointArriver: json['pointArriver'],
      uuidPointDepart: json['uuidPointDepart'],
      uuidPointArriver: json['uuidPointArriver'],
      montant: json['montant']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'pointDepart': pointDepart,
      'pointArriver': pointArriver,
      'uuidPointDepart': uuidPointDepart,
      'uuidPointArriver': uuidPointArriver,
      'montant': montant,
    };
  }
} 
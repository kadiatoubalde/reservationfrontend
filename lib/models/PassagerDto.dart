class PassagerDto {
  final String uuid;
  final String lastname;
  final String firstname;
  final String telephone;
  final int nombreBillet;

  PassagerDto({
    required this.uuid,
    required this.lastname,
    required this.firstname,
    required this.telephone,
    required this.nombreBillet,
  });

  factory PassagerDto.fromJson(Map<String, dynamic> json) {
    return PassagerDto(
      uuid: json['uuid'],
      lastname: json['lastname'],
      firstname: json['firstname'],
      telephone: json['telephone'],
      nombreBillet: json['nombreBiillet'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'lastname': lastname,
      'firstname': firstname,
      'telephone': telephone,
      'nombreBiillet': nombreBillet,
    };
  }
} 
class PassagerDto {
  String? uuid;
  String? nom;
  String? prenom;
  String? adresse;
  String? telephone;
  String? telephonePersonneContact;
  String? adressePersonneContact;
  String? civilite;
  String? genre;

  PassagerDto({
    this.uuid,
    this.nom,
    this.prenom,
    this.adresse,
    this.telephone,
    this.telephonePersonneContact,
    this.adressePersonneContact,
    this.civilite,
    this.genre,
  });

  factory PassagerDto.fromJson(Map<String, dynamic> json) {
    return PassagerDto(
      uuid: json['uuid'],
      nom: json['nom'],
      prenom: json['prenom'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      telephonePersonneContact: json['telephonePersonneContact'],
      adressePersonneContact: json['adressePersonneContact'],
      civilite: json['civilite'],
      genre: json['genre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'telephone': telephone,
      'telephonePersonneContact': telephonePersonneContact,
      'adressePersonneContact': adressePersonneContact,
      'civilite': civilite,
      'genre': genre,
    };
  }
} 
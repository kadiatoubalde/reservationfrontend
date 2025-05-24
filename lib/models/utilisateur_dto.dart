class UtilisateurDto {
  String? uuid;
  final String firstname;  // prénom
  final String lastname;   // nom
  final String email;
  final String password;
  final String telephone;
  List<String> roles;
  String? token;

  UtilisateurDto({
    this.uuid,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.telephone,
    this.roles = const [],
    this.token,
  });

  factory UtilisateurDto.fromJson(Map<String, dynamic> json) {
    return UtilisateurDto(
      uuid: json['uuid'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      password: json['password'] ?? '',
      telephone: json['telephone'],
      roles: List<String>.from(json['roles'] ?? []),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'telephone': telephone,
      'roles': roles,
    };
  }
} 
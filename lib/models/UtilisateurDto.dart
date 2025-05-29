class UtilisateurDto {
  final String? uuid;
  final String firstname;
  final String lastname;
  final String email;
  final String telephone;
  final String? password;
  final String role;
  final String? token;

  UtilisateurDto({
    this.uuid,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.telephone,
    this.password,
    required this.role,
    this.token,
  });

  factory UtilisateurDto.fromJson(Map<String, dynamic> json) {
    return UtilisateurDto(
      uuid: json['uuid'] as String?,
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      telephone: json['telephone'],
      password: json['password'] as String?,
      role: json['role'],
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'telephone': telephone,
      'role': role,
    };
    if (uuid != null) data['uuid'] = uuid;
    if (password != null) data['password'] = password;
    if (token != null) data['token'] = token;
    return data;
  }
} 
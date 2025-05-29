class User {
  final String? uuid;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? telephone;
  final String? role;
  final String? token;

  User({
    this.uuid,
    this.firstname,
    this.lastname,
    this.email,
    this.telephone,
    this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      role: json['role'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'telephone': telephone,
      'role': role,
      'token': token,
    };
  }
} 
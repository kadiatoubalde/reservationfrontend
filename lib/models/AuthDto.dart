class AuthDto {
  final String email;
  final String password;

  AuthDto({
    required this.email,
    required this.password,
  });

  factory AuthDto.fromJson(Map<String, dynamic> json) {
    return AuthDto(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
} 
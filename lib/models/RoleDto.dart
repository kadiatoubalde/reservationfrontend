class RoleDto {
  String? uuid;
  String? code;
  String? label;

  RoleDto({
    this.uuid,
    this.code,
    this.label,
  });

  factory RoleDto.fromJson(Map<String, dynamic> json) {
    return RoleDto(
      uuid: json['uuid'],
      code: json['code'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'code': code,
      'label': label,
    };
  }
}

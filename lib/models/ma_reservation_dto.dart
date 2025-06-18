class MaReservationDto {
  final String uuid;
  final String numeroReservation;
  final String statut;
  final int nombreBagage;
  final DateTime date;

  MaReservationDto({
    required this.uuid,
    required this.numeroReservation,
    required this.statut,
    required this.nombreBagage,
    required this.date,
  });

  factory MaReservationDto.fromJson(Map<String, dynamic> json) {
    return MaReservationDto(
      uuid: json['uuid'],
      numeroReservation: json['numeroReservation'],
      statut: json['statut'],
      nombreBagage: json['nombreBagage'],
      date: DateTime.parse(json['date']),
    );
  }
} 
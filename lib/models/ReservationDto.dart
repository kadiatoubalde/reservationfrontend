import 'statut_enum.dart';

class ReservationDto {
  final String trajetUuid;
  final int nombreBagage;
  final int nombreBillets;

  ReservationDto({
    required this.trajetUuid,
    required this.nombreBagage,
    required this.nombreBillets,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) {
    return ReservationDto(
      trajetUuid: json['trajetUuid'],
      nombreBagage: json['nombreBagage'],
      nombreBillets: json['nombreBillets'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trajetUuid': trajetUuid,
      'nombreBagage': nombreBagage,
      'nombreBillets': nombreBillets,
    };
  }
} 
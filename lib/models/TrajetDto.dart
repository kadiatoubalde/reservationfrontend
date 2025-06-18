import 'statut_trajet.dart';

class TrajetDto {
  String? uuid;
  String? pointDepart;
  String? pointArriver;
  String? uuidPointDepart;
  String? uuidPointArriver;
  double? montant;
  DateTime? dateDepart;
  DateTime? timeDepart;
  String? chauffeurId;
  StatutTrajet? status;
  int? placesDisponibles;

  TrajetDto({
    this.uuid,
    this.pointDepart,
    this.pointArriver,
    this.uuidPointDepart,
    this.uuidPointArriver,
    this.montant,
    this.dateDepart,
    this.timeDepart,
    this.chauffeurId,
    this.status,
    this.placesDisponibles,
  });

  factory TrajetDto.fromJson(Map<String, dynamic> json) {
    // Helper function to parse time strings like "HH:mm:ss" into DateTime
    DateTime? _parseTime(String? timeString) {
      if (timeString == null || timeString.isEmpty) return null;
      try {
        // Combine with a dummy date to make it a valid DateTime string
        final now = DateTime.now();
        final datePart = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        return DateTime.parse("$datePart $timeString");
      } catch (e) {
        // Handle potential parsing errors, maybe log or return null
        print("Error parsing time string: $timeString - $e");
        return null;
      }
    }

    return TrajetDto(
      uuid: json['uuid'],
      pointDepart: json['pointDepart'],
      pointArriver: json['pointArriver'],
      uuidPointDepart: json['uuidPointDepart'],
      uuidPointArriver: json['uuidPointArriver'],
      montant: json['montant']?.toDouble(),
      dateDepart: json['dateDepart'] != null ? DateTime.parse(json['dateDepart']) : null,
      timeDepart: _parseTime(json['timeDepart']),
      chauffeurId: json['chauffeurId'],
      status: json['status'] != null 
          ? StatutTrajet.values.firstWhere(
              (e) => e.toString().split('.').last == json['status'],
              orElse: () => StatutTrajet.PLANIFIE)
          : null,
      placesDisponibles: json['placesDisponibles'],
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
      'dateDepart': dateDepart?.toIso8601String(),
      'timeDepart': timeDepart?.toIso8601String(),
      'chauffeurId': chauffeurId,
      'status': status?.toString().split('.').last,
      'placesDisponibles': placesDisponibles,
    };
  }
} 
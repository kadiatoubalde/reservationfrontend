import 'statut_enum.dart';

class ReservationDto {
  final String? uuid;
  final String? uuidTrajet;
  final String? uuidUtilisateur;
  final int? nombrePlaces;
  final String? commentaire;
  final double? montant;
  final String? pointDepart;
  final String? pointArriver;
  final String? statut;

  ReservationDto({
    this.uuid,
    this.uuidTrajet,
    this.uuidUtilisateur,
    this.nombrePlaces,
    this.commentaire,
    this.montant,
    this.pointDepart,
    this.pointArriver,
    this.statut,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) {
    return ReservationDto(
      uuid: json['uuid'],
      uuidTrajet: json['uuidTrajet'],
      uuidUtilisateur: json['uuidUtilisateur'],
      nombrePlaces: json['nombrePlaces'],
      commentaire: json['commentaire'],
      montant: json['montant']?.toDouble(),
      pointDepart: json['pointDepart'],
      pointArriver: json['pointArriver'],
      statut: json['statut'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'uuidTrajet': uuidTrajet,
      'uuidUtilisateur': uuidUtilisateur,
      'nombrePlaces': nombrePlaces,
      'commentaire': commentaire,
      'montant': montant,
      'pointDepart': pointDepart,
      'pointArriver': pointArriver,
      'statut': statut,
    };
  }
} 
import 'enum_type_vehicule.dart';

class VehiculeDto {
  String? uuid;
  String? marque;
  String? immatriculation;
  String? description;
  EnumTypeVehicule? enumTypeVehicule;
  int? nombrePlace;
  String? modele;

  VehiculeDto({
    this.uuid,
    this.marque,
    this.immatriculation,
    this.description,
    this.enumTypeVehicule,
    this.nombrePlace,
    this.modele,
  });

  factory VehiculeDto.fromJson(Map<String, dynamic> json) {
    return VehiculeDto(
      uuid: json['uuid'],
      marque: json['marque'],
      immatriculation: json['immatriculation'],
      description: json['description'],
      enumTypeVehicule: json['enumTypeVehicule'] != null 
          ? EnumTypeVehicule.values.firstWhere(
              (e) => e.toString() == 'EnumTypeVehicule.${json['enumTypeVehicule']}')
          : null,
      nombrePlace: json['nombrePlace'],
      modele: json['modele'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'marque': marque,
      'immatriculation': immatriculation,
      'description': description,
      'enumTypeVehicule': enumTypeVehicule?.toString().split('.').last,
      'nombrePlace': nombrePlace,
      'modele': modele,
    };
  }
} 
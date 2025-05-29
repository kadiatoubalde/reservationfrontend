import '../models/vehiculeDto.dart';
import 'api_service.dart';
import 'dart:convert';

class VehiculeService {
  static const String _endpoint = '/vehicules';

  static Future<List<VehiculeDto>> getAll(String token) async {
    final response = await ApiService.get(_endpoint, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => VehiculeDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des véhicules');
    }
  }

  static Future<VehiculeDto> getById(String id, String token) async {
    final response = await ApiService.get('$_endpoint/$id', token: token);
    if (response.statusCode == 200) {
      return VehiculeDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement du véhicule');
    }
  }

  static Future<VehiculeDto> create(VehiculeDto vehicule, String token) async {
    final response = await ApiService.post(_endpoint, vehicule.toJson(), token: token);
    if (response.statusCode == 201) {
      return VehiculeDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création du véhicule');
    }
  }

  static Future<VehiculeDto> update(String id, VehiculeDto vehicule, String token) async {
    final response = await ApiService.put('$_endpoint/$id', vehicule.toJson(), token: token);
    if (response.statusCode == 200) {
      return VehiculeDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour du véhicule');
    }
  }

  static Future<void> delete(String id, String token) async {
    final response = await ApiService.delete('$_endpoint/$id', token: token);
    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression du véhicule');
    }
  }
} 
import '../models/planification_voyage_dto.dart';
import 'api_service.dart';
import 'dart:convert';

class PlanificationVoyageService {
  static const String _endpoint = '/planifications';

  static Future<List<PlanificationVoyageDto>> getAll(String token) async {
    final response = await ApiService.get(_endpoint, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PlanificationVoyageDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des planifications');
    }
  }

  static Future<PlanificationVoyageDto> getById(String id, String token) async {
    final response = await ApiService.get('$_endpoint/$id', token: token);
    if (response.statusCode == 200) {
      return PlanificationVoyageDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement de la planification');
    }
  }

  static Future<PlanificationVoyageDto> create(PlanificationVoyageDto planification, String token) async {
    final response = await ApiService.post(_endpoint, planification.toJson(), token: token);
    if (response.statusCode == 201) {
      return PlanificationVoyageDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création de la planification');
    }
  }

  static Future<PlanificationVoyageDto> update(String id, PlanificationVoyageDto planification, String token) async {
    final response = await ApiService.put('$_endpoint/$id', planification.toJson(), token: token);
    if (response.statusCode == 200) {
      return PlanificationVoyageDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour de la planification');
    }
  }

  static Future<void> delete(String id, String token) async {
    final response = await ApiService.delete('$_endpoint/$id', token: token);
    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression de la planification');
    }
  }

  static Future<List<PlanificationVoyageDto>> getByTrajet(String trajetId, String token) async {
    final response = await ApiService.get('$_endpoint/trajet/$trajetId', token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PlanificationVoyageDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des planifications du trajet');
    }
  }
} 
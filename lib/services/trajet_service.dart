import '../models/trajetDto.dart';
import 'api_service.dart';
import 'dart:convert';

class TrajetService {
  static const String _endpoint = '/trajets';

  static Future<List<TrajetDto>> getAll(String token) async {
    final response = await ApiService.get(_endpoint, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TrajetDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des trajets');
    }
  }

  static Future<TrajetDto> getById(String id, String token) async {
    final response = await ApiService.get('$_endpoint/$id', token: token);
    if (response.statusCode == 200) {
      return TrajetDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement du trajet');
    }
  }

  static Future<String> create(TrajetDto trajet, String token) async {
    final response = await ApiService.post(_endpoint, trajet.toJson(), token: token);
    if (response.statusCode == 201) {
      return "Ajouté avec succès";
      //TrajetDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création du trajet');
    }
  }

  static Future<TrajetDto> update(String id, TrajetDto trajet, String token) async {
    final response = await ApiService.put('$_endpoint/$id', trajet.toJson(), token: token);
    if (response.statusCode == 200) {
      return TrajetDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour du trajet');
    }
  }

  static Future<void> delete(String id, String token) async {
    final response = await ApiService.delete('$_endpoint/$id', token: token);
    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression du trajet');
    }
  }
} 
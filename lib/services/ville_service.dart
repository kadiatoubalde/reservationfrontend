import '../models/ville_dto.dart';
import 'api_service.dart';
import 'dart:convert';

class VilleService {
  static const String _endpoint = '/villes';

  static Future<List<VilleDto>> getAll(String token) async {
    final response = await ApiService.get(_endpoint, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => VilleDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des villes');
    }
  }

  static Future<VilleDto> getById(String id, String token) async {
    final response = await ApiService.get('$_endpoint/$id', token: token);
    if (response.statusCode == 200) {
      return VilleDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement de la ville');
    }
  }

  static Future<VilleDto> create(VilleDto ville, String token) async {
    final response = await ApiService.post(_endpoint, ville.toJson(), token: token);
    if (response.statusCode == 200) {
      return VilleDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création de la ville');
    }
  }

  static Future<VilleDto> update(String id, VilleDto ville, String token) async {
    final response = await ApiService.put('$_endpoint/$id', ville.toJson(), token: token);
    if (response.statusCode == 200) {
      return VilleDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour de la ville');
    }
  }

  static Future<void> delete(String id, String token) async {
    final response = await ApiService.delete('$_endpoint/$id', token: token);
    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression de la ville');
    }
  }
} 
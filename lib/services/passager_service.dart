import '../models/passager_dto.dart';
import 'api_service.dart';
import 'dart:convert';

class PassagerService {
  static const String _endpoint = '/passagers';

  static Future<List<PassagerDto>> getAll(String token) async {
    final response = await ApiService.get(_endpoint, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PassagerDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des passagers');
    }
  }

  static Future<PassagerDto> getById(String id, String token) async {
    final response = await ApiService.get('$_endpoint/$id', token: token);
    if (response.statusCode == 200) {
      return PassagerDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement du passager');
    }
  }

  static Future<PassagerDto> create(PassagerDto passager, String token) async {
    final response = await ApiService.post(_endpoint, passager.toJson(), token: token);
    if (response.statusCode == 201) {
      return PassagerDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création du passager');
    }
  }

  static Future<PassagerDto> update(String id, PassagerDto passager, String token) async {
    final response = await ApiService.put('$_endpoint/$id', passager.toJson(), token: token);
    if (response.statusCode == 200) {
      return PassagerDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour du passager');
    }
  }

  static Future<void> delete(String id, String token) async {
    final response = await ApiService.delete('$_endpoint/$id', token: token);
    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression du passager');
    }
  }
} 
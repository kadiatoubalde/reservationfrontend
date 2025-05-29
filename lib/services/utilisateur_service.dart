import '../models/utilisateurDto.dart';
import 'api_service.dart';
import 'dart:convert';

class UtilisateurService {
  static const String _endpoint = '/utilisateurs';

  static Future<List<UtilisateurDto>> getAll(String token) async {
    final response = await ApiService.get(_endpoint, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UtilisateurDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des utilisateurs');
    }
  }

  static Future<UtilisateurDto> getById(String id, String token) async {
    final response = await ApiService.get('$_endpoint/$id', token: token);
    if (response.statusCode == 200) {
      return UtilisateurDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement de l\'utilisateur');
    }
  }

  static Future<UtilisateurDto> create(UtilisateurDto utilisateur, String token) async {
    final response = await ApiService.post(_endpoint, utilisateur.toJson(), token: token);
    if (response.statusCode == 201) {
      return UtilisateurDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création de l\'utilisateur');
    }
  }

  static Future<UtilisateurDto> update(String id, UtilisateurDto utilisateur, String token) async {
    final response = await ApiService.put('$_endpoint/$id', utilisateur.toJson(), token: token);
    if (response.statusCode == 200) {
      return UtilisateurDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour de l\'utilisateur');
    }
  }

  static Future<void> delete(String id, String token) async {
    final response = await ApiService.delete('$_endpoint/$id', token: token);
    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression de l\'utilisateur');
    }
  }
} 
import '../models/mode_paiement_dto.dart';
import 'api_service.dart';
import 'dart:convert';

class ModePaiementService {
  static const String _endpoint = '/modes-paiement';

  static Future<List<ModePaiementDto>> getAll(String token) async {
    final response = await ApiService.get(_endpoint, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ModePaiementDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des modes de paiement');
    }
  }

  static Future<ModePaiementDto> getById(String id, String token) async {
    final response = await ApiService.get('$_endpoint/$id', token: token);
    if (response.statusCode == 200) {
      return ModePaiementDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement du mode de paiement');
    }
  }

  static Future<ModePaiementDto> create(ModePaiementDto modePaiement, String token) async {
    final response = await ApiService.post(_endpoint, modePaiement.toJson(), token: token);
    if (response.statusCode == 201) {
      return ModePaiementDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création du mode de paiement');
    }
  }

  static Future<ModePaiementDto> update(String id, ModePaiementDto modePaiement, String token) async {
    final response = await ApiService.put('$_endpoint/$id', modePaiement.toJson(), token: token);
    if (response.statusCode == 200) {
      return ModePaiementDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour du mode de paiement');
    }
  }

  static Future<void> delete(String id, String token) async {
    final response = await ApiService.delete('$_endpoint/$id', token: token);
    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression du mode de paiement');
    }
  }
} 
import '../models/paiement_dto.dart';
import 'api_service.dart';
import 'dart:convert';

class PaiementService {
  static const String _endpoint = '/paiements';

  static Future<List<PaiementDto>> getAll(String token) async {
    final response = await ApiService.get(_endpoint, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PaiementDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des paiements');
    }
  }

  static Future<PaiementDto> getById(String id, String token) async {
    final response = await ApiService.get('$_endpoint/$id', token: token);
    if (response.statusCode == 200) {
      return PaiementDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement du paiement');
    }
  }

  static Future<PaiementDto> create(PaiementDto paiement, String token) async {
    final response = await ApiService.post(_endpoint, paiement.toJson(), token: token);
    if (response.statusCode == 201) {
      return PaiementDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création du paiement');
    }
  }

  static Future<PaiementDto> update(String id, PaiementDto paiement, String token) async {
    final response = await ApiService.put('$_endpoint/$id', paiement.toJson(), token: token);
    if (response.statusCode == 200) {
      return PaiementDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour du paiement');
    }
  }

  static Future<void> delete(String id, String token) async {
    final response = await ApiService.delete('$_endpoint/$id', token: token);
    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression du paiement');
    }
  }

  static Future<List<PaiementDto>> getByReservation(String reservationId, String token) async {
    final response = await ApiService.get('$_endpoint/reservation/$reservationId', token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PaiementDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des paiements de la réservation');
    }
  }
} 
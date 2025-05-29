import '../models/reservationDto.dart';
import 'api_service.dart';
import 'dart:convert';

class ReservationService {
  static const String _endpoint = '/reservations';

  static Future<List<ReservationDto>> getAll(String token) async {
    final response = await ApiService.get(_endpoint, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ReservationDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des réservations');
    }
  }

  static Future<ReservationDto> getById(String id, String token) async {
    final response = await ApiService.get('$_endpoint/$id', token: token);
    if (response.statusCode == 200) {
      return ReservationDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement de la réservation');
    }
  }

  static Future<ReservationDto> create(ReservationDto reservation, String token) async {
    final response = await ApiService.post(_endpoint, reservation.toJson(), token: token);
    if (response.statusCode == 201) {
      return ReservationDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création de la réservation');
    }
  }

  static Future<ReservationDto> update(String id, ReservationDto reservation, String token) async {
    final response = await ApiService.put('$_endpoint/$id', reservation.toJson(), token: token);
    if (response.statusCode == 200) {
      return ReservationDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour de la réservation');
    }
  }

  static Future<void> delete(String id, String token) async {
    final response = await ApiService.delete('$_endpoint/$id', token: token);
    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression de la réservation');
    }
  }

  static Future<List<ReservationDto>> getByUtilisateur(String utilisateurId, String token) async {
    final response = await ApiService.get('$_endpoint/utilisateur/$utilisateurId', token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ReservationDto.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des réservations de l\'utilisateur');
    }
  }
} 
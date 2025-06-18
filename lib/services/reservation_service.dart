import '../models/ReservationDto.dart';
import 'api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ma_reservation_dto.dart';

class ReservationService {
  static const String _endpoint = '/reservations';
  static const String baseUrl = 'http://localhost:8080/api';

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

  Future<void> createReservation(ReservationDto reservation, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reservations/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(reservation.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create reservation: \n${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating reservation: $e');
    }
  }

  static Future<List<MaReservationDto>> getMesReservations(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservations/mesReservations'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MaReservationDto.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des réservations');
    }
  }
} 
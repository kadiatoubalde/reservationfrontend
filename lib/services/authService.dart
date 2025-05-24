import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/utilisateur_dto.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080/api/v1/auth';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Tentative de connexion pour: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Réponse: ${response.body}');

    if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final utilisateur = UtilisateurDto.fromJson(data);
        return {
          'success': true,
          'data': utilisateur,
        };
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Une erreur est survenue',
        };
      }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        final utilisateur = UtilisateurDto.fromJson(data);
        return {
          'success': true,
          'data': utilisateur,
        };
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Une erreur est survenue lors de l\'inscription',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de l\'inscription: $e',
      };
    }
  }
}
